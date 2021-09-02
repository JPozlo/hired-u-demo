  import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

String getFormattedCurrency(double amount) {
    FlutterMoneyFormatter fmf = new FlutterMoneyFormatter(amount: amount);
    fmf.settings.symbol = "\$";
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
