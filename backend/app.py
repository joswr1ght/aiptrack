from app import create_app, db
import os

app = create_app()

@app.cli.command()
def init_db():
    """Initialize the database."""
    db.create_all()
    print('Database initialized.')

@app.cli.command()
def seed_db():
    """Seed the database with initial data."""
    from app.models.user import User

    # Create admin user
    admin = User(
        email='admin@aiptrack.com',
        first_name='Admin',
        last_name='User',
        is_admin=True
    )
    admin.set_password('admin123')

    db.session.add(admin)
    db.session.commit()
    print('Database seeded.')

@app.cli.command()
def generate_docs():
    """Generate API documentation."""
    import yaml
    import json

    # Load OpenAPI spec
    with open('openapi.yaml', 'r') as f:
        spec = yaml.safe_load(f)

    # Write JSON version
    with open('openapi.json', 'w') as f:
        json.dump(spec, f, indent=2)

    print('API documentation generated: openapi.yaml, openapi.json')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 3000)), debug=True)
