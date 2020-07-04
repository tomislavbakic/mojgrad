import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:webproject/auth/org/signUpInstitution.dart';
import 'package:webproject/main.dart';
import 'package:webproject/services/api.services.org.dart';
import 'package:webproject/services/api.services.users.dart';
import 'package:webproject/services/token.session.dart';
import 'package:webproject/home/homeView.dart';
import 'package:webproject/config/config.error.dart';
import 'package:webproject/functions/loadingDialog.dart';

class LoginInstitutionMobile extends StatefulWidget {
  @override
  _LoginInstitutionStateMobile createState() => _LoginInstitutionStateMobile();
}

class _LoginInstitutionStateMobile extends State<LoginInstitutionMobile> {
  String _email = "";

  String _password = "";

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
                            Text("Dobro došli",
                                style: TextStyle(
                                    fontSize: 35.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700])),
                            SizedBox(height: 30.0),
                            buildCustomTextField(
                                "",
                                "E-mail adresa/korisničko ime",
                                Icons.email,
                                false),
                            SizedBox(height: 15.0),
                            buildCustomTextField(
                                "", "Lozinka", Icons.lock, true),
                            SizedBox(height: 30.0),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  RaisedButton(
                                    onPressed: () async {
                                      _email = _email.trim();
                                      _password = _password.trim();
                                      if (_email == "" || _password == "")
                                        setState(
                                          () {
                                            error = fillAllFieldsMSG;
                                          },
                                        );
                                      else {
                                        Dialogs.showLoadingDialog(
                                            context, _keyLoader);
                                        var sh = utf8.encode(_password);
                                        Digest password = sha1.convert(sh);
                                        //org login
                                        await APIServicesOrg.checkOrg(
                                                _email, password.toString())
                                            .then(
                                          (jwt) async {
                                            if (jwt != null) {
                                              Token.setToken = jwt;
                                              var payload = json.decode(
                                                  ascii.decode(base64.decode(
                                                      base64.normalize(
                                                          jwt.split(".")[1]))));

                                              if (payload['sub'] == "admin") {
                                                loggedAdminID = int.parse(
                                                    payload['nameid']);
                                                loggedAdminHead =
                                                    int.parse(payload['Head']);
                                              } else {
                                                loggedOrgID = int.parse(
                                                    payload['nameid']);
                                              }
                                              Navigator.of(_keyLoader
                                                            .currentContext)
                                                        .pop();
                                              return Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomePage(2)));
                                            } else {
                                              //admin login
                                              await APIServicesUsers.checkUser(
                                                      _email,
                                                      password.toString())
                                                  .then(
                                                (jwt) async {
                                                  if (jwt != null) {
                                                    Token.setToken = jwt;

                                                    var payload = json.decode(
                                                        ascii.decode(
                                                            base64.decode(base64
                                                                .normalize(
                                                                    jwt.split(
                                                                            ".")[
                                                                        1]))));

                                                    if (payload['sub'] ==
                                                        "admin") {
                                                      loggedAdminID = int.parse(
                                                          payload['nameid']);

                                                      loggedAdminHead =
                                                          int.parse(
                                                              payload['Head']);
                                                    } else {
                                                      loggedOrgID = int.parse(
                                                          payload['nameid']);
                                                    }
                                                    Navigator.of(_keyLoader
                                                            .currentContext)
                                                        .pop();
                                                    return Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    HomePage(
                                                                        1)));
                                                  } else {
                                                    setState(
                                                      () {
                                                        Navigator.of(_keyLoader
                                                                .currentContext)
                                                            .pop();
                                                        error = wrongUsersMSG;
                                                      },
                                                    );
                                                  }
                                                },
                                              );
                                            }
                                          },
                                        );
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
                                      "Prijavite se",
                                      style: TextStyle(
                                          color: Colors.green, //green
                                          fontSize: 15.0,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  RaisedButton(
                                    onPressed: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpInstitution()),
                                      );
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
                                      "Registrujte se",
                                      style: TextStyle(
                                          color: Colors.white, //green
                                          fontSize: 15.0,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ]),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              error,
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCustomTextField(
      String title, String hintText, IconData icon, bool isPassword) {
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
            if (isPassword) {
              _password = value;
            } else {
              _email = value;
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
