import 'package:groceries_shopping_app/models/create_order_dto.dart';
import 'package:groceries_shopping_app/models/models.dart';

class Result {
  final bool status;
  final String message;
  final List<Order> orders;
  final List<Product> products;
  final Service service;
  final Payment payment;
  final List<Payment> payments;
  final CreateOrderDTO createOrderDto;
  final UpdateProfileUser updateProfileUser;
  final PaginationData pagination;
  final bool productStatus;
  final UserAddress address;
  final List<UserAddress> addresses;
  final Order order;
  final User user;
  final List errors;

  Result(this.status, this.message,
 
      { this.address, this.products,this.updateProfileUser,
      this.payments,
      this.payment, this.addresses,
      this.service,
      this.productStatus,
      this.createOrderDto,
      this.order,
      this.pagination,
      this.orders,
      this.user,
      this.errors});

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
