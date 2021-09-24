import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/screens/auth/login.dart';
import 'package:groceries_shopping_app/screens/auth/register.dart';
import 'package:groceries_shopping_app/widgets/app_button.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mainScaffoldBackgroundColor,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned(
                    top: 100.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      height: 150.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/logo.png"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 24.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.0),
                      Text(
                        "Welcome!",
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(19, 22, 33, 1),
                            ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Please sign in or create an account below.",
                        style: TextStyle(
                          color: Color.fromRGBO(74, 77, 84, 1),
                          fontSize: 17.0,
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      // Let's create a generic button widget
                      AppButton(
                        text: "Sign In",
                        type: ButtonType.PLAIN,
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      AppButton(
                        text: "Create an Account",
                        type: ButtonType.PRIMARY,
                        onPressed: () {
                             Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Register()));
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
    );
  }
}
