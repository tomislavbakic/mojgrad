import 'package:flutter/material.dart';

class NavigationBarLogo extends StatefulWidget {
  @override
  _NavigationBarLogoState createState() => _NavigationBarLogoState();
}

class _NavigationBarLogoState extends State<NavigationBarLogo> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: 90,
      child: Image.asset('images/mojgrad_logo.png'),
    );
  }
}
