class MiniService {
  MiniService(
      {this.id, this.price, this.name, this.address, this.isChecked = false});
  final int id;
  final String name;
  final int price;
  final String address;
  bool isChecked;

  factory MiniService.fromJson(Map<String, dynamic> json) {
    return MiniService(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as int,
    );
  }

  Map<String, dynamic> toJson() => {'id': id};
}
