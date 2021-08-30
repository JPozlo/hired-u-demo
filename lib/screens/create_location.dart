import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screen_util.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:groceries_shopping_app/services/place_service.dart';
import 'package:groceries_shopping_app/utils/custom_text_style.dart';
import 'package:groceries_shopping_app/widgets/address_search.dart';

class CreateLocationPage extends StatefulWidget {
  const CreateLocationPage({Key key}) : super(key: key);

  @override
  _CreateLocationPageState createState() => _CreateLocationPageState();
}

class _CreateLocationPageState extends State<CreateLocationPage> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _street = '';
  String _city = '';
  String _houseNumber = '';
  String _apartmentName = '';
  String _specifics = "";
  String _location = "";
  String _phone = "";

  bool _locationEntered = false;
  bool _apartmentNameEntered = false;
  bool _houseNoEntered = false;

  bool _disableButton = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _topBarUI(),
            SizedBox(height: 16.0),
            locationWidgets(),
            apartmentAndHouseNumberWidgets(),
            SizedBox(height: 20.0),
            phoneWidget(),
            Spacer(
              flex: 2,
            ),
            buttonWidget(),
            Spacer()
          ],
        ),
      ),
    ));
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
            "Enter Delivery Address",
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

  Widget locationWidgets() {
    Widget child = Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: response.setHeight(48.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextFormField(
            readOnly: true,
            controller: _controller,
            onTap: () async {
              // generate a new token here
              // final sessionToken = "892jdjdn";
              // final Suggestion result = await showSearch(
              //   context: context,
              //   delegate: AddressSearch(sessionToken),
              // );
              // // This will change the text displayed in the TextField
              // if (result != null) {
              //   final placeDetails = await PlaceApiProvider(sessionToken)
              //       .getPlaceDetailFromId(result.placeId);
              //   setState(() {
              //     _controller.text = result.description;
              //     _street = placeDetails.street;
              //     _city = placeDetails.city;
              //     _locationEntered = true;
              //   });
              // }
              showSnackBar(context, "Feature will be implemented soon!");
            },
            // with some styling
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(74, 77, 84, 0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppTheme.mainOrangeyColor,
                ),
              ),
              hintText: "Enter your location here",
              hintStyle: TextStyle(
                fontSize: 14.0,
                color: Color.fromRGBO(105, 108, 121, 0.7),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 8.0, top: 16.0),
            ),
          ),
        ),
      ),
      SizedBox(height: 10.0),
      // Text('Street Number: $_streetNumber'),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Visibility(
          visible: _locationEntered,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Street: $_street',
                style: TextStyle(fontSize: 19.0),
              ),
              Text(
                'City: $_city',
                style: TextStyle(fontSize: 19.0),
              ),
            ],
          ),
        ),
      ),
    ]);
    return child;
  }

  Widget apartmentAndHouseNumberWidgets() {
    Widget child = Column(
      children: [
        Padding(
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
                  _apartmentName = value;
                  _apartmentNameEntered = true;
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
                    color: AppTheme.mainOrangeyColor,
                  ),
                ),
                hintText: "Enter your Apartment Name",
                hintStyle: TextStyle(
                  fontSize: 14.0,
                  color: Color.fromRGBO(105, 108, 121, 0.7),
                ),
              ),
              validator: (value) {
                String returnMessage;
                if (value.isEmpty) {
                  returnMessage = "Apartment name can't be empty";
                } else {
                  returnMessage = null;
                }
                return returnMessage;
              },
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: response.setHeight(48.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextFormField(
              validator: (value){
                    String message;
                if (value.isEmpty) {
                  message = "House number can't be null";
                } else {
                  message = null;
                }
                return message;
              },
              onChanged: (value) {
                setState(() {
                  _houseNumber = value;
                  _houseNoEntered = true;
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
                    color: AppTheme.mainOrangeyColor,
                  ),
                ),
                hintText: "Enter your House Number",
                hintStyle: TextStyle(
                  fontSize: 14.0,
                  color: Color.fromRGBO(105, 108, 121, 0.7),
                ),
              ),
            ),
          ),
        ),
        Visibility(
            visible: (_houseNoEntered && _apartmentNameEntered),
            child: Text(
              'Apartment: $_apartmentName, House No.: $_houseNumber',
              style: TextStyle(fontSize: 19.0),
            )),
      ],
    );
    return child;
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
            message = "Mobile number can't be null";
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
              color: AppTheme.mainOrangeyColor,
            ),
          ),
          hintText: "Enter Mobile Number ",
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
            showSnackBar(context, "Details successfully saved!");
          } else {
            showSnackBar(context, "Some details missing!");
          }
        },
        style: ElevatedButton.styleFrom(
          primary: AppTheme.mainOrangeColor,
          textStyle: TextStyle(color: Colors.black),
        ),
        child: Text(
          "Update Address",
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
