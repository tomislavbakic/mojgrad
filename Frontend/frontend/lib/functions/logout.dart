import 'package:flutter/material.dart';
import 'package:fronend/config/loggedUserData.dart';
import 'package:fronend/main.dart';
import 'package:fronend/screens/auth/login.dart';

void logoutUser(BuildContext context) {
  LoggedUser.id = null;
  LoggedUser.data = null;
  globalJWT = null;
  storage.delete(key: "jwt");
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => Login(),
    ),
  );
}
