import 'package:flutter/foundation.dart';
import 'package:groceries_shopping_app/models/user.dart';

class UserProvider with ChangeNotifier {
  User _user = new User();

  User get user => _user;

  void setUser(User user) {
    _user = user;
  }
}