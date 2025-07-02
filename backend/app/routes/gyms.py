from flask import Blueprint, request, jsonify
from flask_restx import Namespace, Resource, fields
from flask_jwt_extended import jwt_required

gyms_bp = Blueprint('gyms', __name__)
gyms_ns = Namespace('gyms', description='Gym operations')

# Basic gym model for API documentation
gym_model = gyms_ns.model('Gym', {
    'id': fields.Integer(required=True, description='Gym ID'),
    'name': fields.String(required=True, description='Gym name'),
    'address': fields.String(description='Gym address'),
    'created_at': fields.DateTime(description='Creation timestamp')
})

@gyms_ns.route('/')
class GymList(Resource):
    @gyms_ns.doc('list_gyms')
    @gyms_ns.marshal_list_with(gym_model)
    @jwt_required()
    def get(self):
        """Fetch all gyms"""
        # Placeholder implementation
        return []

    @gyms_ns.doc('create_gym')
    @gyms_ns.marshal_with(gym_model, code=201)
    @jwt_required()
    def post(self):
        """Create a new gym"""
        # Placeholder implementation
        return {'message': 'Gym creation not implemented yet'}, 501

@gyms_ns.route('/<int:gym_id>')
@gyms_ns.param('gym_id', 'The gym identifier')
class GymDetail(Resource):
    @gyms_ns.doc('get_gym')
    @gyms_ns.marshal_with(gym_model)
    @jwt_required()
    def get(self, gym_id):
        """Fetch a gym by ID"""
        # Placeholder implementation
        return {'message': 'Gym detail not implemented yet'}, 501
