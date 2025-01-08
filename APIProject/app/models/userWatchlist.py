from .. import db
from sqlalchemy.sql import func

class UserWatchlist(db.Model):
    __tablename__ = 'UserWatchlist'
    __table_args__ = {'schema': 'qua52616_quangminhrt'}
    WatchlistID = db.Column(db.Integer, primary_key=True)
    UserID = db.Column(db.Integer, db.ForeignKey('qua52616_quangminhrt.Users.UserID'), nullable=False)
    ProductID = db.Column(db.Integer, db.ForeignKey('qua52616_quangminhrt.Products.ProductID'), nullable=False)
    AddedAt = db.Column(db.DateTime, default=func.now())
    RemovedAt = db.Column(db.DateTime, nullable=True)

    # Relationships
    user = db.relationship('User', back_populates='watchlist')
    product = db.relationship('Product', back_populates='watchlist')
