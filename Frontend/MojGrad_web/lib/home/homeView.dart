import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webproject/home/homeContentDesktop.dart';
import 'package:webproject/home/homeContentMobile.dart';

class HomePage extends StatefulWidget {
  int type; // 2 za institucije 1 za admine

  HomePage(int value) {
    this.type = value;
  }
  @override
  _HomePageState createState() => _HomePageState(type);
}

class _HomePageState extends State<HomePage> {
  int type;
  _HomePageState(value) {
    type = value;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScreenTypeLayout(
        mobile: HomeContentMobile(type),
        tablet: HomeContentMobile(type),
        desktop: HomeContentDesktop(type),
      ),
    );
  }
}
