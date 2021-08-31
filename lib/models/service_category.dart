import 'package:flutter/material.dart';

class ServiceCategory {
  ServiceCategory({this.name, this.subServices});
  final String name;
  final List<ServiceSubCategory> subServices;
}

class ServiceSubCategory {
  ServiceSubCategory({this.name, this.price});
  final String name;
  final double price;
}
