import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groceries_shopping_app/local_database.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/providers/providers.dart';
import 'package:groceries_shopping_app/screens/main_home.dart';
import 'package:groceries_shopping_app/utils/helpers.dart';
import 'package:groceries_shopping_app/widgets/app_button.dart';
import 'package:groceries_shopping_app/widgets/input_decoration_widget.dart';
import 'package:provider/provider.dart';

class CreateAddressPage extends StatefulWidget {
  const CreateAddressPage({Key? key}) : super(key: key);

  @override
  _CreateAddressPageState createState() => _CreateAddressPageState();
}

class _CreateAddressPageState extends State<CreateAddressPage> {
    PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();
  final _formKey = new GlobalKey<FormState>();
  late String _country, _county, _building, _hometown, _streetaddress, _suite;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            topBar(),
          SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0),
            child: detailsFormUpdate(context),
          )
          ],
          ),
      )
    ));
  }

  Widget topBar() {
    return Container(
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Text("Profile"),
          GestureDetector(
            onTap: () => Navigator.pop(this.context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.arrow_back,
                size: 24,
              ),
            ),
          ),
          Spacer(),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Create New Address",
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                      ),
                ),
              ],
            ),
          ),
          Spacer()
        ],
      ),
    );
  }

  Widget detailsFormUpdate(BuildContext context) {
    AddressProvider addressProvider = Provider.of<AddressProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);

    final countryInput = TextFormField(
        validator: (value) => value!.isEmpty ? "Please enter country" : null,
        onSaved: (value) => _country = value!,
        decoration: inputFieldDecoration("Enter the country"));
    final countyInput = TextFormField(
        validator: (value) => value!.isEmpty ? "Please enter county" : null,
        onSaved: (value) => _county = value!,
        decoration: inputFieldDecoration("Enter the county"));
    final townInput = TextFormField(
        validator: (value) => value!.isEmpty ? "Please enter town" : null,
        onSaved: (value) => _hometown = value!,
        decoration: inputFieldDecoration("Enter the town"));
    final streetInput = TextFormField(
        validator: (value) => value!.isEmpty ? "Please enter street" : null,
        onSaved: (value) => _streetaddress = value!,
        decoration: inputFieldDecoration("Enter the street"));
    final buildingInput = TextFormField(
        validator: (value) => value!.isEmpty ? "Please enter building" : null,
        onSaved: (value) => _building = value!,
        decoration: inputFieldDecoration("Enter the building"));
    final suiteInput = TextFormField(
        validator: (value) => value!.isEmpty ? "Please enter suite" : null,
        onSaved: (value) => _suite = value!,
        decoration: inputFieldDecoration("Enter the suite"));

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Processing ... Please wait")
      ],
    );

    var doCreateAddress = () {
      final form = _formKey.currentState;
      if (form!.validate()) {
        form.save();

        UserAddress createAddressDTO = UserAddress(
            country: _country,
            county: _county,
            streetAddress: _streetaddress,
            homeTown: _hometown,
            building: _building,
            suite: _suite);

        final Future<Result> createAddressResponse =
            addressProvider.createAddress(createAddressDTO);

        createAddressResponse.then((response) async {
          if (response.status) {
            if (response.user != null || response.address != null) {
              userProvider.user = response.user!;
              await _sharedPreferences.saveFavoriteAddress(response.address!);
            }
            Fluttertoast.showToast(
                msg: "Successfully created address",
                toastLength: Toast.LENGTH_LONG);
            nextScreen(context, MainHome());
          } else {
            Flushbar(
              title: "Failed Login",
              message: response.message.toString(),
              duration: Duration(seconds: 3),
            ).show(context);
          }
        });
      } else {
        Flushbar(
          title: "Invalid form",
          message: "Please Complete the form properly",
          duration: Duration(seconds: 10),
        ).show(context);
      }
    };
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [                
            label("Country"),
            SizedBox(
              height: 7.0,
            ),
            countryInput,
            label("County"),
            SizedBox(
              height: 7.0,
            ),
            countyInput,
            label("Town"),
            SizedBox(
              height: 7.0,
            ),
            townInput,
               label("Street"),
            SizedBox(
              height: 7.0,
            ),
            streetInput,
                     label("Building"),
            SizedBox(
              height: 7.0,
            ),
            buildingInput,
                     label("Suite"),
            SizedBox(
              height: 7.0,
            ),
            suiteInput,
            SizedBox(
              height: 25.0,
            ),
            // label("Password"),
            // SizedBox(
            //   height: 7.0,
            // ),
            // passwordInput,
            SizedBox(
              height: 20.0,
            ),
            addressProvider.createAddressStatus == AddressStatus.Processing
                ? loading
                : AppButton(
                    type: ButtonType.PRIMARY,
                    text: "Create Address",
                    onPressed: doCreateAddress
                    // Navigator.doCrea(context, MaterialPageRoute(builder: (context) => MainHome() ));
                    ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }


}
