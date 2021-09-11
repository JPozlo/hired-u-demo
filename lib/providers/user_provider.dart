import 'package:flutter/foundation.dart';
import 'package:groceries_shopping_app/models/user.dart';

class UserProvider with ChangeNotifier {
  User _user = new User();

  User get user => _user;

  set user(User user) {
    _user = user;
    notifyListeners();
  }
}
