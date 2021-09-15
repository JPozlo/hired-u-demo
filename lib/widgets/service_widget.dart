import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:groceries_shopping_app/services/api/api_service.dart';
import 'package:groceries_shopping_app/widgets/service_details_widget.dart';

class ServiceWidget extends StatefulWidget {
  const ServiceWidget(
      {Key key,
      // @required this.widgetTitle,
      // @required this.id,
      // @required this.servicePicture,
      @required this.service,
      })
      : super(key: key);

  // final int id;
  // final String widgetTitle;
  final Service service;
  // final String servicePicture;

  @override
  _ServiceWidgetState createState() => _ServiceWidgetState();
}

class _ServiceWidgetState extends State<ServiceWidget> {
  Future<Result> _servicesListFuture;

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () {
    //   var servicesProvider =
    //       Provider.of<ServiceProvider>(context, listen: false);
    //   _servicesListFuture = servicesProvider.fetchServices(5);
    //   print("This is hit");
    // });
    _servicesListFuture = ApiService().fetchServicesList(this.widget.service.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Icon(Icons.arrow_back,
                  color: Colors.black, size: response.setHeight(24)),
            ),
            onPressed: () {
              // setState(() => opacity = 0);
              Navigator.pop(context);
            }),
        title: Text(
          this.widget.service.name,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _servicesListFuture,
        builder: (context, AsyncSnapshot<Result> snapshot) {
          print("Snapshot values: $snapshot");
          Widget defaultWidget;
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasData && snapshot.data != null) {
                if (snapshot.data.service.subCategories.length > 0) {
                  defaultWidget = displayListItems(snapshot.data.service);
                } else {
                  defaultWidget = errorWidget();
                }
              } else {
                defaultWidget = errorWidget();
              }
              break;
            case ConnectionState.none:
              defaultWidget = loading();
              break;
            case ConnectionState.waiting:
              defaultWidget = loading();
              break;
            default:
              defaultWidget = loading();
              break;
          }
          return defaultWidget;
        },
      ),
    );
  }

  Widget errorWidget() {
    return Center(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No services found!",
              style: TextStyle(fontSize: 23),
            )
          ],
        ),
      ),
    );
  }

  Widget displayListItems(Service service) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.rectangle),
              child: Image.asset(
                this.widget.service.image,
                scale: 1.2,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: response.screenHeight * 0.6,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: service.subCategories.length,
                itemBuilder: (context, index) {
                  var currentItem = service.subCategories[index];
                  return ListTile(
                      title: Text(currentItem.name),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ServiceDetails(
                                      widgetTitle: currentItem.name,
                                      subServices: currentItem.miniServices,
                                    )));
                      });
                }),
          ),
        ],
      ),
    );
  }

  Widget loading() {
    return Center(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text(" Loading ... Please wait")
          ],
        ),
      ),
    );
  }
}
