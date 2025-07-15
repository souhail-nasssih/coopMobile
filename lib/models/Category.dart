import 'package:gestioncoop/models/GrandCategory.dart';


class Category {
  final int id;
  final String nom;
  final GrandCategory? grandCategory;

  Category({
    required this.id,
    required this.nom,
    this.grandCategory,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nom: json['nom'],
      grandCategory: json['grandCategory'] != null
          ? GrandCategory.fromJson(json['grandCategory'])
          : null,
    );
  }
}
