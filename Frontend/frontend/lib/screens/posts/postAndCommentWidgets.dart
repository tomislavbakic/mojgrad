import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fronend/screens/posts/flutter_map.dart';

Color boja = Colors.green;

Widget makeComment() {
  return Container(
    width: 25,
    height: 25,
    child: Center(
      child: Icon(
        FontAwesomeIcons.comment,
        color: Colors.grey,
        size: 20.0,
      ),
    ),
  );
}

Widget makeLocationButton(BuildContext context, _latitude, _longitude) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      IconButton(
        icon: Icon(Icons.location_on),
        color: Colors.red,
        iconSize: 30,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ShowOnMap(_latitude, _longitude)));
        },
      ),
    ],
  );
}
