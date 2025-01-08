from .. import db
from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from ..models.product import Product

bp = Blueprint('admin', __name__, url_prefix='/api/admin')

