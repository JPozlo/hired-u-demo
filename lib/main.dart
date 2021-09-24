import 'dart:io';

import 'package:catcher/catcher.dart';
import 'package:catcher/model/catcher_options.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groceries_shopping_app/providers/providers.dart';
import 'package:groceries_shopping_app/providers/service_provider.dart';
import 'package:groceries_shopping_app/screens/pages.dart';
import 'package:groceries_shopping_app/services/api/api_service.dart';
import 'package:groceries_shopping_app/utils/utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:response/Response.dart';
import 'local_database.dart';

void main() async {
  ///Configure your debug options (settings used in development mode)
  CatcherOptions debugOptions = CatcherOptions(
    ///Show information about caught error in dialog
    DialogReportMode(),
    [
      ///Send logs to HTTP server
      // HttpHandler(HttpRequestType.post, Uri.parse(ApiService.mobileLogs),
      //     printLogs: true),

      ///Print logs in console
      ConsoleHandler()
    ],
  );

  ///Configure your production options (settings used in release mode)
  CatcherOptions releaseOptions = CatcherOptions(
    ///Show new page with information about caught error
    DialogReportMode(),
    [
      HttpHandler(HttpRequestType.post, Uri.parse(ApiService.mobileLogs),
          printLogs: true),

      ///Print logs in console
      ConsoleHandler(),
      EmailManualHandler(["4mconsultingke@gmail.com"])
    ],
  );
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .whenComplete(() async {
    await PreferenceUtils.init();
    await dotenv.load(fileName: '.env');
    // Catcher(
        // runAppFunction: () {
          runApp(MyApp());
        // };
        // debugConfig: debugOptions,
        // releaseConfig: releaseOptions
        // );
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();
  String? token;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    token = _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);
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
        ChangeNotifierProvider(create: (_) => AddressProvider()),
      ],
      child: Response(
        child: MaterialApp(
          // navigatorKey: Catcher.navigatorKey,
          //       builder: (BuildContext context, Widget? widget) {
          //   Catcher.addDefaultErrorWidget(
          //       showStacktrace: true,
          //       title: "Sorry!",
          //       description: "We are having a temporary issue and are working to fix it quickly",
          //       maxWidthForSmallMode: 150);
          //   return widget!;
          // },
          debugShowCheckedModeBanner: false,
          home: token == null ? Home() : MainHome(),
        ),
      ),
    );
  }
}
