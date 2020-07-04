import 'package:flutter/material.dart';
import 'package:webproject/auth/org/loginInstitution.dart';
import 'package:webproject/main.dart';
import 'package:webproject/services/token.session.dart';

void logoutUser(BuildContext context) {
  loggedAdminID = null;
  loggedOrgID = null;
  Token.deleteToken = "";
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (BuildContext context) => LoginInstitution()),
  );
}
