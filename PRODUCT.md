# Product Definition

All In Performance (AIP) Athlete Tracking is a web application designed to help athletes and coaches track performance metrics, analyze progress over time.
The application provides a user-friendly interface for coaches to log athlete metrics for specified exercises.

## Architecture

+ **Frontend**: The frontend is built using React, providing a responsive and interactive user interface.
+ **Backend**: The backend is built using Flask, serving as the API for the frontend.
+ **Database**: The application uses MariaDB for data storage, ensuring reliable and efficient data management.

The application uses a RESTful API architecture, allowing for clear separation between the frontend and backend.
This enables easy scalability and maintainability of the application.

The application is written for use in a Docker container, ensuring consistent deployment across different environments.

Users will interact with the application using a web browser, accessing the frontend hosted on a nginx server.

### Technical Stack Details

+ **Frontend Framework**: React 18+ with TypeScript
+ **State Management**: React Context API or Redux Toolkit
+ **Styling**: Tailwind CSS 3.x
+ **Icons**: Font Awesome 6.x
+ **HTTP Client**: Axios
+ **Form Handling**: React Hook Form
+ **Date Handling**: date-fns
+ **Charts/Visualization**: Chart.js or Recharts
+ **Testing**: Jest + React Testing Library

+ **Backend Framework**: Flask 2.x with Python 3.9+
+ **API Documentation**: Flask-RESTX (Swagger)
+ **Authentication**: Flask-JWT-Extended
+ **Database ORM**: SQLAlchemy 2.x
+ **Migration Tool**: Alembic
+ **Validation**: Marshmallow
+ **Testing**: pytest + Flask-Testing

+ **Database**: MariaDB 10.6+
+ **File Storage**: Local filesystem or S3-compatible storage
+ **Web Server**: nginx 1.20+
+ **Container Runtime**: Docker + docker-compose

## API Specifications

### Authentication Endpoints
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `POST /api/auth/refresh` - Token refresh
- `POST /api/auth/logout` - User logout
- `GET /api/auth/me` - Get current user info

### Core Entity Endpoints
- Athletes: `/api/athletes/*`
- Coaches: `/api/coaches/*`
- Exercises: `/api/exercises/*`
- Metrics: `/api/metrics/*`
- Cohorts: `/api/cohorts/*`
- Gyms: `/api/gyms/*`

### Data Flow Requirements
- All API responses must include proper HTTP status codes
- Error responses must follow consistent format: `{"error": "message", "details": {}}`
- Pagination for list endpoints: `{"data": [], "pagination": {"page": 1, "per_page": 20, "total": 100}}`
- All dates in ISO 8601 format
- All measurements in SI units as specified

## Project Structure

```
/Users/jwright/Dev/aiptrack/
├── frontend/                 # React application
│   ├── src/
│   │   ├── components/       # Reusable UI components
│   │   ├── pages/           # Page components
│   │   ├── hooks/           # Custom React hooks
│   │   ├── services/        # API service layer
│   │   ├── utils/           # Utility functions
│   │   ├── types/           # TypeScript type definitions
│   │   └── contexts/        # React contexts
│   ├── public/
│   └── package.json
├── backend/                  # Flask application
│   ├── app/
│   │   ├── models/          # SQLAlchemy models
│   │   ├── routes/          # API route handlers
│   │   ├── schemas/         # Marshmallow schemas
│   │   ├── services/        # Business logic layer
│   │   └── utils/           # Utility functions
│   ├── migrations/          # Alembic migrations
│   ├── tests/
│   └── requirements.txt
├── docker/                   # Docker configuration
├── docs/                     # Documentation
└── scripts/                  # Development scripts
```

## Deployment & Infrastructure

### Environment Configuration

- Development: Local Docker containers
- Staging: Cloud-based containers (optional)
- Production: Cloud deployment with SSL/TLS

### Required Environment Variables

