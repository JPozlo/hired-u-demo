import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/screens/checkout_screen.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:groceries_shopping_app/services/api/api_service.dart';
import 'package:groceries_shopping_app/utils/helpers.dart';

class ServiceDetails extends StatefulWidget {
  ServiceDetails(
      {Key key, @required this.widgetTitle, @required this.subServices})
      : super(key: key);
  final String widgetTitle;
  final List<MiniService> subServices;

  @override
  _ServiceDetailsState createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  bool selected = false;
  String _location;
  bool doLoading = false;
  Map<MiniService, bool> itemsMap;
  List<int> _selectedItem = [];

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

            this.itemsMap == null || this.itemsMap.length < 1 ?
            Text("No services available under this category yet!", style: TextStyle(fontSize: 17),) :
            ListView.builder(
                shrinkWrap: true,
                itemCount: this.itemsMap.length,
                itemBuilder: (context, index) {
                  MiniService item = this.itemsMap.keys.elementAt(index);
                  return CheckboxListTile(
                      title: Text(item.name),
                      subtitle: Text("KSh ${item.price}"),
                      value: item.isChecked,
                      onChanged: (bool value) {
                        print("Value $value");
                        setState(() {
                          item.isChecked = value;
                          if (item.isChecked == true) {
                            _selectedItem.add(item.id);
                          } else {
                            _selectedItem.remove(item.id);
                          }
                        });
                        print("The selected items: $_selectedItem");
                      });
                }),
            SizedBox(height: 12,),
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
                      setState(() {
                        doLoading = true;
                      });
                      var result = await createService();
                      if (result.status) {
                        setState(() {
                          doLoading = false;
                        });
                        if(result.payment != null){
                        nextScreen(context, CheckOut(id: result.payment.id));

                        }
                        // Fluttertoast.showToast(msg: "Successfully c")
                      } else {
                              setState(() {
                          doLoading = false;
                        });
                        Flushbar(
                          message: result.errors.first.toString(),
                          title: "Error",
                          duration: Duration(seconds: 4),
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
