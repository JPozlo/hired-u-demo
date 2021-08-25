import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/product_provider.dart';
import 'package:groceries_shopping_app/screens/home.dart';
import 'package:groceries_shopping_app/screens/main_home.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:groceries_shopping_app/service_provider.dart';
import 'package:provider/provider.dart';
import 'package:response/Response.dart';
import 'local_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceUtils.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsOperationsController()),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
      ],
      child: Response(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MainHome(),
        ),
      ),
    );
  }
}