```
# Database
DATABASE_URL=mysql://user:pass@host:port/dbname
DATABASE_TEST_URL=mysql://user:pass@host:port/test_dbname

# Authentication
JWT_SECRET_KEY=your-secret-key
JWT_ACCESS_TOKEN_EXPIRES=36000

# External Services
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret

# File Storage
UPLOAD_FOLDER=/app/uploads
MAX_CONTENT_LENGTH=16777216  # 16MB

# Flask
FLASK_ENV=development|production
SECRET_KEY=your-flask-secret-key
```

### Docker Configuration Requirements

- Multi-stage builds for production optimization
- Health checks for all services
- Volume mounts for development
- Environment-specific configurations

## Testing Requirements

### Frontend Testing

- Unit tests for utility functions (>90% coverage)
- Component tests for UI components (>80% coverage)
- Integration tests for API interactions
- E2E tests for critical user flows

### Backend Testing

- Unit tests for services and utilities (>90% coverage)
- Integration tests for API endpoints (>85% coverage)
- Database migration tests
- Authentication flow tests

### Test Data Requirements

- Fixture data for all entity types
- Mock data generators for performance testing
- Test database seeding scripts

## Development Workflow

### Code Quality Standards

- TypeScript strict mode enabled
- ESLint + Prettier for code formatting
- Python Black + isort for backend formatting
- Pre-commit hooks for code quality checks
- Husky for Git hooks

### Database Management

- All schema changes via migrations
- Seed data scripts for development
- Backup/restore procedures
- Performance monitoring queries

### Security Requirements

- Input validation on all endpoints
- SQL injection prevention via ORM
- XSS protection headers
- CSRF protection for state-changing operations
- Rate limiting on authentication endpoints
- Secure password hashing (bcrypt)

## Features

### User Management

- **User Authentication**: Secure login and registration for athletes and coaches.
- **Athlete Onboarding**: Athletes can register and create their profiles, providing basic information such as name, age, and contact details, as well as their gym and coach affiliation.
    - Coaches approve the onboarding requests, ensuring that only authorized athletes are added to the system.
- **Coach Management**: Coaches can manage their athletes, including adding new athletes, updating athlete profiles, and removing athletes from the system.

### Security

- **Role Based Access Control**: Access is defined by three roles:
    - Administrators: Unrestricted access to data and application features
    - Coaches: Access to athlete data for one or more gyms for which they are granted access
    - Athletes: Access to their own data, and data within their cohort (the collection of athletes working together in a group defined by a coach)
- **Best Practice Compliance**: The application implements security best practices, including secure password storage, HTTPS support, and protection against common web vulnerabilities.
- **Data Integrity**: Database-level controls are used to maintain data integrity constraints including foreign key constraints and unique constraints.
- **Data Privacy**: The application ensures that athlete data is private and only accessible to authorized users (coaches and the athlete themselves).
- **Federated Authentication**: The application supports federated authentication, allowing users to log in using third-party identity providers (e.g., Google, Facebook) for added convenience and security.

### Coach Exercise Management

- **Athlete Metrics Tracking**: Coaches can log and track performance metrics for athletes.
**Performance Metrics**: The application supports collecting varied performance metrics, including strength, endurance, speed, and agility.
    - The system pre-defines common exercises and metrics.
    - Coaches can define custom metrics as needed for any exercise.
- **Exercise Management**: Coaches can define and manage _custom exercises_, with names, descriptions, and other data; coaches can collect associated metrics for their custom exercise.
- The application also defined _system exercises_ which are predefined exercises that are available to all coaches.
- **Data Visualization**: Coaches can view athlete performance metrics over time, with graphs and charts to analyze progress.
- **Cohort Management**: Coaches can create and manage cohorts, allowing athletes to work together and share progress.
- **Notifications**: Coaches can send notifications to athletes, keeping them informed about their progress and any updates.
- **Search Functionality**: Coaches can search for athletes, exercises, and metrics to quickly find the information they need.
- **Customizable Dashboard**: Coaches can customize their dashboard to display the most relevant information and metrics for their athletes.

