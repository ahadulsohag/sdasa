class FeedbackModel {
  final String? feedbackID;
  final String? userID;
  final String message;
  final int rating;
  final DateTime createdAt;

  FeedbackModel({
    this.feedbackID,
    this.userID,
    required this.message,
    required this.rating,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      feedbackID: json['id'],
      userID: json['user_id'],
      message: json['message'],
      rating: json['rating'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (feedbackID != null) 'id': feedbackID,
      'user_id': userID,
      'message': message,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
