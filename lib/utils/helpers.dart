import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

String getFormattedCurrency(double amount) {
  FlutterMoneyFormatter fmf = new FlutterMoneyFormatter(amount: amount);
  fmf.settings.symbol = "KSh";
  fmf.settings.thousandSeparator = ",";
  fmf.settings.decimalSeparator = ".";
  return fmf.output.symbolOnLeft;
}

showSnackBar(BuildContext context, String message, {String action = "OK"}) {
  final _snackBar = SnackBar(
    duration: Duration(days: 365),
    content: Text(message),
    action: SnackBarAction(
        label: action,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }),
  );
  ScaffoldMessenger.of(context).showSnackBar(_snackBar);
}

String validateEmail(String value) {
  String _msg;
  RegExp regex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  if (value.isEmpty) {
    _msg = "Your email is required";
  } else if (!regex.hasMatch(value)) {
    _msg = "Please provide a valid email address";
  }
  return _msg;
}

nextScreenNamed(BuildContext context, String route) {
  return Navigator.of(context).pushNamed(route);
}

void nextFirstScreen(BuildContext context, Widget route) {
   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => route), (route) => false);
}

void nextScreen(BuildContext context, Widget routeWithArg) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => routeWithArg));
}
