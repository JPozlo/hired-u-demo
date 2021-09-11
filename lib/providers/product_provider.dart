import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/local_database.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/models/product.dart';
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

  List<Product> _productsInStock = [
    Product(
        name: 'Fusilo ketchup Toglile',
        picPath: ['assets/ketchup.png'],
        price: 109,
        foodCategory: Constants.pastaFoodCategory
        // weight: '550g'
        ),
    Product(
        name: 'Togliatelle Rice Organic',
        picPath: [
          'assets/rice.png',
          'assets/flour.png',
        ],
        price: 132,
        foodCategory: Constants.wheatFoodCategory
        // weight: '500g'
        ),
    Product(
        name: 'Organic Potatos',
        picPath: ['assets/potatoes.png'],
        price: 1099,
        foodCategory: Constants.wholeFoodCategory
        // weight: '1000g'
        ),
    Product(
        name: 'Desolve Milk',
        picPath: ['assets/milk.png'],
        price: 9099,
        foodCategory: Constants.drinkFoodCategory
        // weight: '550g'
        ),
    Product(
      name: 'Fusilo Pasta Toglile',
      picPath: ['assets/pasta.png', 'assets/flour.png'],
      foodCategory: Constants.wheatFoodCategory,
      price: 679,
      // weight: '500g'
    ),
    Product(
        name: 'Organic Flour',
        picPath: ['assets/flour.png', 'assets/pasta.png'],
        price: 610,
        foodCategory: Constants.wheatFoodCategory
        // weight: '250g'
        ),
  ];

  List<Product> _shoppingCart = [];
  VoidCallback onCheckOutCallback;

  void onCheckOut({VoidCallback onCheckOutCallback}) {
    this.onCheckOutCallback = onCheckOutCallback;
  }

  UnmodifiableListView<Product> get productsInStock {
    return UnmodifiableListView(_productsInStock);
  }

  UnmodifiableListView get selectedCategories {
    return UnmodifiableListView(_selectedCategories);
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

  void addProductToCart(int index, {int bulkOrder = 0}) {
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

  Future<Result> fetchProducts() async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    Product fetchProductsToken = Product(token: token);

    final Map<String, dynamic> fetchProductsData = fetchProductsToken.toJson();

    _createProductStatus = ProductStatus.CreatingProduct;
    notifyListeners();

    Response response = await post(Uri.parse(ApiService.fetchProducts),
        body: json.encode(fetchProductsData),
        headers: {'Content-Type': 'application/json'});

    final Map<String, dynamic> responseData = json.decode(response.body);

    var status = responseData['status_code'];

    if (status == 200) {
      var productsData = responseData['products'];
      // var uid = responseData['uid'];
      // var token = responseData['token'];

      var products = productsData.map((e) => Product.fromJson(e));

      String message = responseData['message'];

      _createProductStatus = ProductStatus.CreateProductSuccess;
      notifyListeners();

      result = Result(true, message, products: products);
    } else {
      _createProductStatus = ProductStatus.CreateProductFailure;
      notifyListeners();

      var errors = responseData['errors'];

      print("The ERRORS: ${responseData['errors']}");

      result = Result(false, "Error registering");
    }

    print("Result value: $result");

    return result;
  }
}
