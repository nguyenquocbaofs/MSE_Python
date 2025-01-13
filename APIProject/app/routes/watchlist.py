from .. import db
import json
from sqlalchemy.sql import func
from flask import Blueprint, jsonify, request, Response
from flask_jwt_extended import jwt_required, get_jwt_identity
from ..models.userWatchlist import UserWatchlist

bp = Blueprint('watchlist', __name__, url_prefix='/api/watchlist')

@bp.route('', methods=['GET'])
@jwt_required()
def get_watchlists():
    # Get the current user's identity from the token
    current_user = json.loads(get_jwt_identity())

    # Check if the user is authorized
    if not current_user:
        return jsonify({"error": "Unauthorized access"}), 401

    watchlist = UserWatchlist.query.filter(
       UserWatchlist.UserID == current_user['user_id'] and UserWatchlist.RemovedAt == None
    ).all()

    response = [item.to_dict() for item in watchlist]

    return Response(
        json.dumps(response, indent=4, sort_keys=False),  # Prevent sorting of keys by alphabet
        mimetype='application/json'
    )

@bp.route('<int:product_id>', methods=['POST'])
@jwt_required()
def add_watchlists(product_id):
    # Get the current user's identity from the token
    current_user = json.loads(get_jwt_identity())

    # Check if the user is authorized
    if not current_user:
        return jsonify({"error": "Unauthorized access"}), 401

    watchlist = UserWatchlist.query.filter(
       UserWatchlist.UserID == current_user['user_id'] and UserWatchlist.ProductID == product_id and UserWatchlist.RemovedAt == None
    ).all()

    if watchlist:
        return jsonify({"messsage": "Already added"}), 200 

    new_watchlist_item = UserWatchlist(
        UserID=current_user['user_id'],
        ProductID=product_id
    )

    response = [item.to_dict() for item in watchlist]

    return jsonify({"messsage": "Successfully added"}), 200 

@bp.route('<int:watchlist_id>', methods=['DELETE'])
@jwt_required()
def remove_watchlists(watchlist_id):
    # Get the current user's identity from the token
    current_user = json.loads(get_jwt_identity())

    # Check if the user is authorized
    if not current_user:
        return jsonify({"error": "Unauthorized access"}), 401

    watchlist = UserWatchlist.query.filter(
       UserWatchlist.WatchlistID == watchlist_id and UserWatchlist.RemovedAt == None
    ).all()

    if not watchlist:
        return jsonify({"messsage": "Not found"}), 404 

    # Update the DeletedAt field to perform soft deletion
    watchlist.RemovedAt = func.now()

    # Commit the changes to the database
    db.session.commit()

    return jsonify({"message": "Watchlist item successfully removed."}), 200