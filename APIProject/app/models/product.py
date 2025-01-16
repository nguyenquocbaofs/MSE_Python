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

    def to_dict(self):
        return {
            "ProductID": self.ProductID,
            "ProductName": self.ProductName,
            "Description": self.Description,
            "Price": float(self.Price),
            "ImageUrl": self.ImageUrl,
            "CreatedAt": self.CreatedAt.isoformat() if self.CreatedAt else None,
            "UpdatedAt": self.UpdatedAt.isoformat() if self.UpdatedAt else None,
            "DeletedAt": self.DeletedAt.isoformat() if self.DeletedAt else None,
            "Watchlist": [
                {
                    "UserID": watchlist_item.UserID 
                } for watchlist_item in self.watchlist
            ],
            "Comments": [
                {
                    "CommentID": comment.CommentID,
                    "UserID": comment.UserID,
                    "CommentText": comment.CommentText,
                    "RatingScore": comment.RatingScore,
                    "CreatedAt": comment.CreatedAt.isoformat() if comment.CreatedAt else None
                } for comment in self.comments
            ],
            "Views": [
                {
                    "ViewID": view.ViewID,
                    "UserID": view.UserID,
                    "ViewDate": view.ViewDate.isoformat() if view.ViewDate else None
                } for view in self.views
            ],
            "Statistics": {
                "TotalViews": self.statistics.TotalViews if self.statistics else 0,
                "TotalComments": self.statistics.TotalComments if self.statistics else 0,
                "TotalWatchlistAdds": self.statistics.TotalWatchlistAdds if self.statistics else 0,
                "AvgRatingScore": float(self.statistics.AvgRatingScore) if self.statistics.AvgRatingScore is not None else 0.0,
                "LastUpdated": self.statistics.LastUpdated.isoformat() if self.statistics and self.statistics.LastUpdated else None
            } if self.statistics else None
        }
