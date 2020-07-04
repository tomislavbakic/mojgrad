import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webproject/auth/org/loginInstitutionDesktop.dart';
import 'package:webproject/auth/org/loginInstitutionMobile.dart';
import 'package:webproject/auth/org/loginInstitutionTablet.dart';

class LoginInstitution extends StatefulWidget {
  @override
  _LoginInstitutionState createState() => _LoginInstitutionState();
}

class _LoginInstitutionState extends State<LoginInstitution> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: LoginInstitutionMobile(),
      tablet: LoginInstitutionTablet(),
      desktop: LoginInstitutionDesktop(),
    );
  }
}
