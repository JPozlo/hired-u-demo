import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/screens/home.dart';
import 'package:groceries_shopping_app/screens/main_home.dart';
import 'package:groceries_shopping_app/widgets/IllustraionContainer.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({Key? key, this.id}) : super(key: key);
  final int? id;

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> with AfterLayoutMixin<CheckOut> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Future.delayed(Duration(milliseconds: 100), () => awesomeDialog(context));
  }

  int _randomGeneratedCode() {
    Random random = new Random();
    return random.nextInt(10000000);
  }

  AwesomeDialog awesomeDialog(BuildContext context) {
    return AwesomeDialog(
      btnOkColor: Theme.of(context).primaryColor,
      context: context,
      animType: AnimType.BOTTOMSLIDE,
      headerAnimationLoop: false,
      dialogType: DialogType.SUCCES,
      autoHide: Duration(minutes: 10),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Your order has been placed',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              //   child: Text('Check your E-mail for confirmation.'),
              // ),
//               SizedBox(height: 30),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
//                 child: this.widget.id == null ?
//  Text(
//                   "Your Order Number is \n#" +
//                        _randomGeneratedCode().toString(),
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 20),
//                 ) :
//                 Text(
//                   "Your Order Number is \n#" +
//                        this.widget.id.toString(),
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 20),
//                 ),
//               ),
              SizedBox(height: 20),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: IllustrationContainer(
                    path: AppTheme.checkingoutSVG,
                    reduceSizeByHalf: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      btnOkOnPress: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainHome()),
            (route) => false);
      },
      // btnOk: _buildFancyButtonOk,
      onDissmissCallback: (type) {
        print("The dismiss type: $type");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainHome()),
            (route) => false);
      },
    )..show();
  }
}
