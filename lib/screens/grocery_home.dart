import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:groceries_shopping_app/widgets/category_card.dart';

class GroceryHome extends StatefulWidget {
  const GroceryHome({ Key key }) : super(key: key);

  @override
  _GroceryHomeState createState() => _GroceryHomeState();
}

class _GroceryHomeState extends State<GroceryHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        height: response.screenHeight * 0.40,
        width: response.screenWidth,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: response.setHeight(10)),
                  child: Row(
                    children: <Widget>[
                      CategoryCard(categoryName: "Pasta & Noodles")                    
                    ],
                  ),
                ),
                      Padding(
                  padding: EdgeInsets.only(top: response.setHeight(10)),
                  child: Row(
                    children: <Widget>[
                      CategoryCard(categoryName: "Drinks")
                    ],
                  ),
                ),
                      Padding(
                  padding: EdgeInsets.only(top: response.setHeight(10)),
                  child: Row(
                    children: <Widget>[
                      CategoryCard(categoryName: "Vegetables")
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}