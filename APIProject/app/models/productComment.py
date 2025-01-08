from .. import db
from sqlalchemy.sql import func

class ProductComment(db.Model):
    __tablename__ = 'ProductComments'
    __table_args__ = {'schema': 'qua52616_quangminhrt'}
    CommentID = db.Column(db.Integer, primary_key=True)
    ProductID = db.Column(db.Integer, db.ForeignKey('qua52616_quangminhrt.Products.ProductID'), nullable=False)
    UserID = db.Column(db.Integer, db.ForeignKey('qua52616_quangminhrt.Users.UserID'), nullable=False)
    CommentText = db.Column(db.Text, nullable=False)
    RatingScore = db.Column(db.Integer, nullable=False)
    CreatedAt = db.Column(db.DateTime, default=func.now())

    # Relationships
    product = db.relationship('Product', back_populates='comments')
    user = db.relationship('User', back_populates='comments')

