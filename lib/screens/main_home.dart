import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/models/service_category.dart';
import 'package:groceries_shopping_app/screens/home.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:groceries_shopping_app/widgets/drawer_widget.dart';

class MainHome extends StatefulWidget {
  const MainHome({ Key key }) : super(key: key);

  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int _currentIndex = 0;

  final screens = [
    NewHome(),
    NewHome(),
    NewHome(),
    NewHome()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: AppTheme.mainDarkBackgroundColor,
        selectedItemColor: AppTheme.mainOrangeColor,
        unselectedItemColor: AppTheme.mainScaffoldBackgroundColor,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
            backgroundColor: AppTheme.mainCardBackgroundColor,
          ),
             BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History",
            backgroundColor: AppTheme.mainCardBackgroundColor,
          ),
             BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: "Orders",
            backgroundColor: AppTheme.mainCardBackgroundColor,
          ),
             BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account",
            backgroundColor: AppTheme.mainCardBackgroundColor,
          ),
        ],
      ),     
    );
  }
}