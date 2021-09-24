import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:groceries_shopping_app/models/result.dart';
import 'package:groceries_shopping_app/models/user.dart';
import 'package:groceries_shopping_app/services/api/api_service.dart';
import 'package:http/http.dart';

import '../local_database.dart';
import 'package:groceries_shopping_app/utils/utils.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  NotReset,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut,
  PasswordResetDone,
  PasswordResetting
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;
  Status _resetPassStatus = Status.NotReset;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  Status get resettingPassStatus => _resetPassStatus;

  PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();

  Future<Result> login(String email, String password) async {
    Result result;

    String deviceName = await _sharedPreferences
        .getValueWithKey(Constants.userDeviceModelPrefKey);

    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password,
      'device_name': deviceName
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      Uri.parse(ApiService.loginUser),
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},
    );

    final Map<String, dynamic> responseData = json.decode(response.body);

    var status = responseData['status_code'];

    print("Status code: $status");

    if (status == 200) {
      var userData = responseData['user'];
      var token = responseData['token'];

      var user = User.fromJsonUserData(userData);

      String message = responseData['message'];

      _sharedPreferences.saveValueWithKey(Constants.userNamePrefKey, user.name);
      _sharedPreferences.saveValueWithKey(Constants.userTokenPrefKey, token);
      _sharedPreferences.saveValueWithKey(
          Constants.userEmailPrefKey, user.email);
        _sharedPreferences.saveValueWithKey(
            Constants.userProfilePrefKey, user.profile ?? "");
          if(user.phone != null){
   _sharedPreferences.saveValueWithKey(
            Constants.userPhonePrefKey, user.phone ?? "");
          }
   

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      print("FINAL USER: $user");

      result = Result(true, message, user: user);
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();

      var errors = responseData['errors'];

      print("The ERRORS: ${responseData['errors']}");

      result = Result(false, "Error signing in", errors: errors);
    }
    return result;
  }

  Future<Result> register(String email, String password, String name, String phone) async {
    Result result;

    String deviceName = await _sharedPreferences
        .getValueWithKey(Constants.userDeviceModelPrefKey);

    User user = User(
      phone: phone,
        name: name, email: email, password: password, deviceName: deviceName);

    final Map<String, dynamic> registrationData = user.toJson();

    _registeredInStatus = Status.Registering;
    notifyListeners();

    Response response = await post(Uri.parse(ApiService.createNewUser),
        body: json.encode(registrationData),
        headers: {'Content-Type': 'application/json'});

    final Map<String, dynamic> responseData = json.decode(response.body);

    var status = responseData['status_code'];

    if (status == 200) {
      var userData = responseData['user'];
      // var uid = responseData['uid'];
      var token = responseData['token'];

      var user = User.fromJsonUserData(userData);

      String message = responseData['message'];

      _sharedPreferences.saveValueWithKey(Constants.userNamePrefKey, user.name);
      _sharedPreferences.saveValueWithKey(Constants.userTokenPrefKey, token);
      _sharedPreferences.saveValueWithKey(
          Constants.userEmailPrefKey, user.email);
        _sharedPreferences.saveValueWithKey(
            Constants.userPhonePrefKey, user.phone);
        _sharedPreferences.saveValueWithKey(
            Constants.userProfilePrefKey, user.profile ?? "");
      

      _registeredInStatus = Status.Registered;
      notifyListeners();

      result = Result(true, message, user: user);
    } else {
      _registeredInStatus = Status.NotRegistered;
      notifyListeners();

      var errors = responseData['errors'];

      print("The ERRORS: ${responseData['errors']}");

      result = Result(false, "Error registering");
    }

    print("Result value: $result");

    return result;
  }

  Future<Result> resetPassword(String email) async {
    Result result;

    // var token = await UserPreferences().getToken();
    var token = "jnsdji8292";

    var resetData = {"email": email, "device_name": "Samsung"};
    if (token != null) {
      _resetPassStatus = Status.PasswordResetting;
      notifyListeners();

      String message;
      Response response = await post(Uri.parse(ApiService.resetPassword),
          body: json.encode(resetData),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          });

      final Map<String, dynamic> responseData = json.decode(response.body);

      var status = responseData['status_code'];
      if (status == 200) {
        message = responseData['message'];

        _resetPassStatus = Status.PasswordResetDone;
        notifyListeners();
      } else {
        message = "Error occurred";

        _resetPassStatus = Status.NotReset;
        notifyListeners();
      }

      result = Result(true, message);
    } else {
      result = Result(false, "You have to be signed in first!");
    }

    return result;
  }

  getUserFromPreferences() async {
    User? user;
    // user = await UserPreferences().getUser();
    print("user prefs values: $user");
    return user;
  }

  Future<User> getUser(String tokenArg) async {
    User user;
    String token;
    // var localToken = await UserPreferences().getToken();
    var localToken = "ajaaaj";
    print("Local token value: $localToken");
    if (localToken == null) {
      token = tokenArg;
    } else {
      token = localToken;
    }

    Response response = await get(
      Uri.parse(ApiService.fetchUser),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    final Map<String, dynamic> responseData = json.decode(response.body);

    var status = responseData['status_code'];
    if (status == 200) {
      var myuser = responseData["user"];
      user = User.fromJsonUserData(myuser);
    } else {
      var errors = responseData['errors'];
      user = User();
    }
    return user;
  }

  // static Future<FutureOr> onValue(Response response) async {
  //   var result;
  //   final Map<String, dynamic> responseData = json.decode(response.body);
  //
  //   if (response.statusCode == 200) {
  //
  //     var userData = responseData['data'];
  //
  //     User authUser = User.fromJson(userData);
  //
  //     UserPreferences().saveUser(authUser);
  //     result = {
  //       'status': true,
  //       'message': 'Successfully registered',
  //       'data': authUser
  //     };
  //   } else {
  //
  //     result = {
  //       'status': false,
  //       'message': 'Registration failed',
  //       'data': responseData
  //     };
  //   }
  //
  //   return result;
  // }
  //
  // static onError(error) {
  //   print("the error is $error.detail");
  //   return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  // }

}
