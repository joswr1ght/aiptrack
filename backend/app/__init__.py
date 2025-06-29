from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager
from flask_restx import Api
from flask_cors import CORS
from flask_migrate import Migrate
from marshmallow import ValidationError
import os

# Initialize extensions
db = SQLAlchemy()
jwt = JWTManager()
migrate = Migrate()

def create_app(config_name=None):
    """Application factory pattern"""
    app = Flask(__name__)

    # Load configuration
    config_name = config_name or os.getenv('FLASK_ENV', 'development')
    app.config.from_object(f'app.config.{config_name.title()}Config')

    # Initialize extensions
    db.init_app(app)
    jwt.init_app(app)
    migrate.init_app(app, db)
    CORS(app)

    # Initialize API
    api = Api(
        app,
        version='1.0',
        title='AIP Track API',
        description='All In Performance Athlete Tracking API',
        doc='/api/docs/',
        prefix='/api'
    )

    # Register blueprints
    from app.routes.auth import auth_bp, auth_ns
    from app.routes.users import users_bp, users_ns
    from app.routes.gyms import gyms_bp, gyms_ns
    from app.routes.exercises import exercises_bp, exercises_ns
    from app.routes.metrics import metrics_bp, metrics_ns
    from app.routes.cohorts import cohorts_bp, cohorts_ns
    from app.routes.health import health_bp

    app.register_blueprint(auth_bp)
    app.register_blueprint(users_bp)
    app.register_blueprint(gyms_bp)
    app.register_blueprint(exercises_bp)
    app.register_blueprint(metrics_bp)
    app.register_blueprint(cohorts_bp)
    app.register_blueprint(health_bp)

    # Add namespaces to API
    api.add_namespace(auth_ns)
    api.add_namespace(users_ns)
    api.add_namespace(gyms_ns)
    api.add_namespace(exercises_ns)
    api.add_namespace(metrics_ns)
    api.add_namespace(cohorts_ns)

    # Error handlers
    @app.errorhandler(ValidationError)
    def handle_validation_error(e):
        return {'error': 'Validation failed', 'details': e.messages}, 400

    @app.errorhandler(404)
    def handle_not_found(e):
        return {'error': 'Resource not found'}, 404

    @app.errorhandler(500)
    def handle_internal_error(e):
        return {'error': 'Internal server error'}, 500

    return app
