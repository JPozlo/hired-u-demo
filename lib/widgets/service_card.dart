import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/screens/home.dart';
import 'package:groceries_shopping_app/providers/service_provider.dart';
import 'package:groceries_shopping_app/widgets/details_page_transition.dart';
import 'package:groceries_shopping_app/widgets/service_widget.dart';
import 'package:provider/provider.dart';

class ServiceCard extends StatelessWidget {
  ServiceCard({@required this.index, @required this.service});
  final int index;
  // final String serviceName;
  final Service service;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget serviceDetails = HomeScreen();

    if (service.name == "Grocery") {
      serviceDetails = HomeScreen();
    } else if (service.name == "Taxi") {
      serviceDetails = HomeScreen();
    } else {
      serviceDetails = ServiceWidget(
        service: this.service,
      );
    }

    var servicesOffered = Provider.of<ServiceProvider>(context).servicesOffered;

    return GestureDetector(
      onTap: () {
        Navigator.push(context, DetailsPageRoute(route: serviceDetails));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        decoration: BoxDecoration(
            color: AppTheme.mainBlueColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 10, spreadRadius: 0.8)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Hero(
                  tag: '${servicesOffered[index].picPath}-path',
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      servicesOffered[index].picPath,
                      height: 50,
                      width: 50,
                      color: AppTheme.mainOrangeColor,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      servicesOffered[index].name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
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
    );
  }
}
