import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/providers/product_provider.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:groceries_shopping_app/screens/product_details.dart';
import 'package:groceries_shopping_app/services/api/api_service.dart';
import 'package:groceries_shopping_app/utils/utils.dart';
import 'package:groceries_shopping_app/widgets/details_page_transition.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../appTheme.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({Key key, @required this.product, this.index}) : super(key: key);
  final Product product;
  final int index;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  ProductsOperationsController _productsProvider;
  List<Product> producInfoProvider;

  @override
  void initState() {
    super.initState();
    print("Lenght of picpath: ${this.widget.product.picPath.length}");
    // print("Image in INITSTATE: ${ApiService.imageBaseURL + this.widget.product.picPath.first.image}");
    // Future.delayed(Duration.zero, () {
    //  ;
    //   producInfoProvider = _productsProvider.viewProductsInStock();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<ProductsOperationsController>(context, listen: false)
            .updateSingleItem = this.widget.product;
        Navigator.push(
            context,
            DetailsPageRoute(
                route: ProductDetails(
              product: this.widget.product,
              index: this.widget.index
            )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        height: response.setHeight(350),
        width: response.setWidth(170),
        decoration: BoxDecoration(
            color: AppTheme.secondaryScaffoldColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 10, spreadRadius: 0.8)
            ]),
        child: Padding(
          padding: EdgeInsets.only(
            left: response.setWidth(15),
            right: response.setWidth(15),
            top: response.setWidth(20),
            bottom: response.setWidth(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //2.4
              Hero(
                tag: '${this.widget.product.tags}-path',
                child: Align(
                    alignment: Alignment.center,
                    child: CachedNetworkImage(
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      imageUrl: this.widget.product.picPath.length > 0
                          ? ApiService.imageBaseURL +
                              this.widget.product.picPath.first.image
                          : 'https://uhired.herokuapp.com/profile-images/profile.png',
                      errorWidget: (context, url, error) =>
                          Text("Problem loading the image"),
                    )
                    // child: Image.network(
                    //   "${ApiService.imageBaseURL + this.widget.product.picPath.first.image}",
                    //   scale: 2.4,
                    //   errorBuilder: (context, exception, stacktrace) {
                    //     print("The exception network: ${exception.toString()}");
                    //     print("The stacktrace network: ${stacktrace.toString()}");
                    //     return Text("Error widget");
                    //   },
                    // ),
                    ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    // getFormattedCurrency(producInfoProvider[index].price),
                    "KSh ${this.widget.product.price}",
                    style: TextStyle(
                      fontSize: response.setFontSize(24),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: response.setHeight(8)),
                  Text(
                    this.widget.product.name,
                    style: TextStyle(
                      fontSize: response.setFontSize(15),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: response.setHeight(4)),
                  Text(
                    this.widget.product.name,
                    style: TextStyle(
                      fontSize: response.setFontSize(14),
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
