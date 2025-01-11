from .. import db
import json
from flask import Blueprint, jsonify, request, Response
from flask_jwt_extended import jwt_required, get_jwt_identity
from ..models.product import Product

bp = Blueprint('product', __name__, url_prefix='/api/product')

@bp.route('', methods=['GET'])
@jwt_required()
def get_products():
    # Get the current user's identity from the token
    current_user = get_jwt_identity()

    # Check if the user is authorized
    if not current_user:
        return jsonify({"error": "Unauthorized access"}), 401

    # Fetch the products
    products = Product.query.all()

    # Convert the product objects to a serializable format
    product_list = [product.to_dict() for product in products]

    #return jsonify(product_list)
    return Response(
        json.dumps(product_list, indent=4, sort_keys=False),  # Prevent sorting of keys by alphabet
        mimetype='application/json'
    )

@bp.route('/<int:product_id>', methods=['GET'])
@jwt_required()
def get_product_by_id(product_id):
    # Get the current user's identity from the token
    current_user = get_jwt_identity()
    
    # Check if the user is authorized
    if not current_user:
        return jsonify({"error": "Unauthorized access"}), 401

    # Fetch the product by ID
    product = Product.query.filter_by(ProductID=product_id).first()

    # Check if the product exists
    if not product:
        return jsonify({"error": "Product not found"}), 404

    # Convert the product object to a serializable format
    product_data = product.to_dict()

    # Return the JSON response with the product details
    return Response(
        json.dumps(product_data, indent=4, sort_keys=False),  # Prevent sorting of keys by alphabet
        mimetype='application/json'
    )