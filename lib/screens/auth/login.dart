import 'dart:io';

import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/providers/providers.dart';
import 'package:groceries_shopping_app/screens/auth/forgot_password.dart';
import 'package:groceries_shopping_app/screens/main_home.dart';
import 'package:groceries_shopping_app/widgets/app_button.dart';
import 'package:groceries_shopping_app/widgets/input_decoration_widget.dart';
import 'package:provider/provider.dart';


class Login extends StatelessWidget {
  final _formKey = new GlobalKey<FormState>();
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    final emailInput = TextFormField(
        // validator: validateEmail,
        onSaved: (value) => _email = value,
        // decoration: inputFieldDecoration("Enter your email address")
    );
    final passwordInput = TextFormField(
        obscureText: true,
        validator: (value) => value.isEmpty ? "Please enter password" : null,
        onSaved: (value) => _password = value,
        // decoration: inputFieldDecoration("Enter your password")
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Authenticating ... Please wait")
      ],
    );

    // var doLogin = () {
    //   final form = _formKey.currentState;
    //   if (form.validate()) {
    //     form.save();

    //     final Future<Result> loginResponse =
    //     auth.login(_email, _password);

    //     loginResponse.then((response) {
    //       if (response.status) {
    //         nextFirstScreen(context, Dashboard());
    //       } else {
    //         Flushbar(
    //           title: "Failed Login",
    //           message: response.message.toString(),
    //           duration: Duration(seconds: 3),
    //         ).show(context);
    //       }
    //     });
    //   } else {
    //     Flushbar(
    //       title: "Invalid form",
    //       message: "Please Complete the form properly",
    //       duration: Duration(seconds: 10),
    //     ).show(context);
    //   }
    // };

    return Scaffold(
      backgroundColor: AppTheme.mainOrangeColor,
      body: SafeArea(
        bottom: false,
        child: Container(
          child: Stack(
            overflow: Overflow.visible,
            children: [
              // Positioned(
              //   right: 0.0,
              //   top: -20.0,
              //   child: Opacity(
              //     opacity: 0.3,
              //     child: Image.asset(
              //       "assets/images/washing_machine_illustration.png",
              //     ),
              //   ),
              // ),
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 15.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                // FlutterIcons.keyboard_backspace_mdi,
                                Icons.arrow_back_rounded,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Log in to your account",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                            minHeight:
                                MediaQuery.of(context).size.height - 180.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                            ),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(24.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                label("Email"),
                                SizedBox(height: 7.0,),
                                emailInput,
                                SizedBox(
                                  height: 25.0,
                                ),
                                label("Password"),
                                SizedBox(height: 7.0,),
                                passwordInput,
                                GestureDetector(
                                  onTap: () {
                                    // nextScreen(context, "/password-reset");
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()));
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: AppTheme.mainOrangeColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                auth.loggedInStatus == Status.Authenticating ? loading :
                                AppButton(
                                  type: ButtonType.PRIMARY,
                                  text: "Log In",
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => MainHome() ));
                                  }
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
