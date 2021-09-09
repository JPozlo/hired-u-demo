import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:groceries_shopping_app/models/service.dart';

class ServiceProvider extends ChangeNotifier{
    List<Service> _servicesOffered = [
    Service(
      id: 0,
        name: 'Grocery',
        picPath: 'assets/grocery.png',),
    Service(
      id: 5 ,
        name: 'Plumbing',
        picPath: 'assets/plumbing.png',),
    Service(
      id: 2,
        name: 'Electrician',
        picPath: 'assets/electrician.png',),
    Service(
      id: 4,
        name: 'Carpenter',
        picPath: 'assets/carpenter.png',),
    // Service(
    //   id: ,
    //     name: 'Mechanic',
    //     picPath: 'assets/mechanic.png',),
    Service(
      id: 3,
        name: 'Maids',
        picPath: 'assets/maid.png',),
  ];

  UnmodifiableListView<Service> get servicesOffered {
    return UnmodifiableListView(_servicesOffered);
  }

}