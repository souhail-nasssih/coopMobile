class PointVent {
  final int id;
  final String adresse;
  final String? telephone;


  PointVent({
    required this.id,
    required this.adresse,
    this.telephone,

  });

  factory PointVent.fromJson(Map<String, dynamic> json) {
    return PointVent(
      id: json['id'] ?? 0,
      adresse: json['adresse'] ?? 'Adresse non spécifiée',
      telephone: json['telephone'],

    );
  }

  String get fullAddress {
    return [
      adresse,
      telephone != null && telephone!.isNotEmpty ? 'Tél: $telephone' : null,
    ].where((part) => part != null && part.isNotEmpty).join(', ');
  }
}