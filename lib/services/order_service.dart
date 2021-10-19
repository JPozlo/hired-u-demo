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

class OrderService {
  PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();

  Future<Result> fetchOrdersHistory() async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    Response response = await get(Uri.parse(ApiService.ordersHistory),
        headers: {'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
        });

    final Map<String, dynamic> responseData = json.decode(response.body);

    var status = responseData['status_code'];

    if (status == 200) {
      var orderData = responseData['order'];
      
      var order = Order.fromJson(orderData);

      String message = responseData['message'];

      result = Result(true, message, order: order);
    } else {

      var errors = responseData['errors'];

      print("The ERRORS: ${responseData['errors']}");

      result = Result(false, "Error registering");
    }

    print("Result value: $result");

    return result;
  }
}
