from .. import db
from sqlalchemy.sql import func
from ..models import product

class ProductStatistic(db.Model):
    __tablename__ = 'ProductStatistics'
    __table_args__ = {'schema': 'qua52616_quangminhrt'}
    StatisticID = db.Column(db.Integer, primary_key=True)
    ProductID = db.Column(db.Integer, db.ForeignKey('qua52616_quangminhrt.Products.ProductID'), nullable=False)
    AvgRatingScore= db.Column(db.Numeric(precision=10, scale=2), default=0)
    TotalViews = db.Column(db.Integer, default=0)
    TotalComments = db.Column(db.Integer, default=0)
    TotalWatchlistAdds = db.Column(db.Integer, default=0)
    LastUpdated = db.Column(db.DateTime, default=func.now())

    # Relationships
    product = db.relationship('Product', back_populates='statistics')
