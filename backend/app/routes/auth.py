from flask import Blueprint, request, jsonify
from flask_restx import Namespace, Resource, fields
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity
from app import db
from app.models.user import User
from app.schemas.user import UserSchema
from marshmallow import ValidationError

auth_bp = Blueprint('auth', __name__)
auth_ns = Namespace('auth', description='Authentication operations')

# Schemas
user_schema = UserSchema()

# API Models
login_model = auth_ns.model('Login', {
    'email': fields.String(required=True, description='User email'),
    'password': fields.String(required=True, description='User password')
})

register_model = auth_ns.model('Register', {
    'email': fields.String(required=True, description='User email'),
    'password': fields.String(required=True, description='User password'),
    'first_name': fields.String(required=True, description='First name'),
    'last_name': fields.String(required=True, description='Last name'),
    'is_athlete': fields.Boolean(description='Is user an athlete'),
    'is_coach': fields.Boolean(description='Is user a coach')
})

@auth_ns.route('/login')
class Login(Resource):
    @auth_ns.expect(login_model)
    def post(self):
        """User login"""
        try:
            data = request.get_json()
            email = data.get('email')
            password = data.get('password')

            if not email or not password:
                return {'error': 'Email and password required'}, 400

            user = User.query.filter_by(email=email, archived=False).first()

            if not user or not user.check_password(password):
                return {'error': 'Invalid credentials'}, 401

            access_token = create_access_token(identity=user.id)

            return {
                'access_token': access_token,
                'user': user.to_dict()
            }, 200

        except Exception as e:
            return {'error': 'Login failed', 'details': str(e)}, 500

@auth_ns.route('/register')
class Register(Resource):
    @auth_ns.expect(register_model)
    def post(self):
        """User registration"""
        try:
            data = request.get_json()

            # Validate input
            if User.query.filter_by(email=data.get('email')).first():
                return {'error': 'Email already exists'}, 400

            # Create new user
            user = User(
                email=data.get('email'),
                first_name=data.get('first_name'),
                last_name=data.get('last_name'),
                is_athlete=data.get('is_athlete', False),
                is_coach=data.get('is_coach', False)
            )
            user.set_password(data.get('password'))

            # Ensure user has at least one role
            if not (user.is_athlete or user.is_coach):
                user.is_athlete = True

            db.session.add(user)
            db.session.commit()

            access_token = create_access_token(identity=user.id)

            return {
                'access_token': access_token,
                'user': user.to_dict()
            }, 201

        except Exception as e:
            db.session.rollback()
            return {'error': 'Registration failed', 'details': str(e)}, 500

@auth_ns.route('/me')
class CurrentUser(Resource):
    @jwt_required()
    def get(self):
        """Get current user info"""
        try:
            user_id = get_jwt_identity()
            user = User.query.get(user_id)

            if not user or user.archived:
                return {'error': 'User not found'}, 404

            return {'user': user.to_dict()}, 200

        except Exception as e:
            return {'error': 'Failed to get user info', 'details': str(e)}, 500

@auth_ns.route('/refresh')
class RefreshToken(Resource):
    @jwt_required()
    def post(self):
        """Refresh access token"""
        try:
            user_id = get_jwt_identity()
            user = User.query.get(user_id)

            if not user or user.archived:
                return {'error': 'User not found'}, 404

            access_token = create_access_token(identity=user_id)

            return {'access_token': access_token}, 200

        except Exception as e:
            return {'error': 'Token refresh failed', 'details': str(e)}, 500

@auth_ns.route('/logout')
class Logout(Resource):
    @jwt_required()
    def post(self):
        """User logout"""
        # In a production app, you'd add the token to a blacklist
        return {'message': 'Successfully logged out'}, 200
