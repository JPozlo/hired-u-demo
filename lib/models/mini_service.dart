class MiniService {
  MiniService({this.id, this.price, this.name, this.address});
  final int id;
  final String name;
  final int price;
  final String address;

  factory MiniService.fromJson(Map<String, dynamic> json) {
    return MiniService(
        id: json['id'] as int,
        name: json['name'] as String,
        address: json['address'] as String,
        price: json['price'] as int,
        );
  }

  Map<String, dynamic> toJson() => {
    'id': id
    };
}
