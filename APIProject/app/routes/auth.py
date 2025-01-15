from .. import db
from flask import Blueprint, jsonify, request
from flask_jwt_extended import create_access_token, create_refresh_token
from ..models.user import User
import json

bp = Blueprint('auth', __name__, url_prefix='/api/auth')

@bp.route('/register', methods=['POST'])
def register():
    data = request.json
    username = data.get('username')
    password = data.get('password')
    email = data.get('email')
    mobile = data.get('mobile')
    address = data.get('address')
    gender = data.get('gender')

    if not username or not password or not email:
        return jsonify({"message": "All fields are required"}), 400

    if User.query.filter_by(Username=username).first():
        return jsonify({"message": "Username already exists"}), 400

    if User.query.filter_by(Email=email).first():
        return jsonify({"message": "Email already registered"}), 400

    user = User(Username=username, Email=email, Mobile=mobile, Address=address, Gender=gender)
    user.set_password(password)
    db.session.add(user)
    db.session.commit()

    return jsonify({"message": "User registered successfully"}), 201

@bp.route('/login', methods=['POST'])
def login():
    data = request.json
    username = data.get('username')
    password = data.get('password')

    if not username or not password:
        return jsonify({"message": "Username and password are required"}), 400

    user = User.query.filter_by(Username=username).first()
    if not user or not user.check_password(password):
        return jsonify({"message": "Invalid username or password"}), 401

    access_token = create_access_token(identity=json.dumps({"user_id": user.UserID, "is_admin": user.IsAdmin}))
    refresh_token = create_refresh_token(identity=json.dumps({"user_id": user.UserID, "is_admin": user.IsAdmin}))

    return jsonify({
        "access_token": access_token,
        "refresh_token": refresh_token
    }), 200

