class Review {
  final int id;
  final int? userId;
  final String? author;
  final double? rating;
  final String? comment;
  final String? date;
  final String? avatar;
  final String? productName;

  Review({
    required this.id,
    this.userId,
    this.author,
    this.rating,
    this.comment,
    this.date,
    this.avatar,
    this.productName,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    try {
      return Review(
        id: json['id'] ?? 0,
        userId: json['user_id'],
        author: json['author'],
        rating: (json['rating'] is int)
            ? (json['rating'] as int).toDouble()
            : (json['rating'] as num?)?.toDouble(),
        comment: json['comment'],
        date: json['date'],
        avatar: json['avatar'],
        productName: json['product_name'],
      );
    } catch (e) {
      print('Erreur parsing Review: $e | JSON: ' + json.toString());
      return Review(id: 0);
    }
  }
}