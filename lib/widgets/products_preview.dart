import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/product_provider.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
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
  int productsFilterCount = 6;

  @override
  Widget build(BuildContext context) {
    var listInfo =
        Provider.of<ProductsOperationsController>(context).productsInStock;
    return Stack(
      children: <Widget>[
        Positioned(
          top: 90,
          left: 0,
          right: 0,
          child: Container(
            height: response.screenHeight * 0.79,
            width: response.screenWidth,
            child: Padding(
              padding: EdgeInsets.only(bottom: response.setHeight(6.5)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          for (var index = 0;
                              index < (listInfo.length / 2).floor();
                              index++)
                            ProductCard(index: index)
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: response.setHeight(10)),
                        child: Column(
                          children: <Widget>[
                            for (var i = (listInfo.length / 2).floor();
                                i < listInfo.length;
                                i++)
                              ProductCard(index: i)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
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
        ),
        Positioned(
          top: 70,
          left: 0,
          width: response.screenWidth,
          child: Container(
            height: response.setHeight(70),
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
                child: getFilterBarUI(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getTopBar(BuildContext context) {
    return Row(
      children: <Widget>[
        Hero(
          tag: 'backarrow',
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: response.setHeight(23),
            ),
          ),
        ),
        Spacer(flex: 5),
        Text(
          "Pasta & Noodles",
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

  Widget getFilterBarUI() {
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
                      '$productsFilterCount products found',
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
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final count = await Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => FiltersScreen(),
                            fullscreenDialog: true),
                      );
                      print("The count is: $count");
                      if (this.mounted) {
                        setState(() {
                          productsFilterCount = count;
                        });
                      }
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
                                color: AppTheme.mainOrangeyColor),
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
