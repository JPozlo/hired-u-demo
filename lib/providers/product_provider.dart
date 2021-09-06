import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/models/product.dart';
import 'package:groceries_shopping_app/utils/utils.dart';

class ProductsOperationsController extends ChangeNotifier {
  List<Product> allList;

  List<Product> _productsInStock = [
    Product(
        name: 'Fusilo ketchup Toglile',
        picPath: ['assets/ketchup.png'],
        price: 10.95,
        foodCategory: Constants.pastaFoodCategory
        // weight: '550g'
        ),
    Product(
        name: 'Togliatelle Rice Organic',
        picPath: ['assets/rice.png', 'assets/flour.png', ],
        price: 130.99,
        foodCategory: Constants.wheatFoodCategory
        // weight: '500g'
        ),
    Product(
      name: 'Organic Potatos',
      picPath: ['assets/potatoes.png'],
      price: 104.99,
      foodCategory: Constants.wholeFoodCategory
      // weight: '1000g'
    ),
    Product(
        name: 'Desolve Milk',
        picPath: ['assets/milk.png'],
        price: 908.99,
        foodCategory: Constants.drinkFoodCategory
        // weight: '550g'
        ),
    Product(
      name: 'Fusilo Pasta Toglile',
      picPath: ['assets/pasta.png', 'assets/flour.png'],
      foodCategory: Constants.wheatFoodCategory,
      price: 679.32,
      // weight: '500g'
    ),
    Product(
        name: 'Organic Flour',
        picPath: ['assets/flour.png', 'assets/pasta.png'],
        price: 610.95,
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

  UnmodifiableListView<Product> productsFilteredByPriceInStock(
      double lowPrice, double highPrice) {
    var products = _productsInStock
        .where((element) =>
            (lowPrice <= element.price) && (element.price <= highPrice))
        .toList();
    return UnmodifiableListView(products);
  }

    UnmodifiableListView<Product> productsParamsFilteredByPriceInStock(List<Product> productsList,
      double lowPrice, double highPrice) {
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

  UnmodifiableListView<Product> productsFilteredByCategoryInStock(
      String category) {
    var products = _productsInStock
        .where((element) => element.foodCategory == category)
        .toList();
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
      _shoppingCart.map((e) => {_totalCost += e.price * e.orderedQuantity});
      notifyListeners();
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
      }
      notifyListeners();
    } else {
      _totalCost = 0.0;
      for (int i = 0; i < _shoppingCart.length; i++) {
        _totalCost += _shoppingCart[i].price * _shoppingCart[i].orderedQuantity;
      }
      notifyListeners();
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
}
