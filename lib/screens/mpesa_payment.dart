import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/screens/checkout_screen.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:groceries_shopping_app/utils/custom_text_style.dart';

class MpesaPayment extends StatefulWidget {
  const MpesaPayment({ Key key }) : super(key: key);

  @override
  _MpesaPaymentState createState() => _MpesaPaymentState();
}

class _MpesaPaymentState extends State<MpesaPayment> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _phone = "";

    @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _topBarUI(),
            Spacer(),
            Center(
              child: Container(
              alignment: Alignment.center,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    phoneWidget(),
                    SizedBox(height: 14,)          ,
                    buttonWidget()
                  ],
                ),
              ),
              ),
              ),
              Spacer(),
          ],
        ),
      ),      
    );
  }

 Widget _topBarUI() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Hero(
            tag: 'backarrow',
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: response.setHeight(23),
              ),
            ),
          ),
          Spacer(flex: 5),
          Text(
            "Make Payment",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: response.setFontSize(18),
            ),
          ),
          Spacer(flex: 5),
        ],
      ),
    );
  }

  Widget phoneWidget() {
    Widget child = 
    Padding(
      padding: EdgeInsets.all(8.0),
      child:     Container(
      height: response.setHeight(48.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        validator: (value) {
          String message;
          if (value.isEmpty) {
            message = "Mobile number can't be empty";
          } else {
            message = null;
          }
          return message;
        },
        onChanged: (value) {
          setState(() {
            _phone = value;
          });
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(74, 77, 84, 0.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.mainOrangeColor,
            ),
          ),
          hintText: "Enter Your Mobile Number",
          hintStyle: TextStyle(
            fontSize: 14.0,
            color: Color.fromRGBO(105, 108, 121, 0.7),
          ),
        ),
      ),
    ));

    return child;
  }

  Widget buttonWidget() {
    return Container(
      width: response.screenWidth * 0.9,
      height: response.setHeight(40),
      margin: EdgeInsets.only(left: 12.0, right: 12.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            // showSnackBar(context, "Payment being processed...");
             Navigator.push(
                context, MaterialPageRoute(builder: (context) => CheckOut()));
          } else {
            showSnackBar(context, "Enter valid mobile number!");
          }
        },
        style: ElevatedButton.styleFrom(
          primary: AppTheme.mainRedColor,
          textStyle: TextStyle(color: Colors.black),
        ),
        child: Text(
          "Pay",
          style: CustomTextStyle.textFormFieldMedium.copyWith(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

    showSnackBar(BuildContext context, String message, {String action = "OK"}) {
    final _snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
          label: action,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }),
    );
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }
  
}