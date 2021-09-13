import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/models/product_category.dart';

class Product {
  Product({
    this.id,
    this.name = 'null',
    this.picPath,
    this.foodCategory,
    this.description =
        '''This is a professional description, so that you can buy our product, go home and be happy!''',
    this.price = 0,
    this.discount,
    this.quantity,
    this.tags,
    this.supplier,
    this.orderedQuantity = 1,
  });

  final int id;
  final String name;
  final List<ProductImage> picPath;
  final String description;
  final ProductCategory foodCategory;
  final String tags;
  final Supplier supplier;
  final int quantity;
  final int discount;
  final int price;
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
      name: json['name'] as String,
      description: json['desc'] as String,
      foodCategory: json['category'] as ProductCategory,
      picPath: json['images'] as List<ProductImage>,
      price: json['price'] as int,
      discount: json['discount'] as int,
      quantity: json['quantity'] as int,
      tags: json['tags'] as String,
      supplier: json['supplier'] as Supplier,
    );
  }

  @override
  String toString() {
    return "The product name: $name\n The product price is: $price";
  }
}
