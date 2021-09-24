import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutterwave/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/local_database.dart';
import 'package:groceries_shopping_app/providers/providers.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:groceries_shopping_app/screens/pages.dart';
import 'package:groceries_shopping_app/services/api/api_service.dart';
import 'package:groceries_shopping_app/utils/custom_text_style.dart';
import 'package:groceries_shopping_app/utils/utils.dart';
import 'package:groceries_shopping_app/widgets/IllustraionContainer.dart';
import 'package:provider/provider.dart';

class MpesaPayment extends StatefulWidget {
  const MpesaPayment(
      {Key? key,
      required this.transactionRef,
      required this.amount,
      required this.id})
      : super(key: key);

  final String transactionRef;
  final int amount;
  final int id;

  @override
  _MpesaPaymentState createState() => _MpesaPaymentState();
}

class _MpesaPaymentState extends State<MpesaPayment> {
  PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final String txref = "My_unique_transaction_reference_123";
  final String amount = "200";
  final String? publicKey = dotenv.env['PAYMENT_PUBLIC_KEY'];
  final String? encryptionKey = dotenv.env['PAYMENT_ENCRYPTION_KEY'];
  final String currency = FlutterwaveCurrency.KES;

  String _phone = "";
  late String name, email;

  @override
  void initState() {
    super.initState();
    name = _sharedPreferences.getValueWithKey(Constants.userNamePrefKey);
    email = _sharedPreferences.getValueWithKey(Constants.userEmailPrefKey);
  }

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
                      SizedBox(
                        height: 14,
                      ),
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
    Widget child = Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          height: response.setHeight(48.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextFormField(
            validator: (value) {
              String? message;
              if (value!.isEmpty) {
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
      width: response.screenWidth! * 0.9,
      height: response.setHeight(40),
      margin: EdgeInsets.only(left: 12.0, right: 12.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            beginPayment();
          } else {
            showSnackBar(context, "Enter valid mobile number!");
          }
        },
        style: ElevatedButton.styleFrom(
          primary: AppTheme.mainBlueColor,
          textStyle: TextStyle(color: Colors.black),
        ),
        child: Text(
          "Pay",
          style: CustomTextStyle.textFormFieldMedium.copyWith(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  beginPayment() async {
    final Flutterwave flutterwave = Flutterwave.forUIPayment(
      context: this.context,
      encryptionKey: this.encryptionKey!,
      publicKey: this.publicKey!,
      currency: this.currency,
      amount: this.widget.amount.toString(),
      email: email,
      fullName: name,
      txRef: this.widget.transactionRef,
      isDebugMode: true,
      phoneNumber: _phone,
      acceptCardPayment: true,
      acceptUSSDPayment: true,
    );

    try {
      final ChargeResponse response =
          await flutterwave.initializeForUiPayments();
      if (response == null) {
        // user didn't complete the transaction.
        Fluttertoast.showToast(msg: "Transaction cancelled");
      } else {
        final isSuccessful = checkPaymentIsSuccessful(response);
        print("Success status: $isSuccessful");
        if (isSuccessful) {
          var result = await ApiService()
              .sendPaymentConfirmation(int.parse(response.data!.id!));
          print("Data: ${response.data}");
          print("Data Customer: ${response.data?.customer.toString()}");
          print("Response: ${response.toString()}");
          // check message
          print("Message: ${response.message}");
          // check status
          print("Status : ${response.status}");
          // Fluttertoast.showToast(msg: "Successfully made payment");
          Provider.of<ProductsOperationsController>(context, listen: false)
              .clearCart();
          // nextScreen(context, CheckOut());
          awesomeSuccessDialog(context, this.widget.id);
        } else {
          // check message
          print("Message: ${response.message}");
          // check status
          print("Status : ${response.status}");

          // check processor error
          print("Procesor error: ${response.data?.processorResponse}");
          // Fluttertoast.showToast(msg: "Error occurred. Try again!");
          Provider.of<ProductsOperationsController>(context, listen: false)
              .clearCart();
          awesomeErrorDialog(context);
        }
      }
    } catch (error, stacktrace) {
      print("Error: $error");
    }
  }

  AwesomeDialog awesomeSuccessDialog(BuildContext context, int id) {
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
                'Success',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
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

  AwesomeDialog awesomeErrorDialog(BuildContext context) {
    return AwesomeDialog(
      btnOkColor: Theme.of(context).primaryColor,
      context: context,
      animType: AnimType.BOTTOMSLIDE,
      headerAnimationLoop: false,
      dialogType: DialogType.ERROR,
      autoHide: Duration(minutes: 10),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Sorry!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              //   child: Text('Check your E-mail for confirmation.'),
              // ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Text(
                  "An error occurred and your order couldn't be completed",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 20),
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

  bool checkPaymentIsSuccessful(final ChargeResponse response) {
    return response.data?.status == FlutterwaveConstants.SUCCESSFUL &&
        response.data?.currency == this.currency &&
        response.data?.amount == this.widget.amount.toString() &&
        response.data?.txRef == this.widget.transactionRef;
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
