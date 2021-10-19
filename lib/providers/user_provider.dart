import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:groceries_shopping_app/local_database.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/models/update_password_dto.dart';
import 'package:groceries_shopping_app/models/user.dart';
import 'package:groceries_shopping_app/services/api/api_service.dart';
import 'package:groceries_shopping_app/utils/utils.dart';
import 'package:http/http.dart';

enum ProcessingState {
  NotProcessing,
  ProcessedSuccess,
  ProcessedFailure,
  Processing
}

class UserProvider with ChangeNotifier {
  PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();
  User _user = new User();

  ProcessingState _processingStatus = ProcessingState.NotProcessing;

  ProcessingState get processingStatus => _processingStatus;

  User get user => _user;

  set user(User user) {
    _user = user;
    notifyListeners();
  }

  Future<Result> updateProfile(UpdateProfileDTO updateProfileDTOParam) async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    UpdateProfileDTO updateProfileDTO = UpdateProfileDTO(
        name: updateProfileDTOParam.name, phone: updateProfileDTOParam.phone, email: updateProfileDTOParam.email);

    final Map<String, dynamic> updateUserProfileData =
        updateProfileDTO.toJson();
    print("createServiceDat: $updateUserProfileData");

    _processingStatus = ProcessingState.Processing;
    notifyListeners();

    Response response = await post(Uri.parse(ApiService.changeProfile),
        body: json.encode(updateUserProfileData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    print("response: $response");

    final Map<String, dynamic> responseData = json.decode(response.body);

    var status = responseData['status_code'];

    if (status == 200) {
      var userData = responseData['user'];
      UpdateProfileUser updateProfileUser =
          UpdateProfileUser.fromJson(userData);

      User user = User(
      profile: updateProfileUser.profile,
          name: updateProfileUser.name,
          email: updateProfileUser.email,
          uid: updateProfileUser.id,
          phone: updateProfileUser.phone,
          deviceName: updateProfileUser.deviceName);

      _sharedPreferences.saveValueWithKey(
          Constants.userNamePrefKey, updateProfileUser.name);
      _sharedPreferences.saveValueWithKey(
          Constants.userPhonePrefKey, updateProfileUser.phone);
      if (updateProfileUser.phone!.isNotEmpty ||
          updateProfileUser.phone == null ||
          updateProfileUser.profile == null ||
          updateProfileUser.profile!.isNotEmpty) {
        _sharedPreferences.saveValueWithKey(
            Constants.userPhonePrefKey, updateProfileUser.phone ?? "");
        _sharedPreferences.saveValueWithKey(
            Constants.userProfilePrefKey, updateProfileUser.profile ?? "");
      }

      String message = responseData['message'];
      _processingStatus = ProcessingState.ProcessedSuccess;
      notifyListeners();

      result = Result(
          true, message == null ? "Profile information updated" : message,
          user: user, updateProfileUser: updateProfileUser);
    } else {
      result = Result(false, "An unexpected error occurred");
      _processingStatus = ProcessingState.ProcessedFailure;
      notifyListeners();
    }
    return result;
  }

  Future<Result> updatePassword(
      UpdatePasswordDTO updatePasswordDTOParam) async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    UpdatePasswordDTO updatePasswordDTO = UpdatePasswordDTO(
        password: updatePasswordDTOParam.password,
        newPassword: updatePasswordDTOParam.newPassword);

    final Map<String, dynamic> updateUserPasswordData =
        updatePasswordDTO.toJson();
    // final Map<String, dynamic> updateUserPasswordData = {
    //   'password': updatePasswordDTOParam.password,
    //   'new_password': updatePasswordDTOParam.newPassword
    // };
    print("createServiceDat: $updateUserPasswordData");

    _processingStatus = ProcessingState.Processing;
    notifyListeners();

    Response response = await post(Uri.parse(ApiService.changePassword),
        body: json.encode(updateUserPasswordData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    final Map<String, dynamic> responseData = json.decode(response.body);

    print("responsedata: ${responseData.toString()}");

    var status = responseData['status_code'];

    if (status == 200) {
      var userData = responseData['user'];
      User updateProfileUser = User.fromJsonUserData(userData);

      if (updateProfileUser.phone != null ||
          updateProfileUser.profile != null) {
        _sharedPreferences.saveValueWithKey(
            Constants.userPhonePrefKey, updateProfileUser.phone ?? "");
        _sharedPreferences.saveValueWithKey(
            Constants.userProfilePrefKey, updateProfileUser.profile ?? "");
      }

      String message = responseData['message'];
      result = Result(
          true, message == null ? "Profile information updated" : message,
          user: updateProfileUser);
      _processingStatus = ProcessingState.ProcessedSuccess;
      notifyListeners();
    } else {
      result = Result(false, "An unexpected error occurred");
      _processingStatus = ProcessingState.ProcessedFailure;
      notifyListeners();
    }
    return result;
  }
}
