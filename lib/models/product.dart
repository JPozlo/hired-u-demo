class Product {
  Product({
    this.id,
    this.name = 'null',
    this.picPath,
    this.foodCategory = "null",
    this.description =
        '''This is a professional description, so that you can buy our product, go home and be happy!''',
    this.price = 0,
    this.token,
    this.orderedQuantity = 1,
  });

  final int id;
  final String name;
  final List<String> picPath;
  final String description;
  final String foodCategory;
  final int price;
  final String token;
  int orderedQuantity;

  void makeOrder({int bulkOrder = 0}) {
    if (bulkOrder == 0) {
      orderedQuantity++;
      return;
    }
    orderedQuantity += bulkOrder;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String,
        foodCategory: json['food_category'] as String,
        picPath: json['picPath'] as List<String>,
        price: json['price'] as int,
        token: json['token'] as String ?? "null"
        );
  }

  Map<String, dynamic> toJson() =>
      {'token': token};

  @override
  String toString() {
    return "The product name: $name\n The product price is: $price";
  }
}
