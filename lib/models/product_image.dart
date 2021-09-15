import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/services/api/api_service.dart';

class ProductImage {
  ProductImage({this.image});
  final String image;

  factory ProductImage.fromJson(Map<String, dynamic> json) =>
      ProductImage(image: json['image'] ?? null);

          Map<String, dynamic> toJson() => {
        'image': image,
      };
}
