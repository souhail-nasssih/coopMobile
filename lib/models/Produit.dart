import 'package:gestioncoop/models/Category.dart';
import 'package:gestioncoop/models/Review.dart';

class Produit {
  final int id;
  final String libelle;
  final String description;
  final double prix;
  final double? originalPrice;
  final String image;
  final int qteStock;
  final bool isBio;
  final bool isEco;
  final bool fairTrade;
  final bool isFreeShipping;
  final int soldCount;
  final double rating;
  final int reviewsCount;
  final double averageRating;
  final int totalReviews;
  final Category? category;
  final String? cooperative;
  final int? pointVentId;
  final List<Review> reviews;

  Produit({
    required this.id,
    required this.libelle,
    required this.description,
    required this.prix,
    this.originalPrice,
    required this.image,
    required this.qteStock,
    required this.isBio,
    required this.isEco,
    required this.fairTrade,
    required this.isFreeShipping,
    required this.soldCount,
    required this.rating,
    required this.reviewsCount,
    required this.averageRating,
    required this.totalReviews,
    this.category,
    this.cooperative,
    this.pointVentId,
    required this.reviews,
  });

  factory Produit.fromJson(Map<String, dynamic> json) {
    print('JSON reçu pour Produit : ' + json.toString());
    String rawImageUrl = json['image'] ?? '';

    // Gestion des URL invalides ou relatives
    String fixedImageUrl = '';
    if (rawImageUrl.startsWith('http')) {
      // URL complète fournie par l'API
      fixedImageUrl = rawImageUrl.replaceFirst('localhost', '10.0.2.2');
    } else if (rawImageUrl.startsWith('/storage')) {
      // Chemin relatif fourni par Laravel
      fixedImageUrl = 'http://10.0.2.2:8000$rawImageUrl';
    } else if (rawImageUrl.isNotEmpty) {
      // Cas extrême : chemin sans slash initial
      fixedImageUrl = 'http://10.0.2.2:8000/storage/$rawImageUrl';
    }

    // Parsing robuste des reviews
    List<dynamic>? rawReviews = json['reviews'] ?? json['comments'];
    print('Parsing reviews: trouvé ${rawReviews?.length ?? 0} avis');

    return Produit(
      id: json['id'],
      libelle: json['libelle'],
      description: json['description'] ?? '',
      prix: (json['prix'] ?? 0).toDouble(),
      originalPrice:
          json['originalPrice'] != null
              ? (json['originalPrice'] as num).toDouble()
              : null,
      image: fixedImageUrl,
      qteStock: json['qteStock'] ?? 0,
      isBio: json['is_bio'] ?? false,
      isEco: json['is_eco'] ?? false,
      fairTrade: json['fair_trade'] ?? false,
      isFreeShipping: json['is_free_shipping'] ?? false,
      soldCount: json['sold_count'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      reviewsCount: json['reviews_count'] ?? 0,
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      cooperative: json['cooperative'],
      pointVentId: json['point_vent_id'],
      reviews:
          rawReviews?.map((e) {
            print('Review JSON: $e');
            return Review.fromJson(e);
          }).toList() ??
          [],
    );
  }
}
