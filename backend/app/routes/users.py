from flask import Blueprint, request, jsonify
from flask_restx import Namespace, Resource, fields
from flask_jwt_extended import jwt_required, get_jwt_identity
from app import db
from app.models.user import User
from app.schemas.user import UserSchema

users_bp = Blueprint('users', __name__)
users_ns = Namespace('users', description='User operations')

# Schemas for API documentation
user_model = users_ns.model('User', {
    'id': fields.Integer(required=True, description='User ID'),
    'email': fields.String(required=True, description='User email'),
    'first_name': fields.String(required=True, description='First name'),
    'last_name': fields.String(required=True, description='Last name'),
    'is_admin': fields.Boolean(description='Admin status'),
    'created_at': fields.DateTime(description='Creation timestamp')
})

user_create_model = users_ns.model('UserCreate', {
    'email': fields.String(required=True, description='User email'),
    'password': fields.String(required=True, description='User password'),
    'first_name': fields.String(required=True, description='First name'),
    'last_name': fields.String(required=True, description='Last name')
})

@users_ns.route('/')
class UserList(Resource):
    @users_ns.doc('list_users')
    @users_ns.marshal_list_with(user_model)
    @jwt_required()
    def get(self):
        """Fetch all users"""
        users = User.query.all()
        schema = UserSchema(many=True)
        return schema.dump(users)

    @users_ns.doc('create_user')
    @users_ns.expect(user_create_model)
    @users_ns.marshal_with(user_model, code=201)
    def post(self):
        """Create a new user"""
        data = request.get_json()
        schema = UserSchema()
        
        try:
            user = User(
                email=data['email'],
                first_name=data['first_name'],
                last_name=data['last_name']
            )
            user.set_password(data['password'])
            
            db.session.add(user)
            db.session.commit()
            
            return schema.dump(user), 201
        except Exception as e:
            db.session.rollback()
            return {'error': str(e)}, 400

@users_ns.route('/<int:user_id>')
@users_ns.param('user_id', 'The user identifier')
class UserDetail(Resource):
    @users_ns.doc('get_user')
    @users_ns.marshal_with(user_model)
    @jwt_required()
    def get(self, user_id):
        """Fetch a user by ID"""
        user = User.query.get_or_404(user_id)
        schema = UserSchema()
        return schema.dump(user)

    @users_ns.doc('update_user')
    @users_ns.marshal_with(user_model)
    @jwt_required()
    def put(self, user_id):
        """Update a user"""
        user = User.query.get_or_404(user_id)
        data = request.get_json()
        
        if 'first_name' in data:
            user.first_name = data['first_name']
        if 'last_name' in data:
            user.last_name = data['last_name']
        if 'email' in data:
            user.email = data['email']
        
        db.session.commit()
        
        schema = UserSchema()
        return schema.dump(user)

    @users_ns.doc('delete_user')
    @jwt_required()
    def delete(self, user_id):
        """Delete a user"""
        user = User.query.get_or_404(user_id)
        db.session.delete(user)
        db.session.commit()
        return '', 204
