import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/services/place_service.dart';
import 'package:groceries_shopping_app/widgets/address_search.dart';

class CreateLocationPage extends StatefulWidget {
  const CreateLocationPage({Key key}) : super(key: key);

  @override
  _CreateLocationPageState createState() => _CreateLocationPageState();
}

class _CreateLocationPageState extends State<CreateLocationPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: <Widget>[
          TextField(
            controller: _controller,
            onTap: () async {
              final sessionToken = "ksjsjs";
              // placeholder for our places search later
              // should show search screen here
              final Suggestion result = await showSearch(
                context: context,
                delegate: AddressSearch(sessionToken),
              );
            },
            // with some styling
            decoration: InputDecoration(
              icon: Container(
                margin: EdgeInsets.only(left: 20),
                width: 10,
                height: 10,
                child: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
              ),
              hintText: "Enter your shipping address",
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 8.0, top: 16.0),
            ),
          ),
        ],
      ),
    ));
  }
}
