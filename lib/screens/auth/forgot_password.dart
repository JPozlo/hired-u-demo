import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/providers/providers.dart';
import 'package:groceries_shopping_app/utils/utils.dart';
import 'package:groceries_shopping_app/widgets/app_button.dart';
import 'package:groceries_shopping_app/widgets/input_decoration_widget.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatelessWidget {
  final _formKey = new GlobalKey<FormState>();
  late String _email, _token;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final emailInput = TextFormField(
        validator: validateEmail,
        onSaved: (value) => _email = value!,
        decoration: inputFieldDecoration("Enter your email address"));

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Authenticating ... Please wait")
      ],
    );

    // var doResetPassword = () async {
    //   final form = _formKey.currentState;
    //   if (form.validate()) {
    //     form.save();
    //     final Future<Result> successfulMessage =
    //     auth.resetPassword(_email);

    //     successfulMessage.then((response) {
    //       if (response.status) {
    //         String message = response.message;
    //         Flushbar(
    //           title: "Success",
    //           message: message,
    //           duration: Duration(seconds: 5),
    //         ).show(context);
    //       } else {
    //         Flushbar(
    //           title: "Failed Login",
    //           message: response.message,
    //           duration: Duration(seconds: 5),
    //         ).show(context);
    //       }
    //     });
    //   } else {
    //     Flushbar(
    //       title: "Invalid email",
    //       message: "Please enter your email",
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
              Positioned(
                right: 0.0,
                top: -20.0,
                child: Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    "assets/logo.png",
                  ),
                ),
              ),
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
                                Icons.arrow_back_ios_rounded,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Reset Password",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
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
                                SizedBox(
                                  height: 7.0,
                                ),
                                emailInput,
                                SizedBox(
                                  height: 25.0,
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                auth.resettingPassStatus ==
                                        Status.PasswordResetting
                                    ? loading
                                    : AppButton(
                                        type: ButtonType.PRIMARY,
                                        text: "Get Password Reset Link",
                                        onPressed: () {
                                          Navigator.pop(context);
                                        })
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
