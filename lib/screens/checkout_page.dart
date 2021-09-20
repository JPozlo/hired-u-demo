import 'dart:collection';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/models/product.dart';
import 'package:groceries_shopping_app/providers/product_provider.dart';
import 'package:groceries_shopping_app/providers/providers.dart';
import 'package:groceries_shopping_app/screens/checkout_screen.dart';
import 'package:groceries_shopping_app/screens/create_location.dart';
import 'package:groceries_shopping_app/screens/credit_card_payment.dart';
import 'package:groceries_shopping_app/screens/credit_cards.dart';
import 'package:groceries_shopping_app/screens/home.dart';
import 'package:groceries_shopping_app/screens/mpesa_payment.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:groceries_shopping_app/screens/pages.dart';
import 'package:groceries_shopping_app/services/api/api_service.dart';
import 'package:groceries_shopping_app/utils/custom_text_style.dart';
import 'package:groceries_shopping_app/utils/helpers.dart';
import 'package:groceries_shopping_app/utils/payment_method_options.dart';
import 'package:groceries_shopping_app/utils/payment_method_options.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key key, @required this.cartProductsProvider})
      : super(key: key);
  final UnmodifiableListView<Product> cartProductsProvider;

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  String defaultAddress = "Commerce House, Masai Lodge, Rongai";
  UserAddress _selectedAddress;

  int _userAddressId = 1;

  bool _value = false;
  // int val = -1;
  PaymentMethodOptions val = PaymentMethodOptions.MPESA;
  double _totalPrice;
  double _deliveryPrice = 120.0;
  double _taxPrice = 30.0;
  double _orderTotal = 0.0;
  double _totalOverallCharge = 0.0;
  List<Product> _orderProducts;
  List<OrderItem> _orderItems = [];
  UserAddress defaultValueAddress;

  @override
  void initState() {
    super.initState();
    defaultValueAddress = UserAddress(
        id: 0,
        country: "Kenya",
        county: "Nairobi",
        homeTown: "Nairobi",
        streetAddress: "Masai Lodge",
        building: "Viewtower",
        suite: "7j33j3n");
    // defaultAddress = ApiService().fetchAddressesList()[0];
    print("Default value address: ${defaultValueAddress.toString()}");
    _orderProducts =
        Provider.of<ProductsOperationsController>(context, listen: false).cart;
    _totalPrice =
        Provider.of<ProductsOperationsController>(context, listen: false)
            .totalCost;
    _orderTotal = _totalPrice + _taxPrice;
    _totalOverallCharge = _orderTotal + _deliveryPrice;
    for (int i = 0; i < _orderProducts.length; i++) {
      var current = _orderProducts[i];
      OrderItem orderItem =
          OrderItem(id: current.id, quantity: current.orderedQuantity);
      print("Order item hit: ${orderItem.toString()}");
      _orderItems.add(orderItem);
    }
    print("The Total Price is $_totalPrice");
    print("The Tax is $_taxPrice");
    print("The Order Total is $_orderTotal");
    print("The Delivery Charges is $_deliveryPrice");
    print("The Total is $_totalOverallCharge");
    // Future.delayed(Duration.zero, () {
    //    Provider.of<AddressProvider>(context, listen: false).userAddress =
    // });
  }

  @override
  Widget build(BuildContext context) {
    var productsProvider = Provider.of<ProductsOperationsController>(context);
    var addressProvider = Provider.of<AddressProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Builder(builder: (context) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Hero(
                      tag: 'backarrow',
                      child: GestureDetector(
                        onTap: () {
                          // Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                          // Navigator.pushAndRemoveUntil(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => HomeScreen()),
                          //     (route) => false);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          size: response.setHeight(23),
                        ),
                      ),
                    ),
                    Spacer(flex: 5),
                    Text(
                      "Confirm Order",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: response.setFontSize(18),
                      ),
                    ),
                    Spacer(flex: 5),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: ListView(
                    children: <Widget>[
                      selectedAddressSection(
                          addressProvider.userAddress == null ||
                                  addressProvider.userAddress.suite == null
                              ? defaultValueAddress
                              : addressProvider.userAddress),
                      priceSection(
                          totalPrice: _totalPrice,
                          taxPrice: _taxPrice,
                          totalOverall: _totalOverallCharge,
                          deliveryCharge: _deliveryPrice)
                    ],
                  ),
                ),
                flex: 90,
              ),
              productsProvider.createOrderStatus ==
                      ProductStatus.CreatingProduct
                  ? loading
                  : Expanded(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: ElevatedButton(
                    onPressed: () async {
                      // confirmOrder(context, productsProvider);
                        Result result;

                      // var productProvider = Provider.of<ProductsOperationsController>(context, listen: false);

                      CreateProductOrderDTO createdService =
                          CreateProductOrderDTO(
                              userAddressesId: _userAddressId,
                              items: _orderItems);

                      result =
                          await productsProvider.createProductOrderList(createdService);
                      if (result.status) {
                        // productsProvider.clearCart();
                        if (result.payment != null) {
                          nextScreen(
                              context,
                              CheckOut(
                                id: result.payment.id,
                              ));
                        } else {
                          nextScreen(context, CheckOut());
                        }
                      } else {
                        Flushbar(
                          message: result.errors.first.toString(),
                          title: "Error",
                          duration: Duration(seconds: 4),
                        ).show(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppTheme.mainBlueColor,
                      textStyle: TextStyle(color: Colors.black),
                    ),
                    child: Text(
                            "Confirm Order",
                            style: CustomTextStyle.textFormFieldMedium.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                flex: 10,
              )
            ],
          );
        }),
      ),
    );
  }

  var loading = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      CircularProgressIndicator(),
      Text(" Processing ... Please wait")
    ],
  );

  confirmOrder(BuildContext context, ProductsOperationsController provider) async {
    print("Orderitems length: ${_orderItems.length}");
    Result result;

    // var productProvider = Provider.of<ProductsOperationsController>(context, listen: false);

    CreateProductOrderDTO createdService = CreateProductOrderDTO(
        userAddressesId: _userAddressId, items: _orderItems);

    result = await provider.createProductOrderList(createdService);

    if (result.status) {
      provider.clearCart();
      if (result.payment != null) {
        nextScreen(
            context,
            CheckOut(
              id: result.payment.id,
            ));
      } else {
        nextScreen(context, CheckOut());
      }
    } else {
      Flushbar(
        message: result.errors.first.toString(),
        title: "Error",
        duration: Duration(seconds: 4),
      ).show(context);
    }
  }

  // showPaymentModalSheet(BuildContext context) {
  //   return showModalBottomSheet(
  //       context: context,
  //       builder: (context) {
  //         return Container(
  //           height: 130,
  //           decoration: BoxDecoration(
  //               color: Colors.white,
  //               border: Border.all(color: Colors.grey.shade200, width: 2),
  //               borderRadius: BorderRadius.only(
  //                   topRight: Radius.circular(16),
  //                   topLeft: Radius.circular(16))),
  //           child: Column(
  //             children: [
  //               Container(
  //                 margin: EdgeInsets.only(left: 16, right: 16),
  //                 child: ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                     primary: AppTheme.mainBlueColor,
  //                     padding: EdgeInsets.only(left: 48, right: 48),
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.all(Radius.circular(13))),
  //                   ),
  //                   onPressed: () {
  //                     Widget selectedPaymentOption = MpesaPayment();
  //                     if (val == PaymentMethodOptions.MPESA) {
  //                       selectedPaymentOption = MpesaPayment();
  //                     } else if (val == PaymentMethodOptions.CARD) {
  //                       selectedPaymentOption = PayWithCreditCardPage();
  //                     }
  //                     Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                                 builder: (context) => selectedPaymentOption))
  //                         .then((value) => Navigator.pop(context));
  //                   },
  //                   child: Text(
  //                     "Pay Now",
  //                     style: CustomTextStyle.textFormFieldMedium
  //                         .copyWith(color: Colors.black),
  //                   ),
  //                 ),
  //               ),
  //               Spacer(),
  //               Container(
  //                 margin: EdgeInsets.only(left: 16, right: 16, bottom: 10),
  //                 child: ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                     primary: AppTheme.mainOrangeColor,
  //                     padding: EdgeInsets.only(left: 48, right: 48),
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.all(Radius.circular(13))),
  //                   ),
  //                   onPressed: () {
  //                     // Send order info to API
  //                     Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                                 builder: (context) => CheckOut()))
  //                         .then((value) => Navigator.pop(context));
  //                   },
  //                   child: Text(
  //                     "Pay Later",
  //                     style: CustomTextStyle.textFormFieldMedium
  //                         .copyWith(color: Colors.black),
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //         );
  //       });
  // }

  showThankYouBottomSheet(BuildContext context) {
    return _scaffoldKey.currentState.showBottomSheet((context) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200, width: 2),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image(
                    image: AssetImage("assets/avatar.png"),
                    width: 300,
                  ),
                ),
              ),
              flex: 5,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: <Widget>[
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                            text:
                                "\n\nThank you for your purchase. Our company values each and every customer. We strive to provide state-of-the-art devices that respond to our clients’ individual needs. If you have any questions or feedback, please don’t hesitate to reach out.",
                            style: CustomTextStyle.textFormFieldMedium.copyWith(
                                fontSize: 14, color: Colors.grey.shade800),
                          )
                        ])),
                    SizedBox(
                      height: 24,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppTheme.mainOrangeColor,
                        padding: EdgeInsets.only(left: 48, right: 48),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Track Order",
                        style: CustomTextStyle.textFormFieldMedium
                            .copyWith(color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
              flex: 5,
            )
          ],
        ),
      );
    },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        backgroundColor: Colors.white,
        elevation: 2);
  }

  showMpesaOrCardOption() {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: Colors.grey.shade200)),
          padding: EdgeInsets.only(left: 12, top: 8, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Choose a Payment Option",
                style: CustomTextStyle.textFormFieldMedium.copyWith(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: Text("M-Pesa"),
                leading: Radio<PaymentMethodOptions>(
                  value: PaymentMethodOptions.MPESA,
                  groupValue: val,
                  onChanged: (PaymentMethodOptions value) {
                    setState(() {
                      val = value;
                    });
                  },
                  activeColor: AppTheme.mainOrangeColor,
                ),
              ),
              ListTile(
                title: Text("Credit Card"),
                leading: Radio<PaymentMethodOptions>(
                  value: PaymentMethodOptions.CARD,
                  groupValue: val,
                  onChanged: (PaymentMethodOptions value) {
                    setState(() {
                      val = value;
                    });
                  },
                  activeColor: AppTheme.mainOrangeColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  creditCardOptionButton() {
    return Expanded(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => PayWithCreditCardPage()));
          },
          child: Text(
            "Credit Card",
            style: CustomTextStyle.textFormFieldMedium.copyWith(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          color: AppTheme.mainOrangeColor,
          textColor: Colors.black,
        ),
      ),
      flex: 10,
    );
  }

  showMpesaOption() {
    return Expanded(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: RaisedButton(
          onPressed: () {
            /*Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) => OrderPlacePage()));*/
            showThankYouBottomSheet(context);
          },
          child: Text(
            "Credit Card",
            style: CustomTextStyle.textFormFieldMedium.copyWith(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          color: AppTheme.mainOrangeColor,
          textColor: Colors.black,
        ),
      ),
      flex: 10,
    );
  }

  selectedAddressSection(UserAddress userAddress) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: Colors.grey.shade200)),
          padding: EdgeInsets.only(left: 12, top: 8, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Container(
                  //   padding:
                  //       EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                  //   decoration: BoxDecoration(
                  //       shape: BoxShape.rectangle,
                  //       color: Colors.grey.shade300,
                  //       borderRadius: BorderRadius.all(Radius.circular(16))),
                  //   child: Text(
                  //     "HOME",
                  //     style: CustomTextStyle.textFormFieldBlack.copyWith(
                  //         color: Colors.indigoAccent.shade200, fontSize: 8),
                  //   ),
                  // )
                ],
              ),
              createAddressText(userAddress.country, 16, 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  createAddressText("County: " + userAddress.county, 16, 15),
                  // SizedBox(width: 20),
                  Spacer(),
                  createAddressText("Town: " + userAddress.homeTown, 16, 15),
                ],
              ),
              createAddressText(userAddress.streetAddress, 6, 15),
              createAddressText(userAddress.building, 6, 15),
              // createAddressText(userAddress.suite, 6),
              SizedBox(
                height: 6,
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Suite: ",
                      style: CustomTextStyle.textFormFieldMedium
                          .copyWith(fontSize: 15, color: Colors.grey.shade800)),
                  TextSpan(
                      text: userAddress.suite,
                      style: CustomTextStyle.textFormFieldBold
                          .copyWith(color: Colors.black, fontSize: 15)),
                ]),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                color: Colors.grey.shade300,
                height: 1,
                width: double.infinity,
              ),
              addressAction()
            ],
          ),
        ),
      ),
    );
  }

  createAddressText(String strAddress, double topMargin, double fontsize) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      child: Text(
        strAddress,
        style: CustomTextStyle.textFormFieldMedium
            .copyWith(fontSize: fontsize, color: Colors.grey.shade800),
      ),
    );
  }

  addressAction() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Spacer(
          //   flex: 2,
          // ),
          Center(
            child: TextButton(
              onPressed: () async {
                UserAddress selectedAddress = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChooseAddressPage()));

                if (selectedAddress != null) {
                  setState(() {
                    _selectedAddress = selectedAddress;
                    defaultValueAddress = selectedAddress;
                  });
                  print("Orderitems: ${_orderItems.toString()}");
                  print("selctedaddress: ${_selectedAddress.toString()}");
                }
              },
              child: Text(
                "Choose Another Address",
                style: CustomTextStyle.textFormFieldSemiBold
                    .copyWith(fontSize: 12, color: Colors.indigo.shade700),
              ),
            ),
          ),
          // Spacer(
          //   flex: 3,
          // ),
          // Container(
          //   height: 20,
          //   width: 1,
          //   color: Colors.grey,
          // ),
          // Spacer(
          //   flex: 3,
          // ),
          // FlatButton(
          //   onPressed: () {},
          //   child: Text("Add New Address",
          //       style: CustomTextStyle.textFormFieldSemiBold
          //           .copyWith(fontSize: 12, color: Colors.indigo.shade700)),
          //   splashColor: Colors.transparent,
          //   highlightColor: Colors.transparent,
          // ),
          // Spacer(
          //   flex: 2,
          // ),
        ],
      ),
    );
  }

  standardDelivery() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border:
              Border.all(color: Colors.tealAccent.withOpacity(0.4), width: 1),
          color: Colors.tealAccent.withOpacity(0.2)),
      margin: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Radio(
            value: 1,
            groupValue: 1,
            onChanged: (isChecked) {},
            activeColor: Colors.tealAccent.shade400,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Standard Delivery",
                style: CustomTextStyle.textFormFieldMedium.copyWith(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Get it by 20 jul - 27 jul | Free Delivery",
                style: CustomTextStyle.textFormFieldMedium.copyWith(
                  color: Colors.black,
                  fontSize: 12,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  checkoutItem() {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: Colors.grey.shade200)),
          padding: EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
          child: ListView.builder(
            itemBuilder: (context, position) {
              return checkoutListItem();
            },
            itemCount: 3,
            shrinkWrap: true,
            primary: false,
            scrollDirection: Axis.vertical,
          ),
        ),
      ),
    );
  }

  checkoutListItem() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Container(
            child: Image(
              image: AssetImage(
                "assets/avatar.png",
              ),
              width: 35,
              height: 45,
              fit: BoxFit.fitHeight,
            ),
            decoration:
                BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
          ),
          SizedBox(
            width: 8,
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: "Estimated Delivery : ",
                  style: CustomTextStyle.textFormFieldMedium
                      .copyWith(fontSize: 12)),
              TextSpan(
                  text: "21 Jul 2019 ",
                  style: CustomTextStyle.textFormFieldMedium
                      .copyWith(fontSize: 12, fontWeight: FontWeight.w600))
            ]),
          )
        ],
      ),
    );
  }

  priceSection(
      {double totalPrice,
      double taxPrice,
      double orderTotal,
      double deliveryCharge,
      double totalOverall}) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: Colors.grey.shade200)),
          padding: EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Price Details",
                    style: CustomTextStyle.textFormFieldMedium.copyWith(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                width: double.infinity,
                height: 0.5,
                margin: EdgeInsets.symmetric(vertical: 4),
                color: Colors.grey.shade400,
              ),
              SizedBox(
                height: 8,
              ),
              createPriceItem(
                  "Total Price", "KSh $totalPrice", Colors.grey.shade700),
              // createPriceItem("Bag discount", getFormattedCurrency(3280),
              //     Colors.teal.shade300),
              createPriceItem("Tax", "KSh $taxPrice", Colors.grey.shade700),
              // createPriceItem("Order Total", getFormattedCurrency(orderTotal),
              //     Colors.grey.shade700),
              createPriceItem("Delivery Charges", "KSh $deliveryCharge",
                  Colors.teal.shade300),
              SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                height: 0.5,
                margin: EdgeInsets.symmetric(vertical: 4),
                color: Colors.grey.shade400,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Total",
                    style: CustomTextStyle.textFormFieldSemiBold
                        .copyWith(color: Colors.black, fontSize: 12),
                  ),
                  Text(
                    "KSh $totalOverall",
                    style: CustomTextStyle.textFormFieldMedium
                        .copyWith(color: Colors.black, fontSize: 12),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  createPriceItem(String key, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            key,
            style: CustomTextStyle.textFormFieldMedium
                .copyWith(color: Colors.grey.shade700, fontSize: 12),
          ),
          Text(
            value,
            style: CustomTextStyle.textFormFieldMedium
                .copyWith(color: color, fontSize: 12),
          )
        ],
      ),
    );
  }
}
