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
  const NewHome({Key? key}) : super(key: key);

  @override
  _NewHomeState createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    var listInfo = Provider.of<ServiceProvider>(context).servicesOffered;
    var user = Provider.of<UserProvider>(context).user;
    return Scaffold(
        backgroundColor: AppTheme.secondaryScaffoldColor,
        body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                      children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Welcome, ",
                            style: Theme.of(context).textTheme.headline6?.copyWith(
                                  color: Colors.black,
                                ),
                          ),
                          TextSpan(
                            text: user == null ? "Osolo" : user.name,
                            style: Theme.of(context).textTheme.headline6?.copyWith(
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
                    child: user.profile == null || user.profile!.isEmpty
                        ? Image.asset(
                            "assets/avatar.png",
                            height: 70,
                            width: 70,
                          )
                        : Image.network(
                            ApiService.imageBaseURL + user.profile!,
                            height: 70,
                            width: 70,
                          ),
                  )
                ],
              ),
              SizedBox(height: 12,),
              Container(
                color: AppTheme.secondaryScaffoldColor,
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      // crossAxisSpacing: 2.0,
                      // mainAxisSpacing: 2.0,
                      // childAspectRatio: itemWidth/itemHeight
                      childAspectRatio: size.width /
                          (size.height / 2.1)
                          ),
                  itemCount: listInfo.length,
                  itemBuilder: (context, index) {
                    return ServiceCard(
                      service: listInfo[index],
                      index: index,
                    );
                  },
                ),
              ),
                      ],
                    ),
            )
            // child: Stack(
            //   alignment: Alignment.topLeft,
            //   children: [
            //     Positioned(
            //       top: 0,
            //       left: 0,
            //       width: response.screenWidth,
            //       child: Row(

            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [

            //             Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: RichText(

            //               text: TextSpan(
            //                 children: [
            //                   TextSpan(
            //                     text: "Welcome, ",
            //                     style:
            //                         Theme.of(context).textTheme.headline6.copyWith(
            //                               color: Colors.black,
            //                             ),
            //                   ),
            //                   TextSpan(
            //                     text: user == null ? "Osolo" : user.name,
            //                     style:
            //                         Theme.of(context).textTheme.headline6.copyWith(
            //                               color: Colors.black,
            //                               fontWeight: FontWeight.w600,
            //                             ),
            //                   )
            //                 ],
            //               ),
            //           ),
            //             ),
            //                 Padding(
            //                   padding: const EdgeInsets.all(8.0),
            //                   child: user.profile == null || user.profile.isEmpty ? Image.asset(
            //                     "assets/avatar.png",
            //                     height: 70,
            //                     width: 70,
            //                   ) : Image.network(
            //                      ApiService.imageBaseURL + user.profile,
            //                     height: 70,
            //                     width: 70,
            //                   ),
            //                 )
            //       ],)
            //       ),
            //   Positioned(
            //     top: 100,
            //     left: 0,
            //     width: response.screenWidth,
            //     child: Container(
            //       color: AppTheme.secondaryScaffoldColor,
            //         // height: response.screenHeight * 0.6,
            //         width: response.screenWidth,
            //         child: GridView.builder(
            //           // physics: NeverScrollableScrollPhysics(),
            //           shrinkWrap: true,
            //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //             crossAxisCount: 3,
            //             // crossAxisSpacing: 6.0,
            //             // mainAxisSpacing: 2.0,
            //             // childAspectRatio: itemWidth/itemHeight
            //             childAspectRatio:  MediaQuery.of(context).size.width /
            //                   (MediaQuery.of(context).size.height / 1.8)
            //           ),
            //           itemCount: listInfo.length,
            //           itemBuilder: (context, index) {
            //             return ServiceCard(
            //               service: listInfo[index],
            //               index: index,
            //             );
            //           },
            //         ),
            //         ),
            //   )
            // ]
            //     ),
            ));
  }
}
