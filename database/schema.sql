-- Enable UUID extension for PostgreSQL (remove if using MySQL/MariaDB)
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users Data table
CREATE TABLE users (
    id VARCHAR(36) PRIMARY KEY,
    external_id VARCHAR(255),
    archived BOOLEAN DEFAULT FALSE NOT NULL,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    nick_name VARCHAR(100),
    date_of_birth DATE,
    sex ENUM('M', 'F', 'Other'),
    height DECIMAL(5,3), -- meters, allows up to 99.999m
    weight DECIMAL(6,2), -- kilograms, allows up to 9999.99kg
    profile_image_url VARCHAR(500),
    last_tested DATE,
    is_athlete BOOLEAN DEFAULT FALSE NOT NULL,
    is_coach BOOLEAN DEFAULT FALSE NOT NULL,
    is_admin BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,

    UNIQUE KEY unique_email (email),
    INDEX idx_users_external_id (external_id),
    INDEX idx_users_email (email),
    INDEX idx_users_roles (is_athlete, is_coach, is_admin),
    INDEX idx_users_archived (archived)
);

-- Gym Data table
CREATE TABLE gyms (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(255),
    website VARCHAR(255),
    archived BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,

    INDEX idx_gyms_name (name),
    INDEX idx_gyms_archived (archived)
);

