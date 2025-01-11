from .. import db
import json
from sqlalchemy.sql import func
from sqlalchemy import cast, Date
from flask import Blueprint, jsonify, request, Response
from flask_jwt_extended import jwt_required, get_jwt_identity
from ..models.product import Product

bp = Blueprint('product', __name__, url_prefix='/api/product')

@bp.route('', methods=['GET'])
@jwt_required()
def get_products():
    # Get the current user's identity from the token
    current_user = json.loads(get_jwt_identity())
    print("Decoded Identity:", current_user)  # Debugging
    user_id = int(current_user["user_id"])
    is_admin = current_user["is_admin"]
    print("user_id, is_admin: ", user_id, is_admin)  # Debugging

    # Check if the user is authorized
    if not current_user:
        return jsonify({"error": "Unauthorized access"}), 401

    # Fetch products where DeletedAt is either NULL or '1900-01-01'
    products = Product.query.filter(
        (Product.DeletedAt == None) | (cast(Product.DeletedAt, Date) == '1900-01-01')
    ).all()

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
    current_user = json.loads(get_jwt_identity())
    
    # Check if the user is authorized
    if not current_user:
        return jsonify({"error": "Unauthorized access"}), 401

    # Fetch the product by ID, where DeletedAt is NULL or '1900-01-01'
    product = Product.query.filter(
        Product.ProductID == product_id,
        (Product.DeletedAt == None) | (cast(Product.DeletedAt, Date) == '1900-01-01')
    ).first()

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

@bp.route('', methods=['POST'])
@jwt_required()
def create_product():
    # Get the current user's identity from the token
    current_user = json.loads(get_jwt_identity())
    
    # Check if the user is an admin (for authorization purposes)
    if not current_user or not current_user.get('is_admin'):
        return jsonify({"error": "Unauthorized access"}), 401
    
    # Get the product data from the request
    data = request.get_json()

    # Validate the required fields
    required_fields = ['ProductName', 'Price']
    for field in required_fields:
        if field not in data:
            return jsonify({"error": f"Missing required field: {field}"}), 400
    
    # Create a new product
    new_product = Product(
        ProductName=data['ProductName'],
        Description=data.get('Description'),
        Price=data['Price'],
        ImageUrl=data.get('ImageUrl')
    )
    
    # Add the product to the database and commit
    db.session.add(new_product)
    db.session.commit()

    # Convert the new product object to a serializable format
    product_data = new_product.to_dict()

    return Response(
        json.dumps(product_data, indent=4, sort_keys=False),
        mimetype='application/json',
        status=201
    )

@bp.route('/<int:product_id>', methods=['PUT'])
@jwt_required()
def update_product(product_id):
    # Get the current user's identity from the token
    current_user = json.loads(get_jwt_identity())

    # Check if the user is an admin (for authorization purposes)
    if not current_user or not current_user.get('is_admin'):
        return jsonify({"error": "Unauthorized access"}), 401

    # Fetch the product by ID
    product = Product.query.filter_by(ProductID=product_id).first()

    # Check if the product exists
    if not product:
        return jsonify({"error": "Product not found"}), 404

    # Get the updated data from the request
    data = request.get_json()

    # Update the fields of the product
    if 'ProductName' in data:
        product.ProductName = data['ProductName']
    if 'Description' in data:
        product.Description = data['Description']
    if 'Price' in data:
        product.Price = data['Price']
    if 'ImageUrl' in data:
        product.ImageUrl = data['ImageUrl']

    # Commit the changes to the database
    db.session.commit()

    # Convert the updated product object to a serializable format
    product_data = product.to_dict()

    return Response(
        json.dumps(product_data, indent=4, sort_keys=False),
        mimetype='application/json'
    )

@bp.route('/<int:product_id>', methods=['DELETE'])
@jwt_required()
def delete_product(product_id):
    # Get the current user's identity from the token
    current_user = json.loads(get_jwt_identity())

    # Check if the user is an admin (for authorization purposes)
    if not current_user or not current_user.get('is_admin'):
        return jsonify({"error": "Unauthorized access"}), 401

    # Fetch the product by ID
    product = Product.query.filter_by(ProductID=product_id).first()

    # Check if the product exists
    if not product:
        return jsonify({"error": "Product not found"}), 404

    # Update the DeletedAt field to perform soft deletion
    product.DeletedAt = func.now()

    # Commit the changes to the database
    db.session.commit()

    return jsonify({"message": "Product successfully deleted."}), 200