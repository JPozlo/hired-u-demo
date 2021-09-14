import 'dart:convert';

import 'package:groceries_shopping_app/local_database.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/utils/utils.dart';
import 'package:http/http.dart';

class ApiService {
  PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();

  /// URLs
  static const String appBaseURL =
      "https://uhired.herokuapp.com/api/v1.0.1/user/";
  static const String imageBaseURL = "https://uhired.herokuapp.com";
  static const String resetBaseURL = "http://uhired.herokuapp.com/";
  // User
  static const String createNewUser = appBaseURL + "register";
  static const String loginUser = appBaseURL + "login";
  static const String resetPassword = resetBaseURL + "password/reset";
  static const String logoutUser = appBaseURL + "logout";
  static const String fetchUser = appBaseURL + "get";
  static const String fetchIP = appBaseURL + "getip";
  //Profile
  static const String changeProfile = appBaseURL + "profile/changeprofile";
  static const String changePassword = appBaseURL + "profile/changepassword";
  // Order
  static const String baseOrdersURL = appBaseURL + "orders/";
  static const String fetchAllOrders = baseOrdersURL + "";
  static const String viewOrder = baseOrdersURL + "view";
  static const String payOrder = baseOrdersURL + "pay";
  static const String createOrder = appBaseURL + "create/order";
  static const String ordersHistory = appBaseURL + "orderhistory";
  // Address
  static const String createAddress = appBaseURL + "createaddress";
  static const String allAddresses = appBaseURL + "addresses";
  // Products
  static const String fetchProducts = appBaseURL + "products";
  static const String createProductOrder = appBaseURL + "products/order";
  // Services
  static const String fetchServices = appBaseURL + "services/main/";
  static const String createServiceOrder = appBaseURL + "services/orders";
  // Payments
  static const String paymentsList = appBaseURL + "payments";

  Future<Result> fetchServicesList(int id) async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

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
      result =
          Result(true, message == null ? "Success" : message, service: service);
    } else {
      result = Result(false, "An unexpected error occurred");
    }

    return result;
  }

  Future<Result> createServiceOrderList(
      CreateServiceDTO createOrderDTOParam) async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    CreateServiceDTO createServiceDTO = CreateServiceDTO(
        ids: createOrderDTOParam.ids, location: createOrderDTOParam.location);

    final Map<String, dynamic> createServiceData = createServiceDTO.toJson();

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

      result =
          Result(true, message == null ? "Success" : message, payment: payment);
    } else {
      result = Result(false, "An unexpected error occurred");
    }
    return result;
  }

  Future<Result> fetchProductsList() async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    Response response = await get(Uri.parse(ApiService.fetchProducts),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    final Map<String, dynamic> responseData = json.decode(response.body);

    var status = responseData['status_code'];

    if (status == 200) {
      var fetchData = responseData['products'];
      var productsData = responseData['products']['data'];
      var paginationData = responseData['products']['pagination'];
      bool productsDataStatus;
      // var uid = responseData['uid'];
      // var token = responseData['token'];
      print("fetchData: ${fetchData.toString()}");
      print("productsData: ${productsData.toString()}");

      if (productsData == null) {
        productsDataStatus = false;
        result = Result(true, "No products", productStatus: productsDataStatus);
      } else {
        productsDataStatus = true;
        List<Product> products =
            productsData.map<Product>((e) => Product.fromJson(e)).toList();
        PaginationData pagination = PaginationData.fromJson(paginationData);

        String message = responseData['message'];

        print("Service products list: ${products.first.picPath.first.image}");

        result = Result(true, message == null ? "Success" : message,
            products: products,
            pagination: pagination,
            productStatus: productsDataStatus);
      }
    } else {
      String errorMessage;

      var errors = responseData['errors'];

      print("The ERRORS: ${responseData['errors']}");

      if (status == 403) {
        errorMessage = "Access Forbidden";
      }

      result = Result(false,
          errorMessage == null ? "An unexpected error occurred" : errorMessage);
    }

    print("Result value: $result");

    return result;
  }

  Future<Result> createProductOrderList(
      CreateProductOrderDTO createOrderDTOParam) async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    CreateProductOrderDTO createServiceDTO = CreateProductOrderDTO(
        items: createOrderDTOParam.items,
        userAddressesId: createOrderDTOParam.userAddressesId);

    // final Map<String, dynamic> createServiceData = createServiceDTO.toJson();
    final Map<String, dynamic> createServiceData = {
      "user_addresses_id": createOrderDTOParam.userAddressesId,
      "items": createOrderDTOParam.items
    };
    print("createServiceDat: $createServiceData");

    Response response = await post(Uri.parse(ApiService.createProductOrder),
        body: json.encode(createServiceData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    print("response: $response");

    final Map<String, dynamic> responseData = json.decode(response.body);

    var status = responseData['status_code'];

    if (status == 200) {
      var serviceData = responseData['payment'];
      Payment payment = Payment.fromJson(serviceData);

      String message = responseData['message'];
      result =
          Result(true, message == null ? "Success" : message, payment: payment);
    } else {
      result = Result(false, "An unexpected error occurred");
    }
    return result;
  }

  Future<Result> fetchAddressesList() async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    Response response = await get(Uri.parse(ApiService.allAddresses), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    final Map<String, dynamic> responseData = json.decode(response.body);

    var status = responseData['status_code'];

    if (status == 200) {
      var addressData = responseData['addresses'];
      List<UserAddress> addresses =
          addressData.map<UserAddress>((e) => UserAddress.fromJson(e)).toList();

      String message = responseData['message'];

      result = Result(true, message == null ? "Success" : message,
          addresses: addresses);
    } else {

      result = Result(false, "An unexpected error occurred");
    }
    return result;
  }

  
  Future<Result> fetchPaymentsList() async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    Response response = await get(Uri.parse(ApiService.paymentsList), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    final Map<String, dynamic> responseData = json.decode(response.body);

    var status = responseData['status_code'];

    if (status == 200) {
      var addressData = responseData['payments'];
      List<Payment> payments =
          addressData.map<Payment>((e) => Payment.fromJson(e)).toList();

      String message = responseData['message'];

      result = Result(true, message == null ? "Success" : message,
          payments: payments);
    } else {
      result = Result(false, "An unexpected error occurred");
    }
    return result;
  }
}
