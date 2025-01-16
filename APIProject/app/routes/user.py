from .. import db
import json
from flask import Blueprint, jsonify, request, Response
from flask_jwt_extended import jwt_required, get_jwt_identity
from ..models.user import User

bp = Blueprint('user', __name__, url_prefix='/api/user')

@bp.route('/profile', methods=['GET'])
@jwt_required()
def profile():
    # Get the current user's identity from the token
    current_user = json.loads(get_jwt_identity())
    
    # Check if the user is an admin (for authorization purposes)
    if not current_user:
        return jsonify({"error": "Unauthorized access"}), 401

    user = User.query.filter_by(UserID=current_user.get('user_id')).first()
    
    if not user:
        return jsonify({"message": "Invalid User"}), 401

    user_profile = user.to_dict()

    return Response(
        json.dumps(user_profile, indent=4, sort_keys=False),  # Prevent sorting of keys by alphabet
        mimetype='application/json'
    )

@bp.route('/profile', methods=['PUT'])
@jwt_required()
def update_profile():
    # Get the current user's identity from the token
    current_user = json.loads(get_jwt_identity())
    
    # Check if the user is an admin (for authorization purposes)
    if not current_user:
        return jsonify({"error": "Unauthorized access"}), 401

    user = User.query.filter_by(UserID=current_user.get('user_id')).first()
    
    if not user:
        return jsonify({"message": "Invalid User"}), 401

    # Get the updated data from the request
    data = request.get_json()

    # Update the fields of the product
    if 'Address' in data:
        user.Address = data['Address']
    if 'Gender' in data:
        user.Gender = data['Gender']
    if 'Mobile' in data:
        user.Mobile = data['Mobile']

    db.session.commit()
    user_response = user.to_dict()
    return Response(
        json.dumps(user_response, indent=4, sort_keys=False),  # Prevent sorting of keys by alphabet
        mimetype='application/json'
    )