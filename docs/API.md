# AIP Track API Documentation

## Overview

The AIP Track API is a RESTful web service that provides endpoints for managing athletes, coaches, exercises, and performance metrics. The API uses JWT-based authentication and follows OpenAPI 3.0 specifications.

## Base URL

- Development: `http://localhost:3001/api`
- Production: `https://api.aiptrack.com/api`

## Authentication

The API uses JWT (JSON Web Tokens) for authentication. Include the token in the Authorization header:

```
Authorization: Bearer <your-jwt-token>
```

### Obtaining a Token

1. **Login**: POST `/auth/login` with email and password
2. **Register**: POST `/auth/register` to create a new account
3. **Refresh**: POST `/auth/refresh` to get a new token

## Response Format

All API responses follow a consistent format:

### Success Response
```json
{
  "data": {...},
  "pagination": {
    "page": 1,
    "per_page": 20,
    "total": 100,
    "pages": 5
  }
}
```

### Error Response
```json
{
  "error": "Error message",
  "details": {}
}
```

## Date and Time Format

- All dates use ISO 8601 format: `YYYY-MM-DD`
- All timestamps use ISO 8601 format: `YYYY-MM-DDTHH:MM:SSZ`

## Measurement Units

All measurements are stored and returned in SI units:

- **Distance**: Meters (m)
- **Weight**: Kilograms (kg)
- **Time**: Seconds (s)
- **Force**: Newtons (N)
- **Power**: Watts (W)
- **Count**: Number (c)

## Pagination

List endpoints support pagination with the following parameters:

- `page`: Page number (default: 1)
- `per_page`: Items per page (default: 20, max: 100)

## Rate Limiting

- Authentication endpoints: 5 requests per minute per IP
- General endpoints: 100 requests per minute per user

## Error Codes

| Code | Description |
|------|-------------|
| 400  | Bad Request - Invalid input |
| 401  | Unauthorized - Invalid or missing token |
| 403  | Forbidden - Insufficient permissions |
| 404  | Not Found - Resource doesn't exist |
| 422  | Unprocessable Entity - Validation errors |
| 429  | Too Many Requests - Rate limit exceeded |
| 500  | Internal Server Error |

## Core Endpoints

### Authentication
- `POST /auth/login` - User login
- `POST /auth/register` - User registration
- `GET /auth/me` - Get current user info
- `POST /auth/refresh` - Refresh token
- `POST /auth/logout` - User logout

### Athletes
- `GET /athletes` - List athletes (with filtering)
- `POST /athletes` - Create athlete
- `GET /athletes/{id}` - Get specific athlete
- `PUT /athletes/{id}` - Update athlete

### Exercises
- `GET /exercises` - List exercises
- `POST /exercises` - Create custom exercise
- `GET /exercises/{id}` - Get specific exercise

### Metrics
- `POST /metrics` - Record performance metric
- `GET /metrics/athlete/{athlete_id}` - Get athlete metrics

### Health
- `GET /health` - API health check

## Examples

### Login Example
```bash
curl -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "athlete@example.com",
    "password": "password123"
  }'
```

### Record Metric Example
```bash
curl -X POST http://localhost:3001/api/metrics \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "athlete_id": "550e8400-e29b-41d4-a716-446655440000",
    "exercise_id": "550e8400-e29b-41d4-a716-446655440001",
    "exercise_metric_id": "660e8400-e29b-41d4-a716-446655440000",
    "value": 75.5,
    "date": "2023-12-01",
    "notes": "Personal best!"
  }'
```

## OpenAPI Specification

The complete API specification is available in OpenAPI 3.0 format:
- [YAML Format](../backend/openapi.yaml)
- [JSON Format](../backend/openapi.json)

## Development

For development and testing, you can use the interactive API documentation available at:
- Development: `http://localhost:3001/api/docs/`

## Support

For API support and questions, contact the development team at dev@aiptrack.com.
