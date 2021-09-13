import 'package:groceries_shopping_app/models/models.dart';

class ProductImage {
  ProductImage({this.image});
  final String image;

  factory ProductImage.fromJson(Map<String, dynamic> json) =>
      ProductImage(image: json['image'] as String);
}
