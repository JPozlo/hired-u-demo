import 'package:groceries_shopping_app/models/create_order_dto.dart';
import 'package:groceries_shopping_app/models/models.dart';

class Result{
  final bool status;
  final String message;
  final List<Order> orders;
  final List<Product> products;
  final CreateOrderDTO createOrderDto;
  final Order order;
  final User user;
  final List errors;

  Result(this.status, this.message, {this.products, this.createOrderDto, this.order, this.orders, this.user, this.errors});

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'orders': orders ?? null,
    'order': createOrderDto ?? null,
    'user': user ?? null,
    "errors": errors ?? null,
    "products": products ?? null
  };

  @override
  String toString() {
    return "The status: $status\n message: $message\n";
  }

}