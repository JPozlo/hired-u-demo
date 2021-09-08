import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/models/service_category.dart';
import 'package:groceries_shopping_app/screens/grocery_home.dart';
import 'package:groceries_shopping_app/screens/home.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:groceries_shopping_app/providers/service_provider.dart';
import 'package:groceries_shopping_app/utils/service_utils.dart';
import 'package:groceries_shopping_app/widgets/details_page_transition.dart';
import 'package:groceries_shopping_app/widgets/service_widget.dart';
import 'package:provider/provider.dart';

class ServiceCard extends StatelessWidget {
  ServiceCard({@required this.index, @required this.serviceName});
  final int index;
  final String serviceName;

  @override
  Widget build(BuildContext context) {

    List<ServiceCategory> _maidServiceCategories = maidCategories;
    List<ServiceCategory> _mechanicServiceCategories = mechanicCategories;
    List<ServiceCategory> _carpenterServiceCategories = carpenterCategories;
    List<ServiceCategory> _electricianServiceCategories = electricianCategories;

    Widget serviceDetails = HomeScreen();

    switch (serviceName) {
      case 'Grocery':
        serviceDetails = HomeScreen();
        break;
      case 'Taxi':
        serviceDetails = HomeScreen();
        break;
      case 'Electrician':
        serviceDetails = ServiceWidget(
            widgetTitle: "Elecrician",
            serviceCategories: _electricianServiceCategories);
        break;
      case 'Carpenter':
        serviceDetails = ServiceWidget(
            widgetTitle: "Carpenter",
            serviceCategories: _carpenterServiceCategories);
        break;
      case 'Technician':
        serviceDetails = ServiceWidget(
            widgetTitle: "Technician",
            serviceCategories: _mechanicServiceCategories);
        break;
      case 'Maids':
        serviceDetails = ServiceWidget(
            widgetTitle: "Maids", serviceCategories: _maidServiceCategories);
        break;
      default:
        serviceDetails = HomeScreen();
    }
  
      var servicesOffered =
          Provider.of<ServiceProvider>(context).servicesOffered;

    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          // if(serviceName == "Grocery"){
          //     Navigator.of(context).push(MaterialPageRoute(
          //       builder: (context) => serviceDetails,
          //       settings: RouteSettings(name: "GroceryProducts")));
          // } else{
          // Navigator.push(context, DetailsPageRoute(route: serviceDetails));
          // }
          Navigator.push(context, DetailsPageRoute(route: serviceDetails));
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          height: response.setHeight(105),
          width: response.setWidth(100),
          decoration: BoxDecoration(
              color: AppTheme.mainBlueColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 10, spreadRadius: 0.8)
              ]),
          child: Padding(
            padding: EdgeInsets.only(
              left: response.setWidth(15),
              right: response.setWidth(15),
              top: response.setWidth(20),
              bottom: response.setWidth(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //2.4
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Hero(
                    tag: '${servicesOffered[index].picPath}-path',
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        servicesOffered[index].picPath,
                        scale: 0.2,
                        // fit: BoxFit.fill,
                        height: 50,
                        width: 50,
                        color: AppTheme.mainOrangeColor,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        servicesOffered[index].name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: response.setFontSize(15),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
