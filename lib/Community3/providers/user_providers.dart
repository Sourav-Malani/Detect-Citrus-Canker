import 'package:flutter/cupertino.dart';
import 'package:canker_detect/Community3/resources/auth_methods.dart';
import 'package:canker_detect/Community3/resources/user.dart';

class UserProvider with ChangeNotifier {
  final AuthMethods _authMethods = AuthMethods();
  User? _user;
  User? get getUser => _user;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

  void updateUsername(String newUsername) {
    if (_user != null) {
      User updatedUser = _user!.copyWith(username: newUsername); // Create a new User instance with the updated username
      _user = updatedUser; // Update the _user field
      notifyListeners();
    }
  }

}





