import 'package:flutter/material.dart';
import '../models/user_role.dart';

class UserProvider extends ChangeNotifier {
  UserRole _role = UserRole.citizen;

  UserRole get role => _role;

  void setRole(UserRole newRole) {
    if (_role != newRole) {
      _role = newRole;
      notifyListeners();
    }
  }
}
