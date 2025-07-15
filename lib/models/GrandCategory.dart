class GrandCategory {
  final int id;
  final String name;

  GrandCategory({
    required this.id,
    required this.name,
  });

  factory GrandCategory.fromJson(Map<String, dynamic> json) {
    return GrandCategory(
      id: json['id'],
      name: json['name'],
    );
  }
}
