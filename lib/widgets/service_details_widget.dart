import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/models/service_category.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:groceries_shopping_app/utils/helpers.dart';

class ServiceDetails extends StatefulWidget {
  ServiceDetails(
      {Key key, @required this.widgetTitle, @required this.subServices})
      : super(key: key);
  final String widgetTitle;
  final List<ServiceSubCategory> subServices;

  @override
  _ServiceDetailsState createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  bool selected = false;
  String _location;
  Map<ServiceSubCategory, bool> itemsMap;
  List<ServiceSubCategory> _selectedItem = [];

  @override
  void initState() {
    super.initState();
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
              child: Icon(Icons.arrow_back_ios,
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
            ListView.builder(
                shrinkWrap: true,
                itemCount: this.itemsMap.length,
                itemBuilder: (context, index) {
                  ServiceSubCategory item = this.itemsMap.keys.elementAt(index);
                  return CheckboxListTile(
                      title: Text(item.name),
                      subtitle: Text("KSh ${item.price}"),
                      value: item.value,
                      onChanged: (bool value) {
                        print("Value $value");
                        setState(() {
                          item.value = value;
                          if (item.value == true) {
                            _selectedItem.add(item);
                          } else {
                            _selectedItem.remove(item);
                          }
                        });
                        print("The selected items: $_selectedItem");
                      });
                }),
            locationWidget(),
            ElevatedButton(
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
              onPressed: () {
                // showSnackBar(context,
                //     "Your order has been received! Ordered items are\n${this._selectedItem.toString()}}");
              },
            )
          ],
        ),
      ),
    );
  }

  Widget locationWidget() {
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
                String returnMessage;
                if (value.isEmpty) {
                  returnMessage = "Location can't be empty";
                } else {
                  returnMessage = null;
                }
                return returnMessage;
              },
            ),
          ),
        ),
        SizedBox(height: 20.0),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Container(
        //     height: response.setHeight(48.0),
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(8.0),
        //     ),
        //     child: TextFormField(
        //       validator: (value) {
        //         String message;
        //         if (value.isEmpty) {
        //           message = "House number can't be null";
        //         } else {
        //           message = null;
        //         }
        //         return message;
        //       },
        //       onChanged: (value) {
        //         setState(() {
        //           _houseNumber = value;
        //           _houseNoEntered = true;
        //         });
        //       },
        //       decoration: InputDecoration(
        //         enabledBorder: OutlineInputBorder(
        //           borderSide: BorderSide(
        //             color: Color.fromRGBO(74, 77, 84, 0.2),
        //           ),
        //         ),
        //         focusedBorder: OutlineInputBorder(
        //           borderSide: BorderSide(
        //             color: AppTheme.mainOrangeColor,
        //           ),
        //         ),
        //         hintText: "Enter your House Number",
        //         hintStyle: TextStyle(
        //           fontSize: 14.0,
        //           color: Color.fromRGBO(105, 108, 121, 0.7),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // Visibility(
        //     visible: (_houseNoEntered && _apartmentNameEntered),
        //     child: Text(
        //       'Apartment: $_apartmentName, House No.: $_houseNumber',
        //       style: TextStyle(fontSize: 19.0),
        //     )),
      ],
    );
    return child;
  }
}
