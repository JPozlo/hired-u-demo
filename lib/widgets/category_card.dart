import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/screens/home.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:groceries_shopping_app/widgets/details_page_transition.dart';

class CategoryCard extends StatelessWidget {
  CategoryCard({@required this.categoryName});
  final String? categoryName;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, DetailsPageRoute(route: HomeScreen()));
      },
      child: Container(
          margin: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
          height: response.setHeight(35),
          width: response.screenWidth! * 0.6,
          decoration: BoxDecoration(
              color: AppTheme.secondaryScaffoldColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 10, spreadRadius: 0.8)
              ]),
          child: Center(child: Text(categoryName!))),
    );
  }
}
