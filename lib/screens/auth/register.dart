import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/providers/providers.dart';
import 'package:groceries_shopping_app/screens/main_home.dart';
import 'package:groceries_shopping_app/services/api/google_auth.dart';
import 'package:groceries_shopping_app/utils/utils.dart';
import 'package:groceries_shopping_app/widgets/app_button.dart';
import 'package:groceries_shopping_app/widgets/input_decoration_widget.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _nameController = new TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  File _imageFile;
  String _email, _phone, _password, _confirmPassword;

  Future signIn() async {
    var googleUser = await GoogleAuthentication.googleLogin();
    setState(() {
      _emailController.text = googleUser.email;
      _nameController.text = googleUser.displayName;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);

    final emailInput = TextFormField(
        controller: _emailController,
        validator: validateEmail,
        onSaved: (value) => _email = value,
        decoration: inputFieldDecoration(
            "Enter your email address eg: example@gmail.com"));

    final nameInput = TextFormField(
        controller: _nameController,
        validator: (value) => value.isEmpty ? "Please enter your name" : null,
        onSaved: (value) => _phone = value,
        decoration: inputFieldDecoration("Enter your name"));

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
      if (_confirmPassword.trim() != _password.trim()) {
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

    var doRegister = () {
      final form = _formKey.currentState;
      if (form.validate()) {
        form.save();
        if (_verifyPasswordsMatch()) {
          auth.register(_email, _password, _phone).then((response) {
            if (response.status) {
              userProvider.user = response.user;
              nextFirstScreen(context, MainHome(user: userProvider.user,));
            } else {
              Flushbar(
                title: "Registration Failed",
                message: response.message.toString(),
                duration: Duration(seconds: 10),
              ).show(context);
            }
          });
        } else {
          Flushbar(
            title: "Error",
            message: "THe passwords don't match",
            duration: Duration(seconds: 7),
          ).show(context);
        }
      } else {
        Flushbar(
          title: "Invalid form",
          message: "Please Complete the form properly",
          duration: Duration(seconds: 10),
        ).show(context);
      }
    };

    return Scaffold(
      backgroundColor: AppTheme.mainOrangeColor,
      body: SafeArea(
        bottom: false,
        child: Container(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
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
                                label("Name"),
                                SizedBox(
                                  height: 7.0,
                                ),
                                nameInput,
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
                                // AppButton(
                                //   type: ButtonType.PLAIN,
                                //   text: "Pick Profile Picture",
                                //   onPressed: () async {
                                //     // _imageFile = await nextScreen(
                                //     //     context, "/select-image");
                                //     // if (_imageFile != null) {
                                //     //   setState(() {
                                //     //     _imageFile = _imageFile;
                                //     //   });
                                //     //   print(
                                //     //       "The image file path is: ${_imageFile.path}");
                                //     // }
                                //   },
                                // ),
                                // SizedBox(
                                //   height: 18.0,
                                // ),

                                auth.registeredInStatus == Status.Registering
                                    ? loading
                                    : AppButton(
                                        type: ButtonType.PRIMARY,
                                        text: "Sign Up",
                                        onPressed: doRegister,
                                        // onPressed: (){
                                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => MainHome() ));
                                        // },
                                      ),
                                buildSocialButtons()
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

  Widget buildSocialButtons() {
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
                onTap: signIn,
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
                onTap: signIn,
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
                onTap: signIn,
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
