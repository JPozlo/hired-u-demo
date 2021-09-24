import 'dart:convert';

import 'package:groceries_shopping_app/local_database.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/models/update_password_dto.dart';
import 'package:groceries_shopping_app/models/update_profile_dto.dart';
import 'package:groceries_shopping_app/models/update_profile_user.dart';
import 'package:groceries_shopping_app/services/api/api_service.dart';
import 'package:groceries_shopping_app/utils/utils.dart';
import 'package:http/http.dart';

class UserService {
  PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();

  Future<Result> updateProfile(UpdateProfileDTO updateProfileDTOParam) async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    UpdateProfileDTO updateProfileDTO = UpdateProfileDTO(
        name: updateProfileDTOParam.name, phone: updateProfileDTOParam.phone);

    final Map<String, dynamic> updateUserProfileData =
        updateProfileDTO.toJson();
    print("createServiceDat: $updateUserProfileData");

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
          name: updateProfileUser.name,
          profile: updateProfileUser.profile,
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
      result = Result(
          true, message == null ? "Profile information updated" : message,
          user: user, updateProfileUser: updateProfileUser);
    } else {
      result = Result(false, "An unexpected error occurred");
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
    print("createServiceDat: $updateUserPasswordData");

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
      UpdateProfileUser updateProfileUser =
          UpdateProfileUser.fromJson(userData);

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
      result = Result(
          true, message == null ? "Profile information updated" : message,
          updateProfileUser: updateProfileUser);
    } else {
      result = Result(false, "An unexpected error occurred");
    }
    return result;
  }

  Future<Result> logoutUser() async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    Response response = await post(Uri.parse(ApiService.logoutUser),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    print("response: $response");

    final Map<String, dynamic> responseData = json.decode(response.body);
        print("responsedatalogout: ${responseData.toString()}");

    var status = responseData['status_code'];

    if (status == 200) {
      String message = responseData['message'];
      result = Result(true, message == null ? "Successful logout" : message);
                      _sharedPreferences.removeMultipleValuesWithKeys([
        Constants.userTokenPrefKey,
        Constants.userEmailPrefKey,
        Constants.userNamePrefKey,
        Constants.userPhonePrefKey,
        Constants.userProfilePrefKey,
        Constants.userFavoriteAddressPrefKey
      ]);
    } else {
      result = Result(false, "An unexpected error occurred");
    }
    return result;
  }
}
