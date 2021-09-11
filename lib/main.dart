import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groceries_shopping_app/providers/auth_provider.dart';
import 'package:groceries_shopping_app/providers/product_provider.dart';
import 'package:groceries_shopping_app/providers/providers.dart';
import 'package:groceries_shopping_app/screens/auth/home.dart';
import 'package:groceries_shopping_app/screens/home.dart';
import 'package:groceries_shopping_app/screens/main_home.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:groceries_shopping_app/providers/service_provider.dart';
import 'package:groceries_shopping_app/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:response/Response.dart';
import 'local_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceUtils.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String deviceModel;

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidDeviceInfo =
            await deviceInfoPlugin.androidInfo;
        deviceModel = androidDeviceInfo.model;
        print("Device Model: $deviceModel");
        _sharedPreferences.saveValueWithKey(
            Constants.userDeviceModelPrefKey, deviceModel);
      } else if (Platform.isIOS) {
        AndroidDeviceInfo androidDeviceInfo =
            await deviceInfoPlugin.androidInfo;
        deviceModel = androidDeviceInfo.model;
        
        print("Device Model IOS: $deviceModel");
    
        _sharedPreferences.saveValueWithKey(
            Constants.userDeviceModelPrefKey, deviceModel);
      }
    } on PlatformException {
      deviceModel = "Platform Exception";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsOperationsController()),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Response(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Home(),
        ),
      ),
    );
  }
}
