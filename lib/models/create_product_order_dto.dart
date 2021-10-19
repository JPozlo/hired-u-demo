import 'package:groceries_shopping_app/models/models.dart';
import 'package:provider/provider.dart';

class CreateProductOrderDTO {
  CreateProductOrderDTO({required this.items, required this.userAddressesId});
  final List<OrderItem> items;
  final int userAddressesId;

  Map<String, dynamic> toJson() => {'items': items.map((e) => e.toJson()).toList(), 'user_addresses_id': userAddressesId};
}
