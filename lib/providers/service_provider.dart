import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:groceries_shopping_app/local_database.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/models/service.dart';
import 'package:groceries_shopping_app/services/api/api_service.dart';
import 'package:http/http.dart';

enum ServiceStatus{
  NotCreating,
  CreatingService,
  CreateServiceSuccess,
  CreateServiceFailure,
}

class ServiceProvider extends ChangeNotifier {

   PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();

  ServiceStatus _createServiceStatus = ServiceStatus.NotCreating;
  ServiceStatus get createServiceStatus => _createServiceStatus;
  
  List<Service> _servicesOffered = [
    Service(
      id: 0,
      name: 'Grocery',
      picPath: 'assets/grocery.png',
    ),
    Service(
      id: 5,
      name: 'Plumbing',
      picPath: 'assets/plumbing.png',
    ),
    Service(
      id: 2,
      name: 'Electrician',
      picPath: 'assets/electrician.png',
    ),
    Service(
      id: 4,
      name: 'Carpenter',
      picPath: 'assets/carpenter.png',
    ),
    Service(
      id: 1,
      name: 'Technician',
      picPath: 'assets/mechanic.png',
    ),
    Service(
      id: 3,
      name: 'Maids',
      picPath: 'assets/maid.png',
    ),
  ];

  UnmodifiableListView<Service> get servicesOffered {
    return UnmodifiableListView(_servicesOffered);
  }

  Future<Result> fetchServices(int id) async {
    Result result;


    final Map<String, dynamic> fetchServicesData = {
      "id": id
    };

    
    _createServiceStatus = ServiceStatus.CreatingService;
    notifyListeners();

    Response response = await post(Uri.parse(ApiService.fetchServices),
        body: json.encode(fetchServicesData),
        headers: {'Content-Type': 'application/json'});

    final Map<String, dynamic> responseData = json.decode(response.body);

    var status = responseData['status_code'];

    if(status == 200){
  var serviceData = responseData['services'];
      // var uid = responseData['uid'];
      // var token = responseData['token'];

      var products = serviceData.map((e) => Service.fromJson(e));

      String message = responseData['message'];

    _createServiceStatus = ServiceStatus.CreateServiceSuccess;
      notifyListeners();

      result = Result(true, message, products: products);

    } else{
    _createServiceStatus = ServiceStatus.CreateServiceFailure;
      notifyListeners();
    }

  }
}
