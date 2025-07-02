from flask import Blueprint
from sqlalchemy import text
from app import db

health_bp = Blueprint('health', __name__)

@health_bp.route('/api/health')
def health_check():
    """Health check endpoint"""
    try:
        # Test database connection
        db.session.execute(text('SELECT 1'))

        return {
            'status': 'healthy',
            'database': 'connected'
        }, 200
    except Exception as e:
        return {
            'status': 'unhealthy',
            'database': 'disconnected',
            'error': str(e)
        }, 500
