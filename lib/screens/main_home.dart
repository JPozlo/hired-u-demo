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
  String userProfile;
  String userPhone;
  String userDevice;

  final screens = [NewHome(), OrdersScreen(), ProfileScreen()];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
          print("User value: ${this.widget.user}");
      if (this.widget.user == null) {
        userName =
            _sharedPreferences.getValueWithKey(Constants.userNamePrefKey);
        userEmail =
            _sharedPreferences.getValueWithKey(Constants.userEmailPrefKey);
        userToken =
            _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);
            userProfile = _sharedPreferences.getValueWithKey(Constants.userProfilePrefKey);
            userPhone = _sharedPreferences.getValueWithKey(Constants.userPhonePrefKey);
        userDevice = _sharedPreferences
            .getValueWithKey(Constants.userDeviceModelPrefKey);
        print("If place is HIT: $userName");
      } else {
        userName = this.widget.user.name;
        userEmail = this.widget.user.email;
        userPhone = this.widget.user.phone ?? "";
        userProfile = this.widget.user.profile ?? "";
      }
      Provider.of<UserProvider>(context, listen: false).user = User(
userProfile ?? "",
          name: userName,
          phone: userPhone ?? "",
          email: userEmail,
          deviceName: userDevice,
          token: userToken);
    });

  }

  @override
  Widget build(BuildContext context) {
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
