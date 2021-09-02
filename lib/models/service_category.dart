import 'package:flutter/material.dart';

class ServiceCategory {
  ServiceCategory({this.name, this.subServices});
  final String name;
  final List<ServiceSubCategory> subServices;
}

class ServiceSubCategory {
  ServiceSubCategory({this.name, this.price, this.value = false});
  final String name;
  final double price;
  bool value;

  @override
  String toString() {
    return "The service name: $name\nThe service price: $price";
  }
}
