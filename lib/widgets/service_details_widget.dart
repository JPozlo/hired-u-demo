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
                itemCount: this.widget.subServices.length,
                itemBuilder: (context, index) {
                  var currentItem = this.widget.subServices[index];
                  return Card(
                    shape: selected
                        ? new RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(4.0))
                        : new RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(4.0)),
                    child: Row(
                      children: [
                        new Padding(
                          padding: new EdgeInsets.all(8.0),
                          child: new Text(currentItem.name,
                              style: const TextStyle(
                                  fontSize: 15.0, fontFamily: 'Poppins')),
                        ),
                        new Padding(
                          padding: new EdgeInsets.all(8.0),
                          child: new Text(
                              getFormattedCurrency(currentItem.price),
                              style: const TextStyle(
                                  fontSize: 15.0, fontFamily: 'Poppins')),
                        ),
                        new Checkbox(
                            value: selected,
                            onChanged: (value) {
                              setState(() {
                                selected = !selected;
                              });
                            })
                      ],
                    ),
                  );
                }),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: AppTheme.mainOrangeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(8),
                child: const Text(
                  'Make Order',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              onPressed: () {
                showSnackBar(context, "Your order has been received!");
              },
            )
          ],
        ),
      ),
    );
  }
}
