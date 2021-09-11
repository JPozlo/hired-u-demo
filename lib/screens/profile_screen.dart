import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mainPinkColor,
      body: SafeArea(
          child: Stack(
        clipBehavior: Clip.antiAlias,
        overflow: Overflow.visible,
        // alignment: Alignment.topCenter,
        children: [topBar(), listView(), personalInfoArea()],
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

  Widget personalInfoArea() {
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
                backgroundImage: AssetImage("assets/avatar.png"),
                radius: 50.0,
              ),
              SizedBox(
                height: 13.0,
              ),
              Text("Osolo"),
              SizedBox(
                height: 13.0,
              ),
              Text("email@gmail.com"),
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
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
