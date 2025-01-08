import os

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'a_secret_key'
    SQLALCHEMY_DATABASE_URI = (
        ""
    )
    SQLALCHEMY_TRACK_MODIFICATIONS = False
