import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webproject/auth/org/signUp.dart';
import 'package:webproject/auth/org/signUpTablet.dart';

class SignUpInstitution extends StatefulWidget {
  @override
  _SignUpInstitutionState createState() => _SignUpInstitutionState();
}

class _SignUpInstitutionState extends State<SignUpInstitution> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: SignUpTablet(),
      tablet: SignUpTablet(),
      desktop: SignUp(),
    );
  }
}
