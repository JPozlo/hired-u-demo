import 'package:groceries_shopping_app/models/service_category.dart';

final List<ServiceCategory> maidCategories = [
  ServiceCategory(name: "Full Home Deep Cleaning", subServices: [
    ServiceSubCategory(name: "Bathroom Deep Cleaning", price: 150),
    ServiceSubCategory(name: "Bedroom Deep Cleaning", price: 97),
    ServiceSubCategory(name: "Kitchen Deep Cleaning", price: 97),
  ]),
  ServiceCategory(name: "Office Cleaning", subServices: [
    ServiceSubCategory(name: "Whole Office Cleaning", price: 150),
    ServiceSubCategory(name: "Main Lobby Cleaning", price: 97),
  ]),
  ServiceCategory(name: "Party Cleaning", subServices: [
    ServiceSubCategory(name: "Whole House Cleaning", price: 150),
    ServiceSubCategory(name: "Single Room Cleaning", price: 97),
  ]),
];

final List<ServiceCategory> electricianCategories = [
  ServiceCategory(
    name: "House Work",
    subServices:[ ServiceSubCategory(
      name: "Socket Appliances",
      price: 908.5
    ),
    ServiceSubCategory(name: "Circuit Setup", price: 4208.5),
    ]
  ),
    ServiceCategory(name: "Office Work", subServices: [
    ServiceSubCategory(name: "Single Office Circuit Setup", price: 908.5),
    ServiceSubCategory(name: "Multi Office Circuit Setup", price: 4208.5),
  ]),
];

final List<ServiceCategory> mechanicCategories = [
  ServiceCategory(name: "Light Work", subServices: [
    ServiceSubCategory(name: "Paint Job", price: 908.5),
    ServiceSubCategory(name: "Fix Windscreen", price: 4208.5),
  ]),
  ServiceCategory(name: "Complex Work", subServices: [
    ServiceSubCategory(name: "Engine Issue", price: 1908.5),
    ServiceSubCategory(name: "Brake Pads", price: 4008.5),
    ServiceSubCategory(name: "Radiator Leak", price: 8408.5),
  ]),
];

final List<ServiceCategory> carpenterCategories = [
  ServiceCategory(name: "Light Work", subServices: [
    ServiceSubCategory(name: "Door Side Frame", price: 908.5),
    ServiceSubCategory(name: "Window Side Frame", price: 4208.5),
  ]),
  ServiceCategory(name: "Complex Work", subServices: [
    ServiceSubCategory(name: "Door Whole Frame", price: 1908.5),
    ServiceSubCategory(name: "Window Whole Frame", price: 4008.5),
    ServiceSubCategory(name: "Slim Timber Cuts", price: 8408.5),
  ]),
];
