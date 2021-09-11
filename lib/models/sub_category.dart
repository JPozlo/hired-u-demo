import 'package:groceries_shopping_app/models/models.dart';

class SubCategory {
  SubCategory({this.id, this.name, this.miniServices});
  final int id;
  final String name;
  final List<MiniService> miniServices;

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
        id: json['id'] as int,
        name: json['name'] as String,
        miniServices: json['mini_services'] as List<MiniService>,
        );
  }

  Map<String, dynamic> toJson() => {
    'id': id
    };

}
