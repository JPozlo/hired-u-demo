import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/local_database.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/models/product.dart';
import 'package:groceries_shopping_app/models/product_category.dart';
import 'package:groceries_shopping_app/services/api/api_service.dart';
import 'package:groceries_shopping_app/utils/utils.dart';
import 'package:http/http.dart';

enum ProductStatus {
  NotCreating,
  CreatingProduct,
  CreateProductSuccess,
  CreateProductFailure,
}

class ProductsOperationsController extends ChangeNotifier {
  PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();

  ProductStatus _createProductStatus = ProductStatus.NotCreating;
  ProductStatus get createOrderStatus => _createProductStatus;

  List<Product> allList;

  List _selectedCategories = [];

  List<Product> _productsInStock = [];

  // List<Product> _productsInStock = [
  //   Product(
  //       name: 'Fusilo ketchup Toglile',
  //       picPath: [ProductImage(image: 'assets/ketchup.png')],
  //       price: 109,
  //       foodCategory: ProductCategory(name: Constants.pastaFoodCategory)
  //       // weight: '550g'
  //       ),
  //   Product(
  //       name: 'Togliatelle Rice Organic',
  //       picPath: [
  //         ProductImage(image: 'assets/rice.png'),
  //         ProductImage(image: 'assets/flour.png')
  //       ],
  //       price: 132,
  //       foodCategory: ProductCategory(name: Constants.wheatFoodCategory)
  //       // weight: '500g'
  //       ),
  //   Product(
  //       name: 'Organic Potatos',
  //       picPath: [ProductImage(image: 'assets/potatoes.png')],
  //       price: 1099,
  //       foodCategory: ProductCategory(name: Constants.wholeFoodCategory)
  //       // weight: '1000g'
  //       ),
  //   Product(
  //       name: 'Desolve Milk',
  //       picPath: [ProductImage(image: 'assets/milk.png')],
  //       price: 9099,
  //       foodCategory: ProductCategory(name: Constants.drinkFoodCategory)
  //       // weight: '550g'
  //       ),
  //   Product(
  //     name: 'Fusilo Pasta Toglile',
  //     picPath: [
  //       ProductImage(image: 'assets/pasta.png'),
  //       ProductImage(image: 'assets/flour.png')
  //     ],
  //     foodCategory: ProductCategory(name: Constants.wheatFoodCategory),
  //     price: 679,
  //     // weight: '500g'
  //   ),
  //   Product(
  //       name: 'Organic Flour',
  //       picPath: [
  //         ProductImage(image: 'assets/flour.png'),
  //         ProductImage(image: 'assets/pasta.png')
  //       ],
  //       price: 610,
  //       foodCategory: ProductCategory(name: Constants.wheatFoodCategory)
  //       // weight: '250g'
  //       ),
  // ];

  List<Product> _shoppingCart = [];
  VoidCallback onCheckOutCallback;

  void onCheckOut({VoidCallback onCheckOutCallback}) {
    this.onCheckOutCallback = onCheckOutCallback;
  }

  UnmodifiableListView<Product> get productsInStock {
    // Result result;
    // result = await Result(true, "Success", products: _productsInStock);
    // return result;
    return UnmodifiableListView(_productsInStock);
  }

  UnmodifiableListView get selectedCategories {
    return UnmodifiableListView(_selectedCategories);
  }

  UnmodifiableListView<Product> viewProductsInStock() {
    return UnmodifiableListView(_productsInStock);
  }

  UnmodifiableListView<Product> productsFilteredByPriceInStock(
      double lowPrice, double highPrice) {
    var products = _productsInStock
        .where((element) =>
            (lowPrice <= element.price) && (element.price <= highPrice))
        .toList();
    return UnmodifiableListView(products);
  }

  UnmodifiableListView<Product> productsParamsFilteredByPriceInStock(
      List<Product> productsList, double lowPrice, double highPrice) {
    var products = productsList
        .where((element) =>
            (lowPrice <= element.price) && (element.price <= highPrice))
        .toList();
    return UnmodifiableListView(products);
  }

