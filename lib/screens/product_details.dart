import 'package:after_layout/after_layout.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groceries_shopping_app/local_database.dart';
import 'package:groceries_shopping_app/providers/product_provider.dart';
import 'package:groceries_shopping_app/screens/home.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:groceries_shopping_app/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../appTheme.dart';

class ProductDetails extends StatefulWidget {
  ProductDetails({this.productIndex});
  final int productIndex;
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails>
    with SingleTickerProviderStateMixin, AfterLayoutMixin<ProductDetails> {
  bool isFavourite = false;
  PreferenceUtils _utils;
  AnimationController animationController;
  Animation animation;
  Animation secondaryAnimation;
  bool isToPreview;
  double opacity = 1;
  int orderQuantity = 1;
  bool temp = false;
  int _activeIndex = 0;
  final _carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    isToPreview = false;
    _utils = PreferenceUtils.getInstance();
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animation = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.decelerate));
    secondaryAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.2, 1, curve: Curves.decelerate)));
    animation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProductsOperationsController>(context);
    var productProvider =
        Provider.of<ProductsOperationsController>(context).productsInStock;
    return Scaffold(
      backgroundColor: AppTheme.mainScaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.mainScaffoldBackgroundColor,
        brightness: Brightness.light,
        leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            icon: Hero(
              tag: 'backarrow',
              child: Icon(Icons.arrow_back_ios,
                  color: Colors.black, size: response.setHeight(24)),
            ),
            onPressed: () {
              setState(() => opacity = 0);
              Navigator.pop(context);
            }),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          switch (temp) {
            case false:
              SystemChrome.setEnabledSystemUIOverlays([]);
              setState(() {
                temp = true;
              });
              break;
            case true:
              SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
              setState(() {
                temp = false;
              });
              break;
          }
        },
        child: Container(height: 100, width: 100),
      ),
      body: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Hero(
            tag: 'detailsScreen',
            child: Container(
              height: response.screenHeight,
              width: response.screenWidth,
              decoration: BoxDecoration(
                color: AppTheme.mainScaffoldBackgroundColor,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  productImages(productProvider[widget.productIndex].picPath,
                      productProvider[widget.productIndex].name),
                  SizedBox(height: 13),
                  buildIndicator(productProvider[widget.productIndex].picPath),
                  Transform(
                    //0 < animation.value < 1
                    transform: Matrix4.translationValues(
                        0.0, -animation.value * response.setHeight(20), 0.0),
                    child: Opacity(
                      opacity: secondaryAnimation.value,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: response.setWidth(30)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: response.setHeight(20)),
                            Text(
                              productProvider[widget.productIndex].name,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: response.setFontSize(40),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(height: response.setHeight(5)),
                            Text(
                              productProvider[widget.productIndex].foodCategory,
                              style: TextStyle(
                                  fontSize: response.setFontSize(15),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black45),
                            ),
                            SizedBox(height: response.setHeight(25)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                ProductQuantity(
                                  orderQuantity: orderQuantity,
                                  minusOnTap: () =>
                                      setState(() => orderQuantity--),
                                  plusOnTap: () =>
                                      setState(() => orderQuantity++),
                                ),
                                Text(
                                  getFormattedCurrency(
                                      productProvider[widget.productIndex]
                                          .price),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: response.setFontSize(40),
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(height: response.setHeight(30)),
                            Text(
                              "About the Product",
                              style: TextStyle(
                                  fontSize: response.setFontSize(17),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(height: response.setHeight(5)),
                            Text(
                              productProvider[widget.productIndex].description,
                              style: TextStyle(
                                  fontSize: response.setFontSize(15),
                                  color: Colors.black87),
                            ),
                            SizedBox(height: response.setHeight(25)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // Container(
                                //   height: response.setHeight(55),
                                //   width: response.setWidth(55),
                                //   decoration: BoxDecoration(
                                //       color: Colors.transparent,
                                //       shape: BoxShape.circle,
                                //       border: Border.all(
                                //           color: Colors.black12, width: 1)),
                                //   child: Center(
                                //     child: IconButton(
                                //         splashColor: Colors.transparent,
                                //         highlightColor: Colors.transparent,
                                //         hoverColor: Colors.transparent,
                                //         icon: FaIcon(isFavourite
                                //             ? FontAwesomeIcons.solidHeart
                                //             : FontAwesomeIcons.heart),
                                //         onPressed: () async {
                                //           setState(
                                //               () => isFavourite = !isFavourite);
                                //           await _utils.saveValueWithKey<bool>(
                                //               "${productProvider[widget.productIndex].name}-fav",
                                //               isFavourite);
                                //         }),
                                //   ),
                                // ),
                                GestureDetector(
                                  onTap: () {
                                    provider.addProductToCart(
                                      widget.productIndex,
                                      bulkOrder: orderQuantity,
                                    );
                                    setState(() {
                                      isToPreview = true;
                                      opacity = 0;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Opacity(
                                    opacity: opacity,
                                    child: Container(
                                      height: response.setHeight(55),
                                      // width: response.setWidth(235),
                                      width: response
                                          .setWidth(response.screenWidth * 0.8),
                                      decoration: BoxDecoration(
                                          color: AppTheme.mainOrangeColor,
                                          borderRadius: BorderRadius.circular(
                                              response.setHeight(50))),
                                      child: Center(
                                        child: Text(
                                          "Add to cart",
                                          style: TextStyle(
                                            fontSize: response.setFontSize(18),
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: response.setHeight(25)),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget productImages(List<String> imagePaths, String productName) {
    Widget productImage;

    if (imagePaths.length <= 1) {
       productImage = buildImage(productName, imagePaths.first);
     
    } else {
      productImage = CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: imagePaths.length,
          itemBuilder: (context, index, realIndex) {
            final imagePath = imagePaths[index];
            return buildImage(productName, imagePath);
          },
          options: CarouselOptions(
              onPageChanged: (index, reason) {
                setState(() {
                  _activeIndex = index;
                });
              },
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 6),
              viewportFraction: 1));
    }

    return productImage;
  }

  Widget buildImage(String name, String path) {
    return Hero(
      tag: isToPreview ? '$name-name' : '$path-path',
      child: Image.asset(path, scale: 0.8),
    );
  }

  Widget buildIndicator(List<String> imagePaths) {
    return AnimatedSmoothIndicator(
      activeIndex: _activeIndex,
      count: imagePaths.length,
      // onDotClicked: jumpToPage,
      effect: JumpingDotEffect(
          dotWidth: 20,
          dotHeight: 20,
          activeDotColor: AppTheme.mainOrangeColor,
          dotColor: AppTheme.mainCardBackgroundColor),
    );
  }

  void jumpToPage(int index) => _carouselController.animateToPage(index);

  @override
  void afterFirstLayout(BuildContext context) async {
    animationController.forward();
    var value = _utils.getValueWithKey(
        "${Provider.of<ProductsOperationsController>(context, listen: false).productsInStock[widget.productIndex].name}-fav");
    if (value != null) {
      setState(() => isFavourite = value);
    }
  }
}

class ProductQuantity extends StatelessWidget {
  ProductQuantity({
    this.orderQuantity,
    this.minusOnTap,
    this.plusOnTap,
  });
  final int orderQuantity;
  final VoidCallback minusOnTap;
  final VoidCallback plusOnTap;
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: response.setFontSize(20),
    );
    return Container(
      height: response.setHeight(45),
      width: response.setWidth(100),
      padding: EdgeInsets.symmetric(horizontal: response.setWidth(15)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(response.setHeight(30)),
        border:
            Border.all(color: Colors.black38, width: response.setHeight(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IgnorePointer(
            ignoring: orderQuantity > 1 ? false : true,
            child: InkWell(
              onTap: minusOnTap,
              child: Text(
                "-",
                style: textStyle.copyWith(
                    color: orderQuantity > 1 ? Colors.black87 : Colors.black26,
                    fontSize: response.setFontSize(35),
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Text(orderQuantity.toString(), style: textStyle),
          IgnorePointer(
            ignoring: orderQuantity < 50 ? false : true,
            child: InkWell(
              onTap: plusOnTap,
              child: Text(
                "+",
                style: textStyle.copyWith(
                  color: orderQuantity < 50 ? Colors.black87 : Colors.black26,
                  fontSize: response.setFontSize(24),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
