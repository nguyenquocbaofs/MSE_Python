from .. import db
from sqlalchemy.sql import func

class ProductView(db.Model):
    __tablename__ = 'ProductViews'
    __table_args__ = {'schema': 'qua52616_quangminhrt'}
    ViewID = db.Column(db.Integer, primary_key=True)
    ProductID = db.Column(db.Integer, db.ForeignKey('qua52616_quangminhrt.Products.ProductID'), nullable=False)
    UserID = db.Column(db.Integer, db.ForeignKey('qua52616_quangminhrt.Users.UserID'), nullable=True)
    ViewDate = db.Column(db.DateTime, default=func.now())

    # Relationships
    product = db.relationship('Product', back_populates='views')
