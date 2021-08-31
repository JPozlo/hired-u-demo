import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/models/service_category.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:groceries_shopping_app/widgets/service_details_widget.dart';

class ServiceWidget extends StatelessWidget {
  const ServiceWidget(
      {Key key, @required this.widgetTitle, @required this.serviceCategories})
      : super(key: key);

  final String widgetTitle;
  final List<ServiceCategory> serviceCategories;

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
              // setState(() => opacity = 0);
              Navigator.pop(context);
            }),
        title: Text(
          this.widgetTitle,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: this.serviceCategories.length,
          itemBuilder: (context, index) {
            var currentItem = this.serviceCategories[index];
            return ListTile(
                title: Text(currentItem.name),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ServiceDetails(widgetTitle: currentItem.name, subServices: currentItem.subServices,)));
                });
          }),
    );
  }
}