### Athlete Performance Tracking Features

- **Performance History**: Athletes can view their performance history, including past metrics and progress over time.
- **Notifications**: Athletes receive notifications from coaches about their performance.
- **Responsible Party**: Athletes and coaches can define the athlete's billing responsible party, which will also receive notifications about the athlete's performance.

### System Architecture Features

- **API Access**: The application provides a RESTful API for integration with other systems and applications.
- **Docker Support**: The application is designed to run in a Docker container, ensuring consistent deployment and easy scalability.
- **Responsive Design**: The application is designed to be responsive, ensuring a good user experience on both desktop and mobile devices.
- **AI Integration**: The application supports integration with AI services for advanced analytics and insights, such as predicting athlete performance trends and providing personalized training recommendations.
    - AI services will be leveraged to augment other elements of the application, such as providing descriptions for custom exercises, creating fun analogies to performance metric, and providing insight into athlete performance trends.
- **Logging and Monitoring**: The application includes logging and monitoring features to monitor for unauthorized use.

## Data Definition

Measurement data is collected in SI units to ensure consistency and ease of comparison:

+ Meter (m)
+ Kilogram (kg)
+ Second (s)
+ Newton (N)
+ Watt (W)
+ Count (c)

Values that are reused within the database are defined using lookup tables or ENUMs where possible.

### Gym-Coach-Athlete Relationships

- Coach can work at multiple gyms
- An athlete can train at multiple gyms simultaneously
- Coaches have access to athlete information across all gyms

### Cohort Management

- A cohort is defined in the cohorts table, with a cohort_membership table to identify each athlete that is a member of the cohort
- Athletes can belong to multiple cohorts simultaneously
- Cohorts are gym-specific

### Authentication & User Types

- Users are distinguished by boolean role fields in a unified Users table
- A user can have multiple roles (e.g., both athlete and coach)
- Federated authentication is supported through external_id field

### Data Constraints

   - Email addresses must be valid; no requirement for uniqueness
   - Coaches can only manage athletes within their associated gyms
   - Within a gym, any coach can manage any athlete to add performance data and observe their progress
   - Administrators must approve a coach and gym assignment before they can manage athletes (maybe this is an is_approved boolean field in the User-Gym relationship table?)
   - If coach or gym is archived, athlete data remains in the system

### Performance Data

   - Multiple performance metrics can be recorded in a single session

### Tables and Relationships

- Audit Trail: Track who created/modified records
- Notifications: Notifications are sent by email based on preferences associated with the user
- File Management: Uploaded images are stored in a local filesystem or S3-compatible storage, with URLs stored in the database


## Data Model

### Users Data

+ id: UUID
+ external_id: string, for federated authentication
+ archived: boolean, for soft deletion
+ email: string, unique across all users
+ first_name: string
+ last_name: string
+ nick_name: string
+ date_of_birth: date
+ sex: string
+ height: float, in meters (for athletes)
+ weight: float, in kilograms (for athletes)
+ profile_image_url: string, URL to the user's profile image
+ last_tested: date, the date of the most recent performance test (for athletes)
+ is_athlete: boolean, true if user is an athlete
+ is_coach: boolean, true if user is a coach
+ is_admin: boolean, true if user is an administrator
+ created_at: date
+ updated_at: date

### User-Gym Relationships

+ id: UUID
+ user_id: UUID, foreign key to Users Data
+ gym_id: UUID, foreign key to Gym Data
+ role: ENUM {athlete, coach}, defines the user's role at this gym
+ is_active: boolean, for managing active/inactive relationships
+ created_at: date

### User-Coach Relationships

