import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/local_database.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/providers/providers.dart';
import 'package:groceries_shopping_app/screens/pages.dart';
import 'package:groceries_shopping_app/services/api/google_auth.dart';
import 'package:groceries_shopping_app/utils/utils.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: AppTheme.mainPinkColor,
      body: SafeArea(
          child: Stack(
        clipBehavior: Clip.antiAlias,
        overflow: Overflow.visible,
        // alignment: Alignment.topCenter,
        children: [topBar(), listView(), personalInfoArea(userProvider.user)],
      )),
    );
  }

  Widget topBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 32,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text("Profile"),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Profile",
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget personalInfoArea(User user) {
    return Positioned(
      top: 40,
      left: 50, right: 50,
      // width: response.screenWidth * 0.7,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(13.5))),
        width: response.setWidth(response.screenWidth * 0.7),
        height: response.setHeight(210),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: user.profile == null ? AssetImage("assets/avatar.png"): NetworkImage(user.profile),
                radius: 50.0,
              ),
              SizedBox(
                height: 13.0,
              ),
              Text( user.name == null ? "Osolo" : user.name),
              SizedBox(
                height: 9.0,
              ),
              Text( user.email == null ? "email@gmail.com" : user.email),
                SizedBox(
                height: 13.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      nextScreen(context, EditProfilePage(user: user,));
                    },
                    child: Container(
                      child: SvgPicture.asset(
                        'assets/edit.svg',
                        width: 30,
                        height: 30,
                        color: AppTheme.mainBlueColor,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget listView() {
    return Positioned(
      top: 230,
      left: 0,
      width: response.screenWidth,
      child: Container(
        height: response.screenHeight * 0.8,
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            SizedBox(
              height: 48.0,
            ),
            ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: [
                ListTile(
                  leading: Icon(Icons.location_on_outlined),
                  title: Text("Residential Addresses"),
                ),
                ListTile(
                  leading: Icon(Icons.credit_card_outlined),
                  title: Text("Payment"),
                ),
                ListTile(
                  leading: Icon(Icons.support_agent),
                  title: Text("Support"),
                ),
                GestureDetector(
                  onTap: () async {},
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Logout"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  logout(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Action'),
        content: const Text('Are you sure  you want to logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.mainBlueColor),
            ),
          ),
          TextButton(
            onPressed: () async {
              var logoutStatus = await GoogleAuthentication.googleLogout();
              _sharedPreferences.removeMultipleValuesWithKeys([
                Constants.userTokenPrefKey,
                Constants.userEmailPrefKey,
                Constants.userNamePrefKey,
                Constants.userDeviceModelPrefKey
              ]);
              nextFirstScreen(context, Home());
            },
            child: const Text(
              'Confirm',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
