import 'package:groceries_shopping_app/models/models.dart';

class OrderHistory {
  final String id;
  final int addressId;
  final List<Product> orderHistoryItems;
  final String time;
  final int total;

  OrderHistory({this.id, this.addressId, this.time, this.orderHistoryItems, this.total});

  factory OrderHistory.fromJson(Map<String, dynamic> json) {
    return OrderHistory(
      id: json['id'] as String,
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() =>
      {'address_id': addressId, 'orderHistory_items': orderHistoryItems, 'token': time};

  @override
  String toString() {
    return "The id:$id\n status:";
  }
}