+ id: UUID
+ athlete_id: UUID, foreign key to Users Data (where is_athlete = true)
+ coach_id: UUID, foreign key to Users Data (where is_coach = true)
+ gym_id: UUID, foreign key to Gym Data
+ is_active: boolean, for managing active/inactive relationships
+ created_at: date

### Cohort Membership

+ id: UUID
+ cohort_id: UUID, foreign key to Cohort Definition
+ athlete_id: UUID, foreign key to Users Data (where is_athlete = true)
+ joined_at: date
+ is_active: boolean

### Responsible Party Data

+ id: UUID
+ athlete_id: UUID, foreign key to Users Data (where is_athlete = true)
+ archived: boolean, for soft deletion
+ email: string
+ first_name: string
+ last_name: string

### Exercise Definition

+ id: UUID
+ is_enabled: true,
+ creator_id: string
+ name: string
+ creator_name: string
+ category: ENUM {custom, system}
+ instructions: string
+ instruction_video_id: string
+ image_url: string, URL to the exercise image
+ created_at: date
+ updated_at: date
+ body_segments: lookup table exercise_body_segments
+ equipment: lookup table exercise_equipment
+ search_terms: lookup table exercise_search_terms
+ metrics: lookup table exercise_metrics

### Exercise Body Segments

+ id: UUID
+ name: string
+ exercise_id: UUID, foreign key to Exercise Definition
+ description: string, optional description of the body segment

### Exercise Equipment

+ id: UUID
+ name: string
+ exercise_id: UUID, foreign key to Exercise Definition
+ description: string, optional description of the equipment

### Exercise Search Terms

+ id: UUID
+ name: string
+ exercise_id: UUID, foreign key to Exercise Definition
+ description: string, optional description of the search term

### Exercise Metrics

+ id: UUID
+ name: string
+ exercise_id: UUID, foreign key to Exercise Definition
+ is_enabled: boolean
+ display_units: ENUM {metric, imperial}
+ unit_of_measure: ENUM {Meter, Kilogram, Second, Newton, Watt, Number}
+ decimals: integer, number of decimal places to display
+ value: float, the value of the metric

### Performance Metrics

+ id: UUID
+ athlete_id: UUID, foreign key to Users Data (where is_athlete = true)
+ exercise_id: UUID, foreign key to Exercise Definition
+ coach_id: UUID, foreign key to Users Data (where is_coach = true)
+ gym_id: UUID, foreign key to Gym Data
+ exercise_metric_id: UUID, foreign key to Exercise Metric Definition
+ value: float, the value of the performance metric
+ date: date, the date of the performance metric
+ notes: string, optional notes about the performance metric

### Cohort Definition

+ id: UUID
+ name: string
+ description: string
+ color: string, color code for the cohort
+ image_url: string, URL to the cohort image
+ coach_id: UUID, foreign key to Users Data (where is_coach = true)
+ gym_id: UUID, foreign key to Gym Data

## Role-Based Access Control

+ Administrators: Full access to system data
+ Coaches: Access to athlete data for gyms they are associated with; coaches enter data for athletes
+ Athletes: Access to their own data and data within their cohort
+ Responsible Party: Used for notifications and progress reporting for athletes

## User Interface

+ The user interface is designed to be intuitive and user-friendly, using a simple, modern design aesthetic.
+ The application will be responsive, ensuring a good user experience on both desktop and mobile devices.
+ The application will use a consistent color scheme and typography to create a cohesive look and feel.
+ The application will use Tailwind CSS for styling, providing a modern and responsive design framework.
+ The application will support dark mode, allowing users to switch between light and dark themes for better visibility in different lighting conditions.
+ The application will use icons and images to enhance the user experience, providing visual cues for actions and information. Icons will be provided by Font Awesome.
+ The application will use a consistent layout across all pages, with a navigation bar for easy access to different sections of the application.
+ All color contrast and font sizes will be compliant with WCAG 2.1 AA standards to ensure accessibility for all users.
+ Base color teal is #139696.
