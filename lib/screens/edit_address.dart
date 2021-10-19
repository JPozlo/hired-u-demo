import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groceries_shopping_app/local_database.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/providers/providers.dart';
import 'package:groceries_shopping_app/screens/pages.dart';
import 'package:groceries_shopping_app/widgets/app_button.dart';
import 'package:groceries_shopping_app/widgets/input_decoration_widget.dart';
import 'package:provider/provider.dart';

class EditAddressPage extends StatefulWidget {
  const EditAddressPage({Key? key, required this.address}) : super(key: key);
  final UserAddress address;

  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();
  final _formKey = new GlobalKey<FormState>();
  final TextEditingController _countryController = new TextEditingController();
  final TextEditingController _countyController = new TextEditingController();
  final TextEditingController _townController = new TextEditingController();
  final TextEditingController _streetController = new TextEditingController();
  final TextEditingController _buildingController = new TextEditingController();
  final TextEditingController _suiteController = new TextEditingController();
  late String _country, _county, _building, _hometown, _streetaddress, _suite;
  bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    _countryController.text = this.widget.address.country;
    _countyController.text = this.widget.address.county;
    _townController.text = this.widget.address.homeTown;
    _streetController.text = this.widget.address.streetAddress;
    _buildingController.text = this.widget.address.building;
    _suiteController.text = this.widget.address.suite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Column(
        children: [
          topBar(),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0),
            child: detailsFormUpdate(context),
          )
        ],
      ),
    )));
  }

  Widget topBar() {
    return Container(
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Text("Profile"),
          GestureDetector(
            onTap: () => Navigator.pop(context),
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
                  text: "Update Address",
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
        controller: _countryController,
        validator: (value) => value!.isEmpty ? "Please enter country" : null,
        onSaved: (value) => _country = value!,
        decoration: inputFieldDecoration("Enter the country"));
    final countyInput = TextFormField(
        controller: _countyController,
        validator: (value) => value!.isEmpty ? "Please enter county" : null,
        onSaved: (value) => _county = value!,
        decoration: inputFieldDecoration("Enter the county"));
    final townInput = TextFormField(
        controller: _townController,
        validator: (value) => value!.isEmpty ? "Please enter town" : null,
        onSaved: (value) => _hometown = value!,
        decoration: inputFieldDecoration("Enter the town"));
    final streetInput = TextFormField(
        controller: _streetController,
        validator: (value) => value!.isEmpty ? "Please enter street" : null,
        onSaved: (value) => _streetaddress = value!,
        decoration: inputFieldDecoration("Enter the street"));
    final buildingInput = TextFormField(
        controller: _buildingController,
        validator: (value) => value!.isEmpty ? "Please enter building" : null,
        onSaved: (value) => _building = value!,
        decoration: inputFieldDecoration("Enter the building"));
    final suiteInput = TextFormField(
        controller: _suiteController,
        validator: (value) => value!.isEmpty ? "Please enter suite" : null,
        onSaved: (value) => _suite = value!,
        decoration: inputFieldDecoration("Enter the suite"));

    Widget inputFav() {
     return  Container(
        height: response.setHeight(55),
        width: response.setWidth(55),
        decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black12, width: 1)
            ),
        child: Center(
          child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              icon: FaIcon(isFavourite
                  ? FontAwesomeIcons.solidStar
                  : FontAwesomeIcons.star),
              onPressed: () {
                setState(() => isFavourite = !isFavourite);
              }),
        ),
      );
    }

    Widget favoriteInput() =>
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Text("Make this the default address"),
            inputFav(),
          ]),
        );

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

        UserAddress updateAddressDTO = UserAddress(
            country: _country,
            county: _county,
            streetAddress: _streetaddress,
            homeTown: _hometown,
            building: _building,
            suite: _suite);

        final Future<Result> createAddressResponse = addressProvider
            .updateAddress(updateAddressDTO, this.widget.address.id!);


        createAddressResponse.then((response) async{
          if (response.status){
            if (response.user != null || response.address != null) {
              userProvider.user = response.user!;
                        if(isFavourite){
                await _sharedPreferences.saveFavoriteAddress(response.address!);
            }
            }
            Fluttertoast.showToast(
                msg: "Successfully updated address",
                toastLength: Toast.LENGTH_LONG);
            Navigator.pop(context);
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
            favoriteInput(),
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
                    text: "Update Address",
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
