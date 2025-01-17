class ProductModel {
  final int productId;
  final String productName;
  final String description;
  final double price;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final List<Watchlist> watchlist;
  final List<Comment> comments;
  final List<View> views;
  final Statistics statistics;
  final double scores;

  ProductModel({
    required this.productId,
    required this.productName,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.watchlist,
    required this.comments,
    required this.views,
    required this.statistics,
    required this.scores,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    List<Comment> comments = (json['Comments'] as List).map((item) => Comment.fromJson(item)).toList();
    List<int> scoreList = [];
    for (var data in comments) {
      scoreList.add(data.ratingScore);
    }

    double calculateStarRating(List<int> scores) {
      if (scores.isEmpty) {
        return 0;
      }
      double averageScore = scores.reduce((a, b) => a + b) / scores.length;
      double starRating = (averageScore / 6) * 5;
      return starRating;
    }

    return ProductModel(
      productId: json['ProductID'] ?? 0,
      productName: json['ProductName'] ?? '',
      description: json['Description'] ?? '',
      price: (json['Price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['ImageUrl'] ?? '',
      createdAt: DateTime.parse(json['CreatedAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['UpdatedAt'] ?? DateTime.now().toString()),
      deletedAt: json['DeletedAt'] != null ? DateTime.parse(json['DeletedAt']) : null,
      watchlist: (json['Watchlist'] as List).map((item) => Watchlist.fromJson(item)).toList(),
      comments: comments,
      views: (json['Views'] as List).map((item) => View.fromJson(item)).toList(),
      statistics: Statistics.fromJson(json['Statistics'] ?? {}),
      scores: calculateStarRating(scoreList),
    );
  }
}

class Watchlist {
  final int userId;

  Watchlist({required this.userId});

  factory Watchlist.fromJson(Map<String, dynamic> json) {
    return Watchlist(
      userId: json['UserID'],
    );
  }
}

class Comment {
  final int commentId;
  final int userId;
  final String commentText;
  final int ratingScore;
  final DateTime createdAt;

  Comment({
    required this.commentId,
    required this.userId,
    required this.commentText,
    required this.ratingScore,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['CommentID'] ?? 0,
      userId: json['UserID'] ?? 0,
      commentText: json['CommentText'] ?? '',
      ratingScore: json['RatingScore'] ?? 0,
      createdAt: DateTime.parse(json['CreatedAt'] ?? DateTime.now().toString()),
    );
  }
}

class View {
  final int viewId;
  final int userId;
  final DateTime viewDate;

  View({
    required this.viewId,
    required this.userId,
    required this.viewDate,
  });

  factory View.fromJson(Map<String, dynamic> json) {
    return View(
      viewId: json['ViewID'],
      userId: json['UserID'],
      viewDate: DateTime.parse(json['ViewDate']),
    );
  }
}

class Statistics {
  final int totalViews;
  final int totalComments;
  final int totalWatchlistAdds;
  final double avgRatingScore;
  final DateTime lastUpdated;

  Statistics({
    required this.totalViews,
    required this.totalComments,
    required this.totalWatchlistAdds,
    required this.avgRatingScore,
    required this.lastUpdated,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      totalViews: json['TotalViews'] ?? 0,
      totalComments: json['TotalComments'] ?? 0,
      totalWatchlistAdds: json['TotalWatchlistAdds'] ?? 0,
      avgRatingScore: json['AvgRatingScore'] ?? 0,
      lastUpdated: DateTime.parse(json['LastUpdated'] ?? DateTime.now().toString()),
    );
  }
}
