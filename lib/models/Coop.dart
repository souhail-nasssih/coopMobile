import 'package:gestioncoop/models/PointVent.dart';
import 'package:gestioncoop/models/Review.dart';

class Coop {
  final int id;
  final String nom;
  final String email;
  final String domaine;
  final String description;
  final String? anneeCreation;
  final String? certifications;
  final int userId;
  final double rating; // Rating de base (peut venir de la table coops)
  final int reviewsCount;
  final String profileUrl;
  final String coverUrl;
  final PointVent? mainPointVent;
  final List<Review> reviews;

  Coop({
    required this.id,
    required this.nom,
    required this.email,
    required this.domaine,
    required this.description,
    this.anneeCreation,
    this.certifications,
    required this.userId,
    required this.rating,
    required this.reviewsCount,
    required this.profileUrl,
    required this.coverUrl,
    this.mainPointVent,
    required this.reviews,
  });

  Coop copyWith({
    int? id,
    String? nom,
    String? email,
    String? domaine,
    String? description,
    String? anneeCreation,
    String? certifications,
    int? userId,
    double? rating,
    int? reviewsCount,
    String? profileUrl,
    String? coverUrl,
    PointVent? mainPointVent,
    List<Review>? reviews,
  }) {
    return Coop(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      email: email ?? this.email,
      domaine: domaine ?? this.domaine,
      description: description ?? this.description,
      anneeCreation: anneeCreation ?? this.anneeCreation,
      certifications: certifications ?? this.certifications,
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      profileUrl: profileUrl ?? this.profileUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      mainPointVent: mainPointVent ?? this.mainPointVent,
      reviews: reviews ?? this.reviews,
    );
  }

  factory Coop.fromJson(Map<String, dynamic> json) {
    final reviews =
        (json['reviews'] as List<dynamic>? ?? [])
            .map((review) => Review.fromJson(review))
            .toList();

    return Coop(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      email: json['email'] ?? '',
      domaine: json['domaine'] ?? '',
      description: json['description'] ?? '',
      anneeCreation: json['annee_creation'],
      certifications:
          json['certifications'] != null
              ? (json['certifications'] is List
                  ? (json['certifications'] as List).join(', ')
                  : json['certifications'].toString())
              : null,
      userId: json['user_id'] ?? 0,
      rating: _calculateRating(reviews, json['rating']),
      reviewsCount: reviews.length,
      profileUrl: _fixUrl(json['profile_url']),
      coverUrl: _fixUrl(json['cover_url']),
      reviews: reviews,
      mainPointVent:
          json['main_point_vent'] != null
              ? PointVent.fromJson(
                json['main_point_vent'].cast<String, dynamic>(),
              )
              : null,
    );
  }

  static double _calculateRating(List<Review> reviews, dynamic fallbackRating) {
    if (reviews.isEmpty) return (fallbackRating ?? 0).toDouble();
    final validRatings = reviews.map((r) => r.rating ?? 0.0).toList();
    final sum = validRatings.fold(0.0, (total, rating) => total + rating);
    return validRatings.isNotEmpty ? sum / validRatings.length : (fallbackRating ?? 0).toDouble();
  }

  // Getter pour obtenir le rating effectif (calculé ou fallback)
  double get effectiveRating {
    return reviews.isEmpty ? rating : calculatedRating;
  }

  // Getter pour le rating calculé à partir des reviews
  double get calculatedRating {
    if (reviews.isEmpty) return rating;
    final validRatings = reviews.map((r) => r.rating ?? 0.0).toList();
    final sum = validRatings.fold(0.0, (a, b) => a + b);
    return validRatings.isNotEmpty ? sum / validRatings.length : rating;
  }

  String get fullAddress {
    return mainPointVent?.adresse ?? 'Adresse non disponible';
  }

  String get phoneNumber {
    return mainPointVent?.telephone ?? 'Téléphone non disponible';
  }

  static String _fixUrl(dynamic rawUrl) {
    if (rawUrl == null) return '';

    String url = rawUrl.toString().trim();
    if (url.isEmpty) return '';

    if (url.startsWith('http://localhost')) {
      // Pour Android Emulator
      return url.replaceFirst('http://localhost', 'http://10.0.2.2');
    }
    if (url.startsWith('https://localhost')) {
      // Variante si SSL utilisé localement
      return url.replaceFirst('https://localhost', 'https://10.0.2.2');
    }
    if (url.startsWith('http')) return url;

    // Si le backend renvoie /storage/...
    if (url.startsWith('/storage')) {
      // Remplace 'votre-domaine.com' par ton IP LAN ou domaine de test
      return 'http://10.0.2.2:8000$url';
    }

    return url;
  }

  @override
  String toString() {
    return 'Coop(id: $id, nom: $nom, rating: $effectiveRating, reviews: ${reviews.length})';
  }
}
