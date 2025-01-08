from .. import db
from sqlalchemy.sql import func
from flask_bcrypt import Bcrypt

bcrypt = Bcrypt()

class User(db.Model):
    __tablename__ = 'Users'
    __table_args__ = {'schema': 'qua52616_quangminhrt'}
    UserID = db.Column(db.Integer, primary_key=True)
    Username = db.Column(db.String(100), nullable=False, unique=True)
    PasswordHash = db.Column(db.String(255), nullable=False)
    Email = db.Column(db.String(255), nullable=False, unique=True)
    IsAdmin = db.Column(db.Boolean, default=False)
    CreatedAt = db.Column(db.DateTime, default=func.now())

    # Relationships
    watchlist = db.relationship('UserWatchlist', back_populates='user')
    comments = db.relationship('ProductComment', back_populates='user')

     # Hash password
    def set_password(self, password):
        self.PasswordHash = bcrypt.generate_password_hash(password).decode('utf-8')

    # Check password
    def check_password(self, password):
        return bcrypt.check_password_hash(self.PasswordHash, password)
