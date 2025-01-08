from .. import db
from sqlalchemy.sql import func
from ..models import userWatchlist, productComment, productView, productStatistic


class Product(db.Model):
    __tablename__ = 'Products'
    __table_args__ = {'schema': 'qua52616_quangminhrt'}
    ProductID = db.Column(db.Integer, primary_key=True)
    ProductName = db.Column(db.String(255), nullable=False)
    Description = db.Column(db.Text, nullable=True)
    Price = db.Column(db.Numeric(18, 2), nullable=False)
    ImageUrl = db.Column(db.String(255), nullable=True)
    CreatedAt = db.Column(db.DateTime, default=func.now())
    UpdatedAt = db.Column(db.DateTime, default=func.now(), onupdate=func.now())
    DeletedAt = db.Column(db.DateTime, nullable=True)

    # Relationships
    watchlist = db.relationship('UserWatchlist', back_populates='product')
    comments = db.relationship('ProductComment', back_populates='product')
    views = db.relationship('ProductView', back_populates='product')
    statistics = db.relationship('ProductStatistic', uselist=False, back_populates='product')
