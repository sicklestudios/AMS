import 'package:myams/methods/auth_methods.dart';
import 'package:flutter/cupertino.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier{
  User? uid;
  final AuthMethods _authMethods=AuthMethods();

  User get getUser => uid!;

  set user(User value) {
    uid = value;
  }
  Future<void> refreshUser() async{
    User user=(await _authMethods.getUserInfo());
    uid=user;
    notifyListeners();
  }
}