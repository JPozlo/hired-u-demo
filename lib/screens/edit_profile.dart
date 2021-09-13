import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:groceries_shopping_app/appTheme.dart';
import 'package:groceries_shopping_app/models/models.dart';
import 'package:groceries_shopping_app/providers/providers.dart';
import 'package:groceries_shopping_app/screens/new_home.dart';
import 'package:groceries_shopping_app/utils/utils.dart';
import 'package:groceries_shopping_app/widgets/app_button.dart';
import 'package:groceries_shopping_app/widgets/input_decoration_widget.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key key, @required this.user}) : super(key: key);
  final User user;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = new GlobalKey<FormState>();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _nameController = new TextEditingController();
  String _email, _password, _name;

  @override
  void initState() {
    super.initState();
    _emailController.text = this.widget.user.email;
    _nameController.text = this.widget.user.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        clipBehavior: Clip.antiAlias,
        overflow: Overflow.visible,
        children: [
          topBar(),
          detailsFormUpdate(context),
          imageArea(this.widget.user)
        ],
      ),
    ));
  }

  Widget topBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 32,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text("Profile"),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Profile",
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget imageArea(User user) {
    return Positioned(
      top: 40,
      left: 50, right: 50,
      // width: response.screenWidth * 0.7,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(13.5))),
        width: response.setWidth(response.screenWidth * 0.7),
        height: response.setHeight(210),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: user.profile == null
                    ? AssetImage("assets/avatar.png")
                    : NetworkImage(user.profile),
                radius: 50.0,
              ),
              SizedBox(
                height: 13.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // nextScreen(context, EditProfilePage(user: user,));
                    },
                    child: Container(
                      child: SvgPicture.asset(
                        'assets/edit.svg',
                        width: 30,
                        height: 30,
                        color: AppTheme.mainBlueColor,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget detailsFormUpdate(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);

    final emailInput = TextFormField(
      controller: _emailController,
        validator: validateEmail,
        onSaved: (value) => _email = value,
        decoration: inputFieldDecoration("Enter your email address"));
    final nameInput = TextFormField(
      controller: _nameController,
        validator: validateEmail,
        onSaved: (value) => _name = value,
        decoration: inputFieldDecoration("Enter your name"));
    final passwordInput = TextFormField(
        obscureText: true,
        validator: (value) => value.isEmpty ? "Please enter password" : null,
        onSaved: (value) => _password = value,
        decoration: inputFieldDecoration("Enter your password"));

    var doUpdate = () {
      final form = _formKey.currentState;
      if (form.validate()) {
        form.save();

        final Future<Result> loginResponse = auth.login(_email, _name);

        loginResponse.then((response) {
          if (response.status) {
            userProvider.user = response.user;
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
    return Positioned(
        top: 230,
        left: 13,
        width: response.screenWidth,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              label("Name"),
              SizedBox(
                height: 7.0,
              ),
              nameInput,
              label("Email"),
              SizedBox(
                height: 7.0,
              ),
              emailInput,
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
              AppButton(
                  type: ButtonType.PRIMARY, text: "Update", onPressed: (){}
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => MainHome() ));
                  ),
            ],
          ),
        ));
  }
}
