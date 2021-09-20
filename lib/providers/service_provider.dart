import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:groceries_shopping_app/local_database.dart';
import 'package:groceries_shopping_app/models/create_service_dto.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/models/service.dart';
import 'package:groceries_shopping_app/services/api/api_service.dart';
import 'package:groceries_shopping_app/utils/utils.dart';
import 'package:http/http.dart';

enum ServiceStatus {
  NotCreating,
  CreatingService,
  CreateServiceSuccess,
  CreateServiceFailure,
}

class ServiceProvider extends ChangeNotifier {
  PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();
  // List<Service> _servicesOffered = [];

  ServiceStatus _createServiceStatus = ServiceStatus.NotCreating;
  ServiceStatus get createServiceStatus => _createServiceStatus;

  List<Service> _servicesOffered = [
    Service(id: 0, name: 'Grocery', picPath: 'assets/grocery.png', image: "assets/grocery.png"),
    Service(id: 1, name: 'Plumbing', picPath: 'assets/plumbing.png', image: 'assets/plumbing.jpg'),
    Service(id: 2, name: 'Electrician', picPath: 'assets/electrician.png', image: 'assets/electrician.jpg'),
    Service(id: 4, name: 'Carpenter', picPath: 'assets/carpenter.png', image: 'assets/carpenter.jpg' ),
    Service(
        id: 5, name: 'Technician', picPath: 'assets/phone-repair-symbol.png', image: 'assets/technician.jpg'),
    Service(id: 3, name: 'Maids', picPath: 'assets/maid.png', image: 'assets/maid.jpg')
  ];

  set servicesOffered(List<Service> services) {
    _servicesOffered = services;
    notifyListeners();
  }

  UnmodifiableListView<Service> get servicesOffered {
    return UnmodifiableListView(_servicesOffered);
  }

  Future<Result> fetchServices(int id) async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    _createServiceStatus = ServiceStatus.CreatingService;
    notifyListeners();

    Response response = await get(
        Uri.parse(ApiService.fetchServices + id.toString()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    final Map<String, dynamic> responseData = json.decode(response.body);

    var status = responseData['status_code'];

    if (status == 200) {
      var serviceData = responseData['services'];
      print("Servicedata: $serviceData");
      Service service = Service.fromJson(serviceData);
      print("Servicefromjson: ${service.toString()}");

      String message = responseData['message'];

      _createServiceStatus = ServiceStatus.CreateServiceSuccess;
      notifyListeners();

      result =
          Result(true, message == null ? "Success" : message, service: service);
    } else {
      _createServiceStatus = ServiceStatus.CreateServiceFailure;
      notifyListeners();
      result = Result(false, "An unexpected error occurred");
    }

    return result;
  }

  Future<Result> createServiceOrder(
      CreateServiceDTO createOrderDTOParam) async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    CreateServiceDTO createServiceDTO = CreateServiceDTO(
        ids: createOrderDTOParam.ids, location: createOrderDTOParam.location);

    final Map<String, dynamic> createServiceData = createServiceDTO.toJson();

    _createServiceStatus = ServiceStatus.CreatingService;
    notifyListeners();

    Response response = await post(Uri.parse(ApiService.createServiceOrder),
        body: json.encode(createServiceData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    final Map<String, dynamic> responseData = json.decode(response.body);

    var status = responseData['status_code'];

    if (status == 200) {
      var serviceData = responseData['payment'];
      Payment payment = Payment.fromJson(serviceData);

      String message = responseData['message'];

      _createServiceStatus = ServiceStatus.CreateServiceSuccess;
      notifyListeners();

      result =
          Result(true, message == null ? "Success" : message, payment: payment);
    } else {
      _createServiceStatus = ServiceStatus.CreateServiceFailure;
      notifyListeners();

      result = Result(false, "An unexpected error occurred");
    }
    return result;
  }


}
