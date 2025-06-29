from app import db
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime
import uuid

class User(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    external_id = db.Column(db.String(255), nullable=True)
    archived = db.Column(db.Boolean, default=False, nullable=False)
    email = db.Column(db.String(255), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=True)
    first_name = db.Column(db.String(100), nullable=False)
    last_name = db.Column(db.String(100), nullable=False)
    nick_name = db.Column(db.String(100), nullable=True)
    date_of_birth = db.Column(db.Date, nullable=True)
    sex = db.Column(db.Enum('M', 'F', 'Other', name='sex_enum'), nullable=True)
    height = db.Column(db.Numeric(5, 3), nullable=True)  # meters
    weight = db.Column(db.Numeric(6, 2), nullable=True)  # kilograms
    profile_image_url = db.Column(db.String(500), nullable=True)
    last_tested = db.Column(db.Date, nullable=True)
    is_athlete = db.Column(db.Boolean, default=False, nullable=False)
    is_coach = db.Column(db.Boolean, default=False, nullable=False)
    is_admin = db.Column(db.Boolean, default=False, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    gym_relationships = db.relationship('UserGymRelationship', back_populates='user', cascade='all, delete-orphan')
    coached_athletes = db.relationship('UserCoachRelationship', foreign_keys='UserCoachRelationship.coach_id', back_populates='coach')
    athlete_coaches = db.relationship('UserCoachRelationship', foreign_keys='UserCoachRelationship.athlete_id', back_populates='athlete')

    def set_password(self, password):
        """Set password hash"""
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        """Check password against hash"""
        return check_password_hash(self.password_hash, password)

    def has_role(self, role):
        """Check if user has specific role"""
        if role == 'athlete':
            return self.is_athlete
        elif role == 'coach':
            return self.is_coach
        elif role == 'admin':
            return self.is_admin
        return False

    def to_dict(self):
        """Convert to dictionary"""
        return {
            'id': self.id,
            'email': self.email,
            'first_name': self.first_name,
            'last_name': self.last_name,
            'nick_name': self.nick_name,
            'is_athlete': self.is_athlete,
            'is_coach': self.is_coach,
            'is_admin': self.is_admin,
            'created_at': self.created_at.isoformat(),
            'updated_at': self.updated_at.isoformat()
        }

class UserGymRelationship(db.Model):
    __tablename__ = 'user_gym_relationships'

    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = db.Column(db.String(36), db.ForeignKey('users.id'), nullable=False)
    gym_id = db.Column(db.String(36), db.ForeignKey('gyms.id'), nullable=False)
    role = db.Column(db.Enum('athlete', 'coach', name='gym_role_enum'), nullable=False)
    is_active = db.Column(db.Boolean, default=True, nullable=False)
    is_approved = db.Column(db.Boolean, default=False, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)

    # Relationships
    user = db.relationship('User', back_populates='gym_relationships')
    gym = db.relationship('Gym', back_populates='user_relationships')

class UserCoachRelationship(db.Model):
    __tablename__ = 'user_coach_relationships'

    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    athlete_id = db.Column(db.String(36), db.ForeignKey('users.id'), nullable=False)
    coach_id = db.Column(db.String(36), db.ForeignKey('users.id'), nullable=False)
    gym_id = db.Column(db.String(36), db.ForeignKey('gyms.id'), nullable=False)
    is_active = db.Column(db.Boolean, default=True, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)

    # Relationships
    athlete = db.relationship('User', foreign_keys=[athlete_id], back_populates='athlete_coaches')
    coach = db.relationship('User', foreign_keys=[coach_id], back_populates='coached_athletes')
    gym = db.relationship('Gym')
