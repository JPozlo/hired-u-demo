import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/screens/grocery_home.dart';
import 'package:groceries_shopping_app/screens/home.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:groceries_shopping_app/service_provider.dart';
import 'package:groceries_shopping_app/widgets/details_page_transition.dart';
import 'package:provider/provider.dart';

class ServiceCard extends StatelessWidget {
  ServiceCard({@required this.index, @required this.serviceName});
  final int index;
  final String serviceName;
  @override
  Widget build(BuildContext context) {
    Widget serviceDetails = HomeScreen();
    if(serviceName == "Grocery"){
      serviceDetails = HomeScreen();
    }
    var servicesOffered =
        Provider.of<ServiceProvider>(context).servicesOffered;
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              DetailsPageRoute(route: serviceDetails));
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          height: response.setHeight(105),
          width: response.setWidth(100),
          decoration: BoxDecoration(
              color: AppTheme.mainCardBackgroundColor,
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
                        color: AppTheme.mainOrangeyColor,     
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
                          color: AppTheme.mainScaffoldBackgroundColor,
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
