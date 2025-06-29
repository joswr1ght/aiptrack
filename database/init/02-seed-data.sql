-- Create test database
CREATE DATABASE IF NOT EXISTS aiptrack_test;

-- Grant permissions for test database
GRANT ALL PRIVILEGES ON aiptrack_test.* TO 'aiptrack_user'@'%';

-- Insert some basic seed data for development
USE aiptrack;

-- Insert system exercises
INSERT INTO exercises (id, is_enabled, creator_id, name, creator_name, category, instructions, created_at, updated_at) VALUES
('550e8400-e29b-41d4-a716-446655440000', TRUE, NULL, 'Squat', 'System', 'system', 'Stand with feet shoulder-width apart, lower body by bending knees and hips.', NOW(), NOW()),
('550e8400-e29b-41d4-a716-446655440001', TRUE, NULL, 'Deadlift', 'System', 'system', 'Lift weight from ground to hip level with straight back.', NOW(), NOW()),
('550e8400-e29b-41d4-a716-446655440002', TRUE, NULL, 'Bench Press', 'System', 'system', 'Press weight upward while lying on bench.', NOW(), NOW());

-- Insert basic exercise metrics
INSERT INTO exercise_metrics (id, name, exercise_id, is_enabled, display_units, unit_of_measure, decimals) VALUES
('660e8400-e29b-41d4-a716-446655440000', 'Weight', '550e8400-e29b-41d4-a716-446655440000', TRUE, 'metric', 'Kilogram', 2),
('660e8400-e29b-41d4-a716-446655440001', 'Reps', '550e8400-e29b-41d4-a716-446655440000', TRUE, 'metric', 'Number', 0),
('660e8400-e29b-41d4-a716-446655440002', 'Weight', '550e8400-e29b-41d4-a716-446655440001', TRUE, 'metric', 'Kilogram', 2),
('660e8400-e29b-41d4-a716-446655440003', 'Reps', '550e8400-e29b-41d4-a716-446655440001', TRUE, 'metric', 'Number', 0);

FLUSH PRIVILEGES;
