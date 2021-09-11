import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/local_database.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/services/api/api_service.dart';
import 'package:groceries_shopping_app/utils/utils.dart';
import 'package:http/http.dart';

enum OrderStatus {
  NotCreating,
  CreatingOrder,
  CreateOrderSuccess,
  CreateOrderFailure,
}

class OrderService extends ChangeNotifier {
  PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();

  OrderStatus _createOrderStatus = OrderStatus.NotCreating;
  OrderStatus get createOrderStatus => _createOrderStatus;

  Future<Result> createOrder(Order order) async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    Order createOrder = Order(
        token: token, addressId: order.addressId, orderItems: order.orderItems);

    final Map<String, dynamic> orderCreationData = createOrder.toJson();

    _createOrderStatus = OrderStatus.CreatingOrder;
    notifyListeners();

    Response response = await post(Uri.parse(ApiService.createOrder),
        body: json.encode(orderCreationData),
        headers: {'Content-Type': 'application/json'});

    final Map<String, dynamic> responseData = json.decode(response.body);

    var status = responseData['status_code'];

    if (status == 200) {
      var orderData = responseData['order'];
      // var uid = responseData['uid'];
      // var token = responseData['token'];

      var order = Order.fromJson(orderData);

      String message = responseData['message'];

      _createOrderStatus = OrderStatus.CreateOrderSuccess;
      notifyListeners();

      result = Result(true, message, order: order);
    } else {
      _createOrderStatus = OrderStatus.CreateOrderFailure;
      notifyListeners();

      var errors = responseData['errors'];

      print("The ERRORS: ${responseData['errors']}");

      result = Result(false, "Error registering");
    }

    print("Result value: $result");

    return result;
  }
}
