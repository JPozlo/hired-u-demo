import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/providers/providers.dart';
import 'package:groceries_shopping_app/screens/main_home.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:groceries_shopping_app/services/api/google_auth.dart';
import 'package:groceries_shopping_app/utils/utils.dart';
import 'package:provider/provider.dart';

class SocialSignIn extends StatefulWidget {
  const SocialSignIn({Key key}) : super(key: key);

  @override
  _SocialSignInState createState() => _SocialSignInState();
}

class _SocialSignInState extends State<SocialSignIn> {


  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);

    // var doGoogleSignIn = () {
    //   Future signIn = auth.googleSignIn();

    //   loginResponse.then((response) {
    //     if (response.status) {
    //       userProvider.setUser(response.user);
    //       nextScreen(context, MainHome());
    //     } else {
    //       Flushbar(
    //         title: "Failed Login",
    //         message: response.message.toString(),
    //         duration: Duration(seconds: 3),
    //       ).show(context);
    //     }
    //   });
    // };

    // var doFacebookSignIn = () {
    //   final Future<Result> loginResponse = auth.googleSignIn();

    //   loginResponse.then((response) {
    //     if (response.status) {
    //       userProvider.setUser(response.user);
    //       nextScreen(context, MainHome());
    //     } else {
    //       Flushbar(
    //         title: "Failed Login",
    //         message: response.message.toString(),
    //         duration: Duration(seconds: 3),
    //       ).show(context);
    //     }
    //   });
    // };

    // var doAppleSignIn = () {
    //   final Future<Result> loginResponse = auth.googleSignIn();

    //   loginResponse.then((response) {
    //     if (response.status) {
    //       userProvider.setUser(response.user);
    //       nextScreen(context, MainHome());
    //     } else {
    //       Flushbar(
    //         title: "Failed Login",
    //         message: response.message.toString(),
    //         duration: Duration(seconds: 3),
    //       ).show(context);
    //     }
    //   });
    // };

    return Container(
      // height: response.setHeight(230.8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Or Sign In with a Social Account")],
          ),
          SizedBox(
            height: 23.8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){},
                child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // borderRadius: BorderRadius.circular(21.0),
                      // border: Border.all(color: AppTheme.mainBlueColor)
                    ),
                    child: Image(
                        width: 55, image: AssetImage('assets/facebook.png'))),
              ),
              SizedBox(
                width: 12.7,
              ),
              GestureDetector(
                onTap: (){},
                child: Container(
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.circular(21.0),
                      // border: Border.all(color: AppTheme.mainBlueColor)
                    ),
                    child: Image(
                        width: 55, image: AssetImage('assets/google.png'))),
              ),
            ],
          ),
          SizedBox(
            height: 12.4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){},
                child: Container(
                    // width: response.setWidth(response.screenWidth * 0.8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // borderRadius: BorderRadius.circular(21.0),
                      // border: Border.all(color: AppTheme.mainBlueColor)
                    ),
                    child: Image(
                        width: 55, image: AssetImage('assets/apple.png'))),
              ),
            ],
          )
        ],
      ),
    );
  }
}
