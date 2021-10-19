class Supplier {
  Supplier({required this.id, required this.name});

  final int? id;
  final String? name;

  factory Supplier.fromJson(Map<String, dynamic> json) =>
      Supplier(id: json['id'] ?? null, name: json['name'] ?? null);
}
