import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webproject/auth/org/loginInstitution.dart';
import 'package:webproject/models/organisation.dart';
import 'package:webproject/services/api.services.dart';
import 'package:webproject/services/api.services.org.dart';
import 'package:webproject/config/config.error.dart';
import 'package:webproject/functions/loadingDialog.dart';

class SignUpTablet extends StatefulWidget {
  @override
  _SignUpTabletState createState() => _SignUpTabletState();
}

class _SignUpTabletState extends State<SignUpTablet> {
  String _name = "";
  String _password1 = "";
  String _password2 = "";
  String _phoneNumber = "";
  String _activity = "";
  String _location = "";
  String _email = "";
  String error = "";

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldstate,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
            child: Container(
              width: double.infinity,
              height: 650.0,
              child: Padding(
                padding: EdgeInsets.all(25.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            buildCustomTextField("", "Naziv institucije",
                                FontAwesomeIcons.university, false, "name"),
                            SizedBox(height: 8.0),
                            buildCustomTextField("", "Grad",
                                FontAwesomeIcons.building, false, "location"),
                            SizedBox(height: 8.0),
                            buildCustomTextField(
                                "",
                                "Delatnost",
                                FontAwesomeIcons.peopleCarry,
                                false,
                                "activity"),
                            SizedBox(height: 8.0),
                            buildCustomTextField("", "Telefon",
                                FontAwesomeIcons.phone, false, "phoneNumber"),
                            SizedBox(height: 8.0),
                            buildCustomTextField("", "E-mail adresa",
                                FontAwesomeIcons.envelope, false, "email"),
                            SizedBox(height: 8.0),
                            buildCustomTextField("", "Lozinka",
                                Icons.lock_outline, true, "password1"),
                            SizedBox(height: 8.0),
                            buildCustomTextField("", "Ponovite lozinku",
                                Icons.lock, true, "password2"),
                            SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                RaisedButton(
                                  onPressed: () async {
                                    _email = _email.trim();
                                    _password1 = _password1.trim();
                                    _password2 = _password2.trim();
                                    if (_name == "") {
                                      setState(() {
                                        error = nameMissingMSG;
                                      });
                                      print("nema ime");
                                    } else if (_location == "") {
                                      setState(() {
                                        error = addressMissingMSG;
                                      });
                                      print("nema adresa");
                                    } else if (_activity == "") {
                                      setState(() {
                                        error = workMissingMSG;
                                      });
                                      print("nema delatnost");
                                    } else if (_phoneNumber == "") {
                                      setState(() {
                                        error = phoneNumberMissingMSG;
                                      });

                                      print("nema phone");
                                    } else if (_email == "") {
                                      setState(() {
                                        error = emailMissingMSG;
                                      });
                                    } else if (APIServices.isEmail(_email) ==
                                        false) {
                                      setState(() {
                                        error = emailWrongFormatMSG;
                                      });
                                      print("email nije validan");
                                    } else if (_password1 == "") {
                                      setState(() {
                                        error = passwordMissingMSG;
                                      });
                                      print("nema lozinka");
                                    } else if (_password2 == "") {
                                      setState(() {
                                        error = password2MissingMSG;
                                      });
                                      print("nije uneta druga lozinka");
                                    } else if (_password1 != _password2) {
                                      setState(() {
                                        error = passwordDontMatchMSG;
                                      });
                                      print("lozinke se ne poklapaju");
                                    } else if (APIServices.validatePassword(
                                            _password1) ==
                                        0) {
                                      setState(() {
                                        error = passwordMinReqMSG;
                                      });
                                      print("lozinka los format");
                                    } else {
                                      Dialogs.showLoadingDialog(
                                          context, _keyLoader);
                                      var sh = utf8.encode(_password1);
                                      Digest password = sha1.convert(sh);
                                      Organisation org = new Organisation(
                                          _name,
                                          _email,
                                          _location,
                                          _phoneNumber,
                                          _activity,
                                          password.toString());

                                      var res = await APIServicesOrg
                                          .registrationOrganisation(org);
                                      if (res == 0) {
                                        setState(() {
                                          Navigator.of(
                                                  _keyLoader.currentContext)
                                              .pop();
                                          error = emailInUseMSG;
                                        });
                                      } else if (res == 200 || res == 201) {
                                            Navigator.of(_keyLoader
                                                            .currentContext)
                                                        .pop();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginInstitution()));
                                      }
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(25),
                                        bottomRight: Radius.circular(25),
                                        topLeft: Radius.circular(25),
                                        topRight: Radius.circular(25)),
                                  ),
                                  color: Colors.white, //white
                                  child: Text(
                                    "Registrujte se",
                                    style: TextStyle(
                                        color: Colors.green, //green
                                        fontSize: 15.0,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(width: 15),
                                RaisedButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(25),
                                        bottomRight: Radius.circular(25),
                                        topLeft: Radius.circular(25),
                                        topRight: Radius.circular(25)),
                                  ),
                                  color: Colors.grey[700], //white
                                  child: Text(
                                    "Nazad",
                                    style: TextStyle(
                                        color: Colors.white, //green
                                        fontSize: 15.0,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              error,
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                    /*Expanded(
                      flex: 2,
                      child: Center(
                        child: Material(
                          //borderRadius: BorderRadius.circular(17.0),
                          color: Colors.white,
                          child: Container(
                            height: MediaQuery.of(context).size.width * 0.31,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Image.asset("images/mojgrad.png",
                                fit: BoxFit.cover,
                                height: 650,
                                width: MediaQuery.of(context).size.width * 0.4),
                          ),
                        ),
                      ),
                    )*/
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCustomTextField(String title, String hintText, IconData icon,
      bool isPassword, String type) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(fontSize: 14, color: Colors.green),
        ),
        TextFormField(
          onChanged: (value) {
            if (type == "name") {
              _name = value;
            } else if (type == "location") {
              _location = value;
            } else if (type == "activity") {
              _activity = value;
            } else if (type == "phoneNumber") {
              _phoneNumber = value;
            } else if (type == "email") {
              _email = value;
            } else if (type == "password1") {
              _password1 = value;
            } else if (type == "password2") {
              _password2 = value;
            }
          },
          obscureText: isPassword,
          cursorColor: Colors.green,
          decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              hintText: hintText,
              prefixIcon: Icon(icon, color: Colors.green)),
        ),
      ],
    );
  }
}
