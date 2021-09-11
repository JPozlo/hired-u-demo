import 'package:groceries_shopping_app/models/models.dart';

class Order {
  final int id;
  final int addressId;
  final List<Product> orderItems;
  final String token;
  final int total;

  Order({this.id, this.addressId, this.token, this.orderItems, this.total});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() =>
      {'address_id': addressId, 'order_items': orderItems, 'token': token};

  @override
  String toString() {
    return "The id:$id\n status:";
  }
}
