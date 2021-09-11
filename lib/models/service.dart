import 'package:groceries_shopping_app/models/models.dart';

class Service {
  Service({this.id, this.name = "null", this.picPath = "null", this.subCategories});
  final int id;
  final String name;
  final String picPath;
  final List<SubCategory> subCategories;

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
        id: json['id'] as int,
        name: json['name'] as String,
        picPath: json['pic_path'] as String,
        subCategories: json['sub_categories'] as List<SubCategory>,
        );
  }

  Map<String, dynamic> toJson() => {
    'id': id
    };
}