  set updateProductsList(List<Product> newList) {
    _productsInStock = newList;
    notifyListeners();
  }

  set updateSingleItem(Product newItem) {
    _productsInStock.add(newItem);
    notifyListeners();
  }

  set updateDefaultProductsList(List<Product> newList) {
    _productsInStock = newList;
    notifyListeners();
  }

  void clearSelectedCategories() {
    _selectedCategories.clear();
    notifyListeners();
  }

  void removeItemFromSelectedCategories(item) {
    _selectedCategories.remove(item);
    notifyListeners();
  }

  void updateSelectedCategories(newItem) {
    _selectedCategories.add(newItem);
    notifyListeners();
  }

  UnmodifiableListView<Product> productsFilteredByCategoryInStock(
      String category) {
    var products = _productsInStock
        .where((element) => element.foodCategory == category)
        .toList();

    print("Products: $products");

    return UnmodifiableListView(products);
  }

  UnmodifiableListView<Product> get cart {
    return UnmodifiableListView(_shoppingCart);
  }

  void addProductToCart(int index, int id, {int bulkOrder = 0}) {
    bool inCart = false;
    int indexInCard = 0;
    if (_shoppingCart.length != 0) {
      for (int i = 0; i < _shoppingCart.length; i++) {
        if (_shoppingCart[i].name == _productsInStock[index].name &&
            _shoppingCart[i].picPath == _productsInStock[index].picPath) {
          indexInCard = i;
          inCart = true;
          break;
        }
      }
    }
    if (inCart == false) {
      _shoppingCart.add(
        Product(
          id: id,
          name: _productsInStock[index].name,
          picPath: _productsInStock[index].picPath,
          price: _productsInStock[index].price,
          foodCategory: _productsInStock[index].foodCategory,
          orderedQuantity:
              _productsInStock[index].orderedQuantity + (bulkOrder - 1),
        ),
      );
      for (int i = 0; i < _shoppingCart.length; i++) {
        _totalCost += _shoppingCart[i].price * _shoppingCart[i].orderedQuantity;
        notifyListeners();
      }
      // _shoppingCart.map((e) => {_totalCost += e.price * e.orderedQuantity});
    } else {
      _shoppingCart[indexInCard].makeOrder(bulkOrder: bulkOrder);
      notifyListeners();
    }
  }

  double _totalCost = 0.00;
  void returnTotalCost() {
    if (_totalCost == 0) {
      for (int i = 0; i < _shoppingCart.length; i++) {
        _totalCost += _shoppingCart[i].price * _shoppingCart[i].orderedQuantity;
        notifyListeners();
      }
    } else {
      _totalCost = 0.0;
      for (int i = 0; i < _shoppingCart.length; i++) {
        _totalCost += _shoppingCart[i].price * _shoppingCart[i].orderedQuantity;
        notifyListeners();
      }
    }
  }

  void deleteFromCart(int index) {
    _shoppingCart.removeAt(index);
    notifyListeners();
  }

  double get totalCost {
    return double.parse(_totalCost.toStringAsExponential(3));
  }

  void clearCart() {
    _shoppingCart.clear();
    onCheckOutCallback();
    notifyListeners();
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

        if (products.length > 0) {
          var status = await _sharedPreferences.saveValueWithKey(
              Constants.productsListPrefKey, products);
          print("Save values status: $status");
          _productsInStock = products;
          notifyListeners();
        }

        String message = responseData['message'];

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

    _createProductStatus = ProductStatus.CreatingProduct;
    notifyListeners();

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

         _createProductStatus = ProductStatus.CreateProductSuccess;
      notifyListeners();

      String message = responseData['message'];
      result =
          Result(true, message == null ? "Success" : message, payment: payment);
    } else {
      result = Result(false, "An unexpected error occurred");
         _createProductStatus = ProductStatus.CreateProductFailure;
      notifyListeners();
    }
    return result;
  }
}
