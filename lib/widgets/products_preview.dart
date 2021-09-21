import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/local_database.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/providers/product_provider.dart';
import 'package:groceries_shopping_app/screens/main_home.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:groceries_shopping_app/services/api/api_service.dart';
import 'package:groceries_shopping_app/utils/utils.dart';
import 'package:groceries_shopping_app/widgets/filters_screen.dart';
import 'package:groceries_shopping_app/widgets/product_card.dart';
import 'package:provider/provider.dart';

class ProductsPreview extends StatefulWidget {
  // const ProductsPreview({ Key key }) : super(key: key);
  ProductsPreview({this.opacityAnimation});
  final Animation<double> opacityAnimation;

  @override
  _ProductsPreviewState createState() => _ProductsPreviewState();
}

class _ProductsPreviewState extends State<ProductsPreview> {
  PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();
  int productsFilterCount = 6;
  Future<Result> _productsFuture;
  ProductsOperationsController _productsProvider;
  List<Product> _productsList;

  var doLoading = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      CircularProgressIndicator(),
      Text(" Fetching Products ... Please wait")
    ],
  );

  @override
  void initState() {
    super.initState();
    _productsFuture = ApiService().fetchProductsList();
  }

  @override
  Widget build(BuildContext context) {
    var productsList =
        Provider.of<ProductsOperationsController>(context).productsInStock;

        return (productsList != null && productsList.length > 0)?  productsMainDisplay(productsList, context) :
         FutureBuilder(
            future: _productsFuture,
            initialData: Result(false, "Success", products: []),
            builder: (context, AsyncSnapshot<Result> snapshot) {
              Widget defaultWidget;
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  defaultWidget = doLoading;
                  break;
                case ConnectionState.none:
                  defaultWidget = doLoading;
                  break;
                case ConnectionState.done:
                  if (snapshot.hasData && snapshot.data.products != null) {
                    print("Snapshot data: ${snapshot.data.toString()}");
                    defaultWidget =
                        productsMainDisplay(snapshot.data.products, context);
                    Provider.of<ProductsOperationsController>(context, listen: false)
                        .updateProductsList = snapshot.data.products;
                    print("listProducts: ${snapshot.data.products}");
                  } else if (snapshot.hasError) {
                    defaultWidget = errorWidget(error: snapshot.error.toString());
                  }
                  break;
                default:
                  defaultWidget = doLoading;
                  break;
              }
              return defaultWidget;
            },
          );
  
  }

  Widget errorWidget({String error}) {
    return Stack(
      alignment: Alignment.center,
      children:[
         Positioned(
        top: 230,
        left: 10,
        width: response.screenWidth,
        child: Container(
          height: response.setHeight(70),
          margin: EdgeInsets.only(top: 6.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.5, 1],
              colors: [
                AppTheme.mainScaffoldBackgroundColor,
                AppTheme.mainScaffoldBackgroundColor.withAlpha(150)
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                error == null ? "Sorry! No products available yet" : error,
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
      ]);
  }

  Widget productsMainDisplay(List<Product> listInfo, BuildContext context) {
    return Stack(
      children: [
        Positioned(
        top: 90,
        left: 0,
        right: 0,
        child: Container(
          height: response.screenHeight * 0.79,
          width: response.screenWidth,
          child: Padding(
            padding: EdgeInsets.only(bottom: response.setHeight(12.5)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 35),
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.2),
                        crossAxisSpacing: 6),
                    itemCount: listInfo.length,
                    itemBuilder: (context, index) {
                      Product currentProduct = listInfo[index];
                      print("Current product: ${currentProduct.tags}");
                      return ProductCard(
                          product: currentProduct, index: index);
                    }),
              ),
            ),
          ),
        ),
      ),
      topBarWidget(),
      filterBarWidget(listInfo: listInfo.length)
      ]);
  }

   Widget productsLocalDisplay(List<Product> listInfo, BuildContext context) {
    return Positioned(
      top: 90,
      left: 0,
      right: 0,
      child: Container(
        height: response.screenHeight * 0.79,
        width: response.screenWidth,
        child: Padding(
          padding: EdgeInsets.only(bottom: response.setHeight(12.5)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 35),
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.2),
                      crossAxisSpacing: 6),
                  itemCount: listInfo.length,
                  itemBuilder: (context, index) {
                    Product currentProduct = listInfo[index];
                    print("Current product: ${currentProduct.tags}");
                    return ProductCard(
                        product: currentProduct, index: index);
                  }),
            ),
          ),
        ),
      ),
    );
  }

  Widget topBarWidget(){
       return Positioned(
          top: 0,
          left: 0,
          width: response.screenWidth,
          child: Container(
            height: response.setHeight(70),
            margin: EdgeInsets.only(top: 6.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.5, 1],
                colors: [
                  AppTheme.mainScaffoldBackgroundColor,
                  AppTheme.mainScaffoldBackgroundColor.withAlpha(150)
                ],
              ),
            ),
            child: Opacity(
              opacity: 1,
              child: Align(
                alignment: Alignment(0, 0.4),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: response.setWidth(20)),
                  child: getTopBar(context),
                ),
              ),
            ),
          ),
        );
  }

  Widget filterBarWidget({int listInfo}){
    return Positioned(
          top: 70,
          left: 0,
          width: response.screenWidth,
          child: Container(
            height: response.setHeight(50),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.5, 1],
                colors: [
                  AppTheme.mainScaffoldBackgroundColor,
                  AppTheme.mainScaffoldBackgroundColor.withAlpha(150)
                ],
              ),
            ),
            child: Align(
              alignment: Alignment(0, 0.4),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: response.setWidth(20)),
                child: getFilterBarUI(productsCount: listInfo),
              ),
            ),
          ),
        );
  }

  Widget getTopBar(BuildContext context) {
    return Row(
      children: <Widget>[
        Hero(
          tag: 'backarrow',
          child: GestureDetector(
            onTap: () {
              // Navigator.pop(context);
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (context) => MainHome()),
              //     (route) => false);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MainHome()));
            },
            child: Icon(
              Icons.arrow_back,
              size: response.setHeight(23),
            ),
          ),
        ),
        Spacer(flex: 5),
        Text(
          "Products",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: response.setFontSize(18),
          ),
        ),
        Spacer(flex: 5),
        // GestureDetector(
        //     onTap: () async {
        //       await _buildAlartDialog(context);
        //     },
        //     child: FaIcon(FontAwesomeIcons.bars))
      ],
    );
  }

  Widget getFilterBarUI({int productsCount}) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 17,
            decoration: BoxDecoration(
              color: AppTheme.mainScaffoldBackgroundColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          color: AppTheme.mainScaffoldBackgroundColor,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$productsCount products found',
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => FiltersScreen(),
                            fullscreenDialog: true),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Filter',
                            style: TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.sort,
                                color: AppTheme.mainOrangeColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // const Positioned(
        //   top: 0,
        //   left: 0,
        //   right: 0,
        //   child: Divider(
        //     height: 1,
        //   ),
        // )
      ],
    );
  }

  FutureOr<bool> _buildAlartDialog(BuildContext context) async {
    return showPlatformDialog<bool>(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text(
          'Info',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text("This feature will be implemented soon, stay tuned."),
        ),
        actions: <Widget>[
          PlatformDialogAction(
            child: PlatformText('OK'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }
}
