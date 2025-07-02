from flask import Blueprint, request, jsonify
from flask_restx import Namespace, Resource, fields
from flask_jwt_extended import jwt_required

exercises_bp = Blueprint('exercises', __name__)
exercises_ns = Namespace('exercises', description='Exercise operations')

# Basic exercise model for API documentation
exercise_model = exercises_ns.model('Exercise', {
    'id': fields.Integer(required=True, description='Exercise ID'),
    'name': fields.String(required=True, description='Exercise name'),
    'category': fields.String(description='Exercise category'),
    'description': fields.String(description='Exercise description'),
    'created_at': fields.DateTime(description='Creation timestamp')
})

@exercises_ns.route('/')
class ExerciseList(Resource):
    @exercises_ns.doc('list_exercises')
    @exercises_ns.marshal_list_with(exercise_model)
    @jwt_required()
    def get(self):
        """Fetch all exercises"""
        # Placeholder implementation
        return []

    @exercises_ns.doc('create_exercise')
    @exercises_ns.marshal_with(exercise_model, code=201)
    @jwt_required()
    def post(self):
        """Create a new exercise"""
        # Placeholder implementation
        return {'message': 'Exercise creation not implemented yet'}, 501

@exercises_ns.route('/<int:exercise_id>')
@exercises_ns.param('exercise_id', 'The exercise identifier')
class ExerciseDetail(Resource):
    @exercises_ns.doc('get_exercise')
    @exercises_ns.marshal_with(exercise_model)
    @jwt_required()
    def get(self, exercise_id):
        """Fetch an exercise by ID"""
        # Placeholder implementation
        return {'message': 'Exercise detail not implemented yet'}, 501
