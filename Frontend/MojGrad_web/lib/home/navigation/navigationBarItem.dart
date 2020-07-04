import 'package:flutter/material.dart';

class NavigationBarItem extends StatelessWidget {
  final String title;
  const NavigationBarItem(this.title);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 5,
      padding: EdgeInsets.all(10.0),
      colorBrightness: Brightness.light,
      onPressed: () {},
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25)),
      ),
      color: Colors.grey[700],
      child: Text(
        title,
        style: TextStyle(
            color: Colors.white, //green
            fontSize: 15.0,
            letterSpacing: 0.5,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
