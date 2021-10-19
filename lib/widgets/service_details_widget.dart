import 'package:another_flushbar/flushbar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutterwave/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/local_database.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/providers/providers.dart';
import 'package:groceries_shopping_app/screens/checkout_screen.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:groceries_shopping_app/screens/pages.dart';
import 'package:groceries_shopping_app/services/api/api_service.dart';
import 'package:groceries_shopping_app/utils/helpers.dart';
import 'package:groceries_shopping_app/utils/utils.dart';
import 'package:groceries_shopping_app/widgets/IllustraionContainer.dart';
import 'package:provider/provider.dart';

class ServiceDetails extends StatefulWidget {
  ServiceDetails(
      {Key? key, required this.widgetTitle, required this.subServices})
      : super(key: key);
  final String widgetTitle;
  final List<MiniService> subServices;

  @override
  _ServiceDetailsState createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  final _formKey = new GlobalKey<FormState>();
  PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();
  final String? publicKey = dotenv.env['PAYMENT_PUBLIC_KEY'];
  final String? encryptionKey = dotenv.env['PAYMENT_ENCRYPTION_KEY'];
  final String currency = FlutterwaveCurrency.KES;

  bool selected = false;
  late String _location;
  bool doLoading = false;
  late Map<MiniService, bool> itemsMap;
  List<int> _selectedItem = [];
  late String name, email, phone;

  @override
  void initState() {
    super.initState();
    name = _sharedPreferences.getValueWithKey(Constants.userNamePrefKey);
    email = _sharedPreferences.getValueWithKey(Constants.userEmailPrefKey);
    phone = _sharedPreferences.getValueWithKey(Constants.userPhonePrefKey);
    itemsMap = Map.fromIterable(this.widget.subServices,
        key: (item) => item, value: (item) => false);
    print("The map: $itemsMap");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.mainScaffoldBackgroundColor,
        brightness: Brightness.light,
        leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            icon: Hero(
              tag: 'backarrow',
              child: Icon(Icons.arrow_back,
                  color: Colors.black, size: response.setHeight(24)),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          this.widget.widgetTitle,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            this.itemsMap == null || this.itemsMap.length < 1
                ? Text(
                    "No services available under this category yet!",
                    style: TextStyle(fontSize: 17),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: this.itemsMap.length,
                    itemBuilder: (context, index) {
                      MiniService item = this.itemsMap.keys.elementAt(index);
                      return CheckboxListTile(
                          title: Text(item.name),
                          subtitle: Text("KSh ${item.price}"),
                          value: item.isChecked,
                          onChanged: (bool? value) {
                            print("Value $value");
                            setState(() {
                              item.isChecked = value!;
                              if (item.isChecked == true) {
                                _selectedItem.add(item.id);
                              } else {
                                _selectedItem.remove(item.id);
                              }
                            });
                            print("The selected items: $_selectedItem");
                          });
                    }),
            SizedBox(
              height: 12,
            ),
            locationWidget(),
            doLoading
                ? loading
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppTheme.mainBlueColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: const Text(
                        'Make Order',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      final form = _formKey.currentState;
                      if (form!.validate()) {
                        form.save();

                        setState(() {
                          doLoading = true;
                        });
                        if (this.itemsMap == null || this.itemsMap.length < 1) {
                          setState(() {
                            doLoading = false;
                          });
                          Fluttertoast.showToast(
                              msg:
                                  "Sorry! Can't make an order without a service!",
                              toastLength: Toast.LENGTH_LONG);
                        } else {
                          var result = await createService();
                          if (result.status) {
                          _selectedItem.clear();
                            setState(() {
                              doLoading = false;
                            });
                            if (result.payment != null) {
                              beginPayment(result.payment!.amount!,
                                  result.payment!.transactionRef!);
                            }
                            // Fluttertoast.showToast(msg: "Successfully c")
                          } else {
                          _selectedItem.clear();
                            setState(() {
                              doLoading = false;
                            });
                            Flushbar(
                              message: result.errors?.first.toString(),
                              title: "Error",
                              duration: Duration(seconds: 4),
                            ).show(context);
                          }
                        }
                      } else {
                        Flushbar(
                          title: "Invalid details",
                          message: "Please fill in the information correctly",
                          duration: Duration(seconds: 10),
                        ).show(context);
                      }
                    },
                  )
          ],
        ),
      ),
    );
  }

  Future<Result> createService() async {
    Result result;
    CreateServiceDTO createdService =
        CreateServiceDTO(ids: _selectedItem, location: _location);
    result = await ApiService().createServiceOrderList(createdService);
    return result;
  }

  Widget loading = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      CircularProgressIndicator(),
      Text(" Processing ... Please wait")
    ],
  );

  Widget locationWidget() {
    Widget child = Column(
      children: [
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: response.setHeight(48.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    _location = value;
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
                  hintText: "Enter Location",
                  hintStyle: TextStyle(
                    fontSize: 14.0,
                    color: Color.fromRGBO(105, 108, 121, 0.7),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Location can't be empty";
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 20.0),
      ],
    );
    return child;
  }

  beginPayment(int amount, String transactionRef) async {
    final Flutterwave flutterwave = Flutterwave.forUIPayment(
      context: this.context,
      encryptionKey: this.encryptionKey!,
      publicKey: this.publicKey!,
      currency: this.currency,
      amount: amount.toString(),
      email: email,
      fullName: name,
      txRef: transactionRef,
      isDebugMode: true,
      phoneNumber: phone,
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
        final isSuccessful =
            checkPaymentIsSuccessful(response, amount, transactionRef);
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
          Fluttertoast.showToast(
              msg: "Successfully made payment", toastLength: Toast.LENGTH_LONG);
          // nextScreen(context, CheckOut());
          // awesomeSuccessDialog(context);
        } else {
          // check message
          print("Message: ${response.message}");
          // check status
          print("Status : ${response.status}");

          // check processor error
          print("Procesor error: ${response.data?.processorResponse}");
          Fluttertoast.showToast(
              msg: "Error occurred. Try again!",
              toastLength: Toast.LENGTH_LONG);
          // awesomeErrorDialog(context);
        }
      }
    } catch (error, stacktrace) {
      // handleError(error);
      print("Error: $error");
    }
  }

  bool checkPaymentIsSuccessful(
      final ChargeResponse response, int amount, String transactionRef) {
    return response.data?.status == FlutterwaveConstants.SUCCESSFUL &&
        response.data?.currency == this.currency &&
        response.data?.amount == amount.toString() &&
        response.data?.txRef == transactionRef;
  }

  AwesomeDialog awesomeSuccessDialog(BuildContext context) {
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
}
