import 'package:groceries_shopping_app/models/models.dart';

class Service {
  Service({this.id, this.name = "null", this.subCategories, this.picPath});
  final int id;
  final String name;
  final String picPath;
  final List<SubCategory> subCategories;

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as int,
      name: json['name'] as String,
      subCategories: (json['minis']
          .map<SubCategory>((e) => SubCategory.fromJson(e))
          .toList()) as List<SubCategory>,
    );
  }

  Map<String, dynamic> toJson() => {'id': id};

  @override
  String toString() {
    return "The name is: $name, subCategories: ${subCategories.toString()}";
  }
}
