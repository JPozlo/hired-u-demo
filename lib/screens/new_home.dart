import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/providers/providers.dart';
import 'package:groceries_shopping_app/providers/service_provider.dart';
import 'package:groceries_shopping_app/services/api/api_service.dart';
import 'package:groceries_shopping_app/utils/constants.dart';
import 'package:groceries_shopping_app/widgets/service_card.dart';
import 'package:provider/provider.dart';
import 'package:response/response.dart';

var response = ResponseUI.instance;
double currentMainScreenFactor = 0.045;

class NewHome extends StatefulWidget {
  const NewHome({Key key}) : super(key: key);

  @override
  _NewHomeState createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {



  @override
  Widget build(BuildContext context) {
    var listInfo = Provider.of<ServiceProvider>(context).servicesOffered;
    var user = Provider.of<UserProvider>(context).user;
    return Scaffold(
        backgroundColor: AppTheme.secondaryScaffoldColor,
        body: SafeArea(
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Positioned(
                top: 0,
                left: 0,
                width: response.screenWidth,
                child: Row(
                
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Welcome, ",
                              style:
                                  Theme.of(context).textTheme.headline6.copyWith(
                                        color: Colors.black,
                                      ),
                            ),
                            TextSpan(
                              text: user == null ? "Osolo" : user.name,
                              style:
                                  Theme.of(context).textTheme.headline6.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                            )
                          ],
                        ),
                    ),
                      ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: user.profile == null || user.profile.isEmpty ? Image.asset(
                              "assets/avatar.png",
                              height: 70,
                              width: 70,
                            ) : Image.network(
                               ApiService.imageBaseURL + user.profile,
                              height: 70,
                              width: 70,
                            ),
                          )
                ],)
                ),
            Positioned(
              top: 100,
              left: 0,
              width: response.screenWidth,
              child: Hero(
                tag: 'detailsScreen',
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 13, 0, 0),
                  height: response.screenHeight * 0.4,
                  width: response.screenWidth,
                  decoration: BoxDecoration(
                    color: AppTheme.mainDarkBackgroundColor,
                    // color: Colors.teal,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 100,
              left: 0,
              width: response.screenWidth,
              child: Container(
                color: AppTheme.secondaryScaffoldColor,
                  height: response.screenHeight * 0.6,
                  width: response.screenWidth,
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,                  
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 6.0,
                      mainAxisSpacing: 5.0,
                      childAspectRatio: 1/1.2
                      // childAspectRatio:  MediaQuery.of(context).size.width /
                      //       (MediaQuery.of(context).size.height / 1.8)
                    ),
                    itemCount: listInfo.length,
                    itemBuilder: (context, index) {
                      return ServiceCard(
                        index: index,
                        serviceName: listInfo[index].name,
                      );
                    },
                  )),
            )
          ]
              // child: SingleChildScrollView(
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         Row(
              //           children: [
              //             for (var index = 0;
              //                 index < (listInfo.length / 2).floor();
              //                 index++)

              //           ],
              //         ),
              //           Padding(
              //           padding: EdgeInsets.only(top: response.setHeight(10)),
              //           child: Row(
              //             children: <Widget>[
              //               for (var i = (listInfo.length / 2).floor();
              //                   i < listInfo.length;
              //                   i++)
              //                 ServiceCard(index: i, serviceName: listInfo[i].name,)
              //             ],
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              ),
        ));
  }
}
