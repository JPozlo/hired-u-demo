import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:groceries_shopping_app/models/service.dart';

class ServiceProvider extends ChangeNotifier{
    List<Service> _servicesOffered = [
    Service(
        name: 'Grocery',
        picPath: 'assets/grocery.png',),
    Service(
        name: 'Taxi',
        picPath: 'assets/car.png',),
    Service(
        name: 'Electrician',
        picPath: 'assets/electrician.png',),
    Service(
        name: 'Carpenter',
        picPath: 'assets/carpenter.png',),
    Service(
        name: 'Mechanic',
        picPath: 'assets/mechanic.png',),
    Service(
        name: 'Painting',
        picPath: 'assets/paint.png',),
  ];

  UnmodifiableListView<Service> get servicesOffered {
    return UnmodifiableListView(_servicesOffered);
  }

}