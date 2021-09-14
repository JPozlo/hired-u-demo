import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/local_database.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/services/api/api_service.dart';
import 'package:groceries_shopping_app/utils/utils.dart';
import 'package:http/http.dart';

enum AddressStatus {
  NotCreating,
  CreatingService,
  CreateServiceSuccess,
  CreateServiceFailure,
}

class AddressProvider extends ChangeNotifier {
  PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();

  UserAddress _userAddress = new UserAddress();

  UserAddress get userAddress => _userAddress;

  set userAddress(UserAddress newAddress) {
    newAddress = _userAddress;
    notifyListeners();
  }

  AddressStatus _createAddressStatus = AddressStatus.NotCreating;
  AddressStatus get createAddressStatus => _createAddressStatus;

  Future<Result> createAddress(UserAddress userAddressParam) async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    final Map<String, dynamic> createServiceData = userAddressParam.toJson();

    _createAddressStatus = AddressStatus.CreatingService;
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

      _createAddressStatus = AddressStatus.CreateServiceSuccess;
      notifyListeners();

      result = Result(true, message == null ? "Success" : message,
          user: user, address: address);
    } else {
      _createAddressStatus = AddressStatus.CreateServiceFailure;
      notifyListeners();

      result = Result(false, "An unexpected error occurred");
    }
    return result;
  }
}
