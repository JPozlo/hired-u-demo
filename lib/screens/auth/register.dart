import 'dart:io';

import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/providers/providers.dart';
import 'package:groceries_shopping_app/screens/main_home.dart';
import 'package:groceries_shopping_app/utils/utils.dart';
import 'package:groceries_shopping_app/widgets/app_button.dart';
import 'package:groceries_shopping_app/widgets/input_decoration_widget.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = new GlobalKey<FormState>();
  File _imageFile;
  String _email, _phone, _password, _confirmPassword;
  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final emailInput = TextFormField(
        validator: validateEmail,
        onSaved: (value) => _email = value,
        decoration: inputFieldDecoration(
            "Enter your email address eg: example@gmail.com"));

    final phoneInput = TextFormField(
        validator: (value) =>
            value.isEmpty ? "Please enter phone number" : null,
        onSaved: (value) => _phone = value,
        decoration: inputFieldDecoration(
            "Enter your mobile number with eg: +254734567890"));

    final passwordInput = TextFormField(
        obscureText: true,
        validator: (value) => value.isEmpty ? "Please enter password" : null,
        onSaved: (value) => _password = value,
        decoration: inputFieldDecoration("Enter your password"));

    final confirmPasswordInput = TextFormField(
        obscureText: true,
        validator: (value) => value.isEmpty ? "Please confirm password" : null,
        onSaved: (value) => _confirmPassword = value,
        decoration: inputFieldDecoration("Enter your password again"));

    bool _verifyPasswordsMatch() {
      if(_confirmPassword.trim() != _password.trim()){
        print("Pass NOT MATCH HIT");
        return false;
      }
      print("Pass MATCH HIT");
      return true;
    }

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Registering ... Please wait")
      ],
    );

    // var doRegister = () {
    //   final form = _formKey.currentState;
    //   if (form.validate()) {
    //     form.save();
    //     if(_verifyPasswordsMatch()){
    //       auth.register(_email, _password, _phone).then((response) {
    //         if (response.status) {
    //           nextFirstScreen(context, Dashboard());
    //         } else {
    //           Flushbar(
    //             title: "Registration Failed",
    //             message: response.message.toString(),
    //             duration: Duration(seconds: 10),
    //           ).show(context);
    //         }
    //       });
    //     } else{
    //       Flushbar(
    //         title: "Error",
    //         message: "THe passwords don't match",
    //         duration: Duration(seconds:7),
    //       ).show(context);
    //     }
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
            clipBehavior: Clip.hardEdge,
            // overflow: Overflow.visible,
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
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Sign up for an account",
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
                                // Lets make a generic input widget
                                label("Email"),
                                SizedBox(
                                  height: 7.0,
                                ),
                                emailInput,
                                SizedBox(
                                  height: 25.0,
                                ),
                                label("Phone"),
                                SizedBox(
                                  height: 7.0,
                                ),
                                phoneInput,
                                SizedBox(
                                  height: 25.0,
                                ),
                                label("Password"),
                                SizedBox(
                                  height: 7.0,
                                ),
                                passwordInput,
                                SizedBox(
                                  height: 25.0,
                                ),
                                label("Confirm Password"),
                                SizedBox(
                                  height: 7.0,
                                ),
                                confirmPasswordInput,
                                SizedBox(
                                  height: 20.0,
                                ),
                                AppButton(
                                  type: ButtonType.PLAIN,
                                  text: "Pick Profile Picture",
                                  onPressed: () async {
                                    // _imageFile = await nextScreen(
                                    //     context, "/select-image");
                                    // if (_imageFile != null) {
                                    //   setState(() {
                                    //     _imageFile = _imageFile;
                                    //   });
                                    //   print(
                                    //       "The image file path is: ${_imageFile.path}");
                                    // }
                                  },
                                ),
                                SizedBox(
                                  height: 18.0,
                                ),

                                auth.registeredInStatus == Status.Registering
                                    ? loading
                                    : AppButton(
                                        type: ButtonType.PRIMARY,
                                        text: "Sign Up",
                                        onPressed: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => MainHome() ));
                                        },
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
