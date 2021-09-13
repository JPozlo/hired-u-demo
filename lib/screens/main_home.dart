import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/local_database.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/models/service_category.dart';
import 'package:groceries_shopping_app/providers/providers.dart';
import 'package:groceries_shopping_app/screens/home.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:groceries_shopping_app/screens/order_screen.dart';
import 'package:groceries_shopping_app/screens/profile_screen.dart';
import 'package:groceries_shopping_app/utils/constants.dart';
import 'package:groceries_shopping_app/widgets/drawer_widget.dart';
import 'package:provider/provider.dart';

class MainHome extends StatefulWidget {
  const MainHome({Key key, this.user}) : super(key: key);
  final User user;

  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();
  int _currentIndex = 0;
  String userName;
  String userEmail;
  String userToken;
  String userDevice;

  final screens = [
    NewHome(),
    OrdersScreen(),
    ProfileScreen()
  ];

  @override
  void initState() {
    super.initState();
    userName = _sharedPreferences.getValueWithKey(Constants.userNamePrefKey);
    userEmail = _sharedPreferences.getValueWithKey(Constants.userEmailPrefKey);
    userToken = _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);
    userDevice = _sharedPreferences.getValueWithKey(Constants.userDeviceModelPrefKey);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context).user =  User(name: userName, email: userEmail, deviceName: userDevice, token: userToken);
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: AppTheme.mainDarkBackgroundColor,
        selectedItemColor: AppTheme.mainOrangeColor,
        unselectedItemColor: AppTheme.mainScaffoldBackgroundColor,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
            backgroundColor: AppTheme.mainCardBackgroundColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History",
            backgroundColor: AppTheme.mainCardBackgroundColor,
          ),
          //    BottomNavigationBarItem(
          //   icon: Icon(Icons.card_giftcard),
          //   label: "Orders",
          //   backgroundColor: AppTheme.mainCardBackgroundColor,
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account",
            backgroundColor: AppTheme.mainCardBackgroundColor,
          ),
        ],
      ),
    );
  }
}
