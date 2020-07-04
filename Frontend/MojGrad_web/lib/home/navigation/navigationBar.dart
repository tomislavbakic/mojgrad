import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'navigationBarLogo.dart';
import 'package:webproject/auth/logout.dart';

class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 5.0),
      height: 100,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                MediaQuery.of(context).size.width > 900
                    ? NavigationBarLogo()
                    : Container(),
                SizedBox(width: 20),
                SizedBox(
                    height: 90,
                    width: 250,
                    child: Image.asset('images/mojgrad_onlytext.png'))
              ],
            ),
            SizedBox(width: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(width: 20), // PRAVI RAZMAK
                //NavigationBarItem('Odjavite se'),
                RaisedButton(
                  //color: Colors.grey[600],
                  elevation: 1,
                  highlightColor: Colors.grey,
                  splashColor: Colors.grey,
                  padding: EdgeInsets.all(10.0),
                  colorBrightness: Brightness.light,
                  onPressed: () {
                    showAlertDialog(context);
                  },
                  //Navigator.of(context).pop();
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                  ),
                  color: Colors.white, //white
                  child: Icon(FontAwesomeIcons.signOutAlt, color: Colors.green),
                ),

                SizedBox(width: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget accept = FlatButton(
      child: Text("Da"),
      onPressed: () async {
        logoutUser(context);
        Navigator.of(context, rootNavigator: true).pop(true);
      },
    );
    Widget decline = FlatButton(
      child: Text("Ne"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop(true);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Odjava"),
      content: Text("Da li ste sigurni da želite da se odjavite?"),
      actions: <Widget>[
        accept,
        decline,
      ],
    );

    showDialog(context: context, child: alert);
  }
}
