import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/models/product.dart';
import 'package:groceries_shopping_app/providers/product_provider.dart';
import 'dart:collection';

import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:provider/provider.dart';

class Checkout extends StatelessWidget {
  const Checkout({
    Key key,
    @required this.cartProductsProvider,
    @required this.index,
  }) : super(key: key);

  final UnmodifiableListView<Product> cartProductsProvider;
  final int index;
  String _cost() {
    int totalCost =
        cartProductsProvider[index].price *
            cartProductsProvider[index].orderedQuantity;
    return totalCost.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: response.setHeight(20)),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: response.setWidth(22),
              child: Image.asset(
                cartProductsProvider[index].picPath.first,
                scale: 7,
              ),
            ),
            SizedBox(width: response.setWidth(15)),
            Text(
              cartProductsProvider[index].orderedQuantity.toString() + '  x   ',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
                fontSize: response.setFontSize(12),
              ),
            ),
            Container(
              width: response.screenWidth * 0.4,
              // color: Colors.red,
              child: Text(
                cartProductsProvider[index].name.toString(),
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: response.setFontSize(16),
                ),
              ),
            ),
            // Spacer(),
            Text(
              "KSh " + _cost(),
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white70,
                fontSize: response.setFontSize(15),
              ),
            ),
                Spacer(),
                GestureDetector(
                  onTap: (){
                         Provider.of<ProductsOperationsController>(context,
                        listen: false)
                    .deleteFromCart(index);
                Provider.of<ProductsOperationsController>(context,
                        listen: false)
                    .returnTotalCost();
                  },
                  child:     Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  
                )
          ],
        ),
      ),
    );
  }
}
