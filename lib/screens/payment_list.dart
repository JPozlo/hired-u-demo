import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/screens/pages.dart';
import 'package:groceries_shopping_app/services/api/api_service.dart';
import 'package:groceries_shopping_app/utils/helpers.dart';
import 'package:groceries_shopping_app/utils/utils.dart';

class PaymentList extends StatefulWidget {
  const PaymentList({Key key}) : super(key: key);

  @override
  _PaymentListState createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  List<Payment> _userAddresses = [];
  Future<Result> _paymentsListFuture;

  List<Payment> tempPaymentsList = [
    Payment(
      id: 0,
      amount: 9029,
      serviceOrdersId: 3,
      updatedAt: "2021/03/12",
      createdAt: "2021/02/01"
    ),
    Payment(
      id: 0,
      amount: 9029,
      serviceOrdersId: 3,
      updatedAt: "2021/03/12",
      createdAt: "2021/02/01"
    ),
    Payment(
      id: 0,
      amount: 9029,
      serviceOrdersId: 3,
      updatedAt: "2021/03/12",
      createdAt: "2021/02/01"
    ),
    Payment(
      id: 0,
      amount: 9029,
      serviceOrdersId: 3,
      updatedAt: "2021/03/12",
      createdAt: "2021/02/01"
    ),
    Payment(
      id: 0,
      amount: 9029,
      serviceOrdersId: 3,
      updatedAt: "2021/03/12",
      createdAt: "2021/02/01"
    ),
    Payment(
      id: 0,
      amount: 9029,
      serviceOrdersId: 3,
      updatedAt: "2021/03/12",
      createdAt: "2021/02/01"
    ),
    Payment(
      id: 0,
      amount: 9029,
      serviceOrdersId: 3,
      updatedAt: "2021/03/12",
      createdAt: "2021/02/01"
    ),
  ];

  @override
  void initState() {
    super.initState();
    // _paymentsListFuture = ApiService().fetchPaymentsList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                            nextScreen(context, ProfileScreen());
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: response.setHeight(23),
                          ),
                        ),
                      ),
                      Spacer(flex: 5),
                      Text(
                        "Your Payments",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: response.setFontSize(18),
                        ),
                      ),
                      Spacer(flex: 5),
                    ],
                  ),
                ),
                mainDisplayWidget(tempPaymentsList),
                // FutureBuilder(
                //   future: _addressesListFuture,
                //   builder: (context, AsyncSnapshot<Result> snapshot) {
                //     Widget defaultWidget;
                //     switch (snapshot.connectionState) {
                //       case ConnectionState.done:
                //         if (snapshot.hasData && snapshot.data != null) {
                //           if (snapshot.data.addresses.length > 0) {
                //             defaultWidget =
                //                 mainDisplayWidget(snapshot.data.addresses);
                //           } else {
                //             defaultWidget = errorWidget();
                //           }
                //         } else {
                //           defaultWidget = errorWidget();
                //         }
                //         break;
                //       case ConnectionState.none:
                //         defaultWidget = loading();
                //         break;
                //       case ConnectionState.waiting:
                //         defaultWidget = loading();
                //         break;
                //       default:
                //         defaultWidget = loading();
                //         break;
                //     }
                //     return defaultWidget;
                //   },
                // )
              ],
            );
          }),
        ),
  
      ),
    );
  }

  Widget loading() {
    return Center(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text(" Loading ... Please wait")
          ],
        ),
      ),
    );
  }

  Widget errorWidget() {
    return Center(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No addresses found!",
              style: TextStyle(fontSize: 23),
            )
          ],
        ),
      ),
    );
  }

  Widget mainDisplayWidget(List<Payment> paymentsList) {
    return Expanded(
      child: Container(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: paymentsList.length,
              itemBuilder: (context, index) {
                var currentItem = paymentsList[index];
                return ListTile(
                  title: Text("KSh " + currentItem.amount.toString()),
                  subtitle: Text("#" + currentItem.id.toString()),
                  trailing: Text(currentItem.createdAt),
                );
              })),
      flex: 90,
    );
  }

  singleAddressWidget(UserAddress userAddress) {
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

  // addressAction() {
  //   return Container(
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         // Spacer(
  //         //   flex: 2,
  //         // ),
  //         Center(
  //           child: TextButton(
  //             onPressed: () {
  //               next
  //             },
  //             child: Text(
  //               "Change",
  //               style: CustomTextStyle.textFormFieldSemiBold
  //                   .copyWith(fontSize: 12, color: Colors.indigo.shade700),
  //             ),
  //           ),
  //         ),
  //         // Spacer(
  //         //   flex: 3,
  //         // ),
  //         // Container(
  //         //   height: 20,
  //         //   width: 1,
  //         //   color: Colors.grey,
  //         // ),
  //         // Spacer(
  //         //   flex: 3,
  //         // ),
  //         // FlatButton(
  //         //   onPressed: () {},
  //         //   child: Text("Add New Address",
  //         //       style: CustomTextStyle.textFormFieldSemiBold
  //         //           .copyWith(fontSize: 12, color: Colors.indigo.shade700)),
  //         //   splashColor: Colors.transparent,
  //         //   highlightColor: Colors.transparent,
  //         // ),
  //         // Spacer(
  //         //   flex: 2,
  //         // ),
  //       ],
  //     ),
  //   );
  // }
}
