from marshmallow import Schema, fields, validate, post_load
from datetime import date

class UserSchema(Schema):
    id = fields.Str(dump_only=True)
    email = fields.Email(required=True)
    first_name = fields.Str(required=True, validate=validate.Length(min=1, max=100))
    last_name = fields.Str(required=True, validate=validate.Length(min=1, max=100))
    nick_name = fields.Str(validate=validate.Length(max=100))
    date_of_birth = fields.Date()
    sex = fields.Str(validate=validate.OneOf(['M', 'F', 'Other']))
    height = fields.Decimal(places=3, validate=validate.Range(min=0))
    weight = fields.Decimal(places=2, validate=validate.Range(min=0))
    profile_image_url = fields.Url()
    last_tested = fields.Date()
    is_athlete = fields.Bool()
    is_coach = fields.Bool()
    is_admin = fields.Bool()
    created_at = fields.DateTime(dump_only=True)
    updated_at = fields.DateTime(dump_only=True)

class UserRegistrationSchema(Schema):
    email = fields.Email(required=True)
    password = fields.Str(required=True, validate=validate.Length(min=8))
    first_name = fields.Str(required=True, validate=validate.Length(min=1, max=100))
    last_name = fields.Str(required=True, validate=validate.Length(min=1, max=100))
    is_athlete = fields.Bool()
    is_coach = fields.Bool()

    @post_load
    def validate_roles(self, data, **kwargs):
        if not (data.get('is_athlete') or data.get('is_coach')):
            data['is_athlete'] = True
        return data