-- User-Gym Relationships
CREATE TABLE user_gym_relationships (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    gym_id VARCHAR(36) NOT NULL,
    role ENUM('athlete', 'coach') NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    is_approved BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (gym_id) REFERENCES gyms(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_gym_role (user_id, gym_id, role),
    INDEX idx_user_gym_user_id (user_id),
    INDEX idx_user_gym_gym_id (gym_id),
    INDEX idx_user_gym_role (role),
    INDEX idx_user_gym_active (is_active),
    INDEX idx_user_gym_approved (is_approved)
);

-- User-Coach Relationships
CREATE TABLE user_coach_relationships (
    id VARCHAR(36) PRIMARY KEY,
    athlete_id VARCHAR(36) NOT NULL,
    coach_id VARCHAR(36) NOT NULL,
    gym_id VARCHAR(36) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,

    FOREIGN KEY (athlete_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (coach_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (gym_id) REFERENCES gyms(id) ON DELETE CASCADE,
    UNIQUE KEY unique_athlete_coach_gym (athlete_id, coach_id, gym_id),
    INDEX idx_user_coach_athlete_id (athlete_id),
    INDEX idx_user_coach_coach_id (coach_id),
    INDEX idx_user_coach_gym_id (gym_id),
    INDEX idx_user_coach_active (is_active)
);

-- Cohort Definition
CREATE TABLE cohorts (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    color VARCHAR(7), -- hex color code #RRGGBB
    image_url VARCHAR(500),
    coach_id VARCHAR(36) NOT NULL,
    gym_id VARCHAR(36) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,

    FOREIGN KEY (coach_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (gym_id) REFERENCES gyms(id) ON DELETE CASCADE,
    INDEX idx_cohorts_coach_id (coach_id),
    INDEX idx_cohorts_gym_id (gym_id),
    INDEX idx_cohorts_name (name),
    INDEX idx_cohorts_active (is_active)
);

-- Cohort Membership
CREATE TABLE cohort_memberships (
    id VARCHAR(36) PRIMARY KEY,
    cohort_id VARCHAR(36) NOT NULL,
    athlete_id VARCHAR(36) NOT NULL,
    joined_at DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,

    FOREIGN KEY (cohort_id) REFERENCES cohorts(id) ON DELETE CASCADE,
    FOREIGN KEY (athlete_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_cohort_athlete (cohort_id, athlete_id),
    INDEX idx_cohort_membership_cohort_id (cohort_id),
    INDEX idx_cohort_membership_athlete_id (athlete_id),
    INDEX idx_cohort_membership_active (is_active)
);

-- Responsible Party Data
CREATE TABLE responsible_parties (
    id VARCHAR(36) PRIMARY KEY,
    athlete_id VARCHAR(36) NOT NULL,
    archived BOOLEAN DEFAULT FALSE NOT NULL,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    relationship VARCHAR(50), -- parent, guardian, spouse, etc.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,

    FOREIGN KEY (athlete_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_responsible_parties_athlete_id (athlete_id),
    INDEX idx_responsible_parties_email (email),
    INDEX idx_responsible_parties_archived (archived)
);

-- Exercise Definition
CREATE TABLE exercises (
    id VARCHAR(36) PRIMARY KEY,
    is_enabled BOOLEAN DEFAULT TRUE NOT NULL,
    creator_id VARCHAR(36),
    name VARCHAR(255) NOT NULL,
    creator_name VARCHAR(255),
    category ENUM('custom', 'system') NOT NULL,
    instructions TEXT,
    instruction_video_id VARCHAR(255),
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,

    FOREIGN KEY (creator_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_exercises_name (name),
    INDEX idx_exercises_category (category),
    INDEX idx_exercises_creator_id (creator_id),
    INDEX idx_exercises_enabled (is_enabled)
);

-- Exercise Body Segments
CREATE TABLE exercise_body_segments (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    exercise_id VARCHAR(36) NOT NULL,
    description TEXT,

    FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE,
    INDEX idx_exercise_body_segments_exercise_id (exercise_id),
    INDEX idx_exercise_body_segments_name (name)
);

-- Exercise Equipment
CREATE TABLE exercise_equipment (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    exercise_id VARCHAR(36) NOT NULL,
    description TEXT,

    FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE,
    INDEX idx_exercise_equipment_exercise_id (exercise_id),
    INDEX idx_exercise_equipment_name (name)
);

-- Exercise Search Terms
CREATE TABLE exercise_search_terms (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    exercise_id VARCHAR(36) NOT NULL,
    description TEXT,

    FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE,
    INDEX idx_exercise_search_terms_exercise_id (exercise_id),
    INDEX idx_exercise_search_terms_name (name)
);

-- Exercise Metrics
CREATE TABLE exercise_metrics (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    exercise_id VARCHAR(36) NOT NULL,
    is_enabled BOOLEAN DEFAULT TRUE NOT NULL,
    display_units ENUM('metric', 'imperial') DEFAULT 'metric' NOT NULL,
    unit_of_measure ENUM('Meter', 'Kilogram', 'Second', 'Newton', 'Watt', 'Number') NOT NULL,
    decimals INT DEFAULT 2 NOT NULL,
    min_value DECIMAL(15,6),
    max_value DECIMAL(15,6),
    default_value DECIMAL(15,6),

    FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE,
    INDEX idx_exercise_metrics_exercise_id (exercise_id),
    INDEX idx_exercise_metrics_name (name),
    INDEX idx_exercise_metrics_enabled (is_enabled),

    CHECK (decimals >= 0 AND decimals <= 6),
    CHECK (min_value IS NULL OR max_value IS NULL OR min_value <= max_value)
);

-- Performance Metrics
CREATE TABLE performance_metrics (
    id VARCHAR(36) PRIMARY KEY,
    athlete_id VARCHAR(36) NOT NULL,
    exercise_id VARCHAR(36) NOT NULL,
    coach_id VARCHAR(36) NOT NULL,
    gym_id VARCHAR(36) NOT NULL,
    exercise_metric_id VARCHAR(36) NOT NULL,
    value DECIMAL(15,6) NOT NULL,
    date DATE NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,

    FOREIGN KEY (athlete_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE,
    FOREIGN KEY (coach_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (gym_id) REFERENCES gyms(id) ON DELETE CASCADE,
    FOREIGN KEY (exercise_metric_id) REFERENCES exercise_metrics(id) ON DELETE CASCADE,

    INDEX idx_performance_metrics_athlete_id (athlete_id),
    INDEX idx_performance_metrics_exercise_id (exercise_id),
    INDEX idx_performance_metrics_coach_id (coach_id),
    INDEX idx_performance_metrics_gym_id (gym_id),
    INDEX idx_performance_metrics_metric_id (exercise_metric_id),
    INDEX idx_performance_metrics_date (date),
    INDEX idx_performance_metrics_athlete_date (athlete_id, date),
    INDEX idx_performance_metrics_athlete_exercise (athlete_id, exercise_id)
);

-- Notifications table (for tracking notification preferences and history)
CREATE TABLE notifications (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    type ENUM('performance_update', 'cohort_invitation', 'system_alert') NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE NOT NULL,
    sent_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_notifications_user_id (user_id),
    INDEX idx_notifications_type (type),
    INDEX idx_notifications_read (is_read),
    INDEX idx_notifications_sent_at (sent_at)
);

-- User preferences for notifications
CREATE TABLE user_notification_preferences (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    email_notifications BOOLEAN DEFAULT TRUE NOT NULL,
    performance_updates BOOLEAN DEFAULT TRUE NOT NULL,
    cohort_updates BOOLEAN DEFAULT TRUE NOT NULL,
    system_alerts BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_preferences (user_id)
);

-- Add constraints to ensure data integrity
ALTER TABLE users ADD CONSTRAINT check_user_has_role
    CHECK (is_athlete = TRUE OR is_coach = TRUE OR is_admin = TRUE);

ALTER TABLE users ADD CONSTRAINT check_height_positive
    CHECK (height IS NULL OR height > 0);

ALTER TABLE users ADD CONSTRAINT check_weight_positive
    CHECK (weight IS NULL OR weight > 0);

ALTER TABLE cohorts ADD CONSTRAINT check_color_format
    CHECK (color IS NULL OR color REGEXP '^#[0-9A-Fa-f]{6}$');

ALTER TABLE exercise_metrics ADD CONSTRAINT check_decimals_range
    CHECK (decimals >= 0 AND decimals <= 6);
