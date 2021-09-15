import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static PreferenceUtils _instance;
  static SharedPreferences _preferences;

  static PreferenceUtils getInstance() {
    if (_instance == null) {
      _instance = PreferenceUtils();
    }
    return _instance;
  }

  static Future<void> init() async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
      print("Shared Preferences has been initiated");
    }
  }

  /// T is the  `runTimeType` data which you are trying to save (bool - String - double)
  Future<bool> saveValueWithKey<T>(String key, T value) async {
    print("SharedPreferences: [Saving data] -> key: $key, value: $value");
    assert(_instance != null);
    assert(_preferences != null);
    if (value is String) {
      return await _preferences.setString(key, value);
    } else if (value is bool) {
      return await _preferences.setBool(key, value);
    } else if (value is double) {
      return await _preferences.setDouble(key, value);
    } else if (value is int) {
      return await _preferences.setInt(key, value);
    } else if (value is List<String>) {
      print("WARNING: You are trying to save a [value] of type [List<String>]");
      return await _preferences.setStringList(key, value);
    } else if (value is List<Product>) {
      List<String> _list = value?.map((e) => json.encode(e.toJson()))?.toList();
      return await _preferences.setStringList(key, _list);
    } else {
      throw "not a supported type";
    }
    return false;
  }

  // Future<bool> saveBool(String key, bool value) {
  //   print("SharedPreferences: [Save data] -> key: $key, value: $value");
  //   return _preferences.setBool(key, value);
  // }

  ///Not a Future method
  getValueWithKey(String key,
      {bool bypassValueChecking = true, bool hideDebugPrint = false}) {
    assert(_preferences != null);
    assert(_instance != null);
    var value = _preferences.get(key);
    if (value == null && !bypassValueChecking) {
      throw PlatformException(
          code: "SHARED_PREFERENCES_VALUE_CAN'T_BE_NULL",
          message:
              "you have ordered a value which doesn't exist in Shared Preferences",
          details:
              "make sure you have saved the value in advance in order to get it back");
    }
    if (!hideDebugPrint)
      print("SharedPreferences: [Reading data] -> key: $key, value: $value");
    return value;
  }

/// Retrieve object Lists
   List<T> getObjectListValuesWithKey<T>(String key, T f(Map v),
      {bool bypassValueChecking = true, bool hideDebugPrint = false, List<T> defValue = const []}) {
    assert(_preferences != null);
    assert(_instance != null);
    List<Map> dataList = getObjectList(key);
    List<T> listValues = dataList?.map((value) {
      return f(value);
    })?.toList();
    if (listValues.length < 1 || listValues == null && !bypassValueChecking) {
      throw PlatformException(
          code: "SHARED_PREFERENCES_VALUE_CAN'T_BE_NULL",
          message:
              "you have ordered a value which doesn't exist in Shared Preferences",
          details:
              "make sure you have saved the value in advance in order to get it back");
    }
    if (!hideDebugPrint)
      print("SharedPreferences: [Reading data] -> key: $key, value: ${listValues.toString()}");
    return listValues;
  }


  List<Map> getObjectList(String key) {
    assert(_preferences != null);
    assert(_instance != null);
    List<String> dataList = _preferences.getStringList(key);
    return dataList?.map((value) {
      Map _dataMap = json.decode(value);
      return _dataMap;
    })?.toList();
  }
  
  Future<bool> removeValueWithKey(String key) async {
    var value = _preferences.get(key);
    if (value == null) return true;
    assert(_preferences != null);
    assert(_instance != null);
    print("SharedPreferences: [Removing data] -> key: $key, value: $value");
    return await _preferences.remove(key);
  }

  removeMultipleValuesWithKeys(List<String> keys) async {
    assert(_preferences != null);
    assert(_instance != null);
    var value;
    for (String key in keys) {
      value = _preferences.get(key);
      if (value == null) {
        print(
            "SharedPreferences: [Removing data] -> key: $key, value: {ERROR 'null' value}");
        print("Skipping...");
      } else {
        await _preferences.remove(key);
        print("SharedPreferences: [Removing data] -> key: $key, value: $value");
      }
    }
    return;
  }

  Future<bool> clearAll() async {
    assert(_preferences != null);
    assert(_instance != null);
    return await _preferences.clear();
  }
}
