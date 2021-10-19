class ProductCategory {
  ProductCategory({this.id, this.name, this.description});
  final int? id;
  final String? name;
  final String? description;

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      ProductCategory(
        name: json['name'] ?? null,
        description: json['description'] ?? null,
        id: json['id'] ?? null
      );
}
