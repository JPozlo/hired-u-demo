import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/local_database.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/services/api/api_service.dart';
import 'package:groceries_shopping_app/utils/utils.dart';
import 'package:http/http.dart';

enum AddressStatus {
  NotProcessing,
  Processing,
  Success,
  Failure,
}

class AddressProvider extends ChangeNotifier {
  PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();

  List<UserAddress> _userAddresses = [];

  AddressStatus _createAddressStatus = AddressStatus.NotProcessing;
  AddressStatus get createAddressStatus => _createAddressStatus;

  Future<Result> createAddress(UserAddress userAddressParam) async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    final Map<String, dynamic> createServiceData = userAddressParam.toJson();

    _createAddressStatus = AddressStatus.Processing;
    notifyListeners();

    Response response = await post(Uri.parse(ApiService.createAddress),
        body: json.encode(createServiceData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    final Map<String, dynamic> responseData = json.decode(response.body);

    var status = responseData['status_code'];

    if (status == 200) {
      var userData = responseData['user'];
      var addressData = responseData['new_address'];
      UserAddress address = UserAddress.fromJson(addressData);
      User user = User.fromJsonUserData(userData);

      String message = responseData['message'];

      _createAddressStatus = AddressStatus.Success;
      notifyListeners();

      result = Result(true, message == null ? "Success" : message,
          user: user, address: address);
    } else {
      _createAddressStatus = AddressStatus.Failure;
      notifyListeners();

      result = Result(false, "An unexpected error occurred");
    }
    return result;
  }

  Future<Result> updateAddress(UserAddress userAddressParam, int id) async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    final Map<String, dynamic> createServiceData = userAddressParam.toJson();

    _createAddressStatus = AddressStatus.Processing;
    notifyListeners();

    Response response = await post(Uri.parse(ApiService.updateAddress + id.toString()),
        body: json.encode(createServiceData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    final Map<String, dynamic> responseData = json.decode(response.body);

    var status = responseData['status_code'];

    if (status == 200) {
      var userData = responseData['user'];
      var addressData = responseData['updated_address'];
      UserAddress address = UserAddress.fromJson(addressData);
      User user = User.fromJsonUserData(userData);

      String message = responseData['message'];

      _createAddressStatus = AddressStatus.Success;
      notifyListeners();

      result = Result(true, message == null ? "Success" : message,
          user: user, address: address);
    } else {
      _createAddressStatus = AddressStatus.Failure;
      notifyListeners();

      result = Result(false, "An unexpected error occurred");
    }
    return result;
  }
}
