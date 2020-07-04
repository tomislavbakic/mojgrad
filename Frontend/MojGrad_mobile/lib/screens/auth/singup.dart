import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fronend/screens/auth/login.dart';
import 'package:fronend/models/userData.dart' as userData;
import 'package:fronend/services/api.services.user.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:fronend/config/config.error.dart';
import 'package:fronend/functions/uploadingDialog.dart';

class SingUp extends StatelessWidget {
  String _email = "";
  String _password = "";
  String _password2 = "";
  String _name = "";
  String _lastName = "";
  int _cityID;

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldstate,
      resizeToAvoidBottomPadding: false,
      body: bodyBuilder(context),
    );
  }

  Widget bodyBuilder(context) {
    return KeyboardAvoider(
      autoScroll: true,
      child: Container(
        color: Colors.grey[800], //screen background
        child: Center(
          child: Card(
            //    color: Colors.grey[50],
            elevation: 6,
            margin: EdgeInsets.symmetric(horizontal: 25, vertical: 45),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
            child: Container(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Image.asset(
                                "images/mojgrad.png",
                                fit: BoxFit.cover,
                                height: 120.0,
                                width: 120.0,
                              ),
                            ),
                            buildCustomTextField(
                                "", "Ime", Icons.person, false),
                            buildCustomTextField(
                                "", "Prezime", Icons.person_outline, false),
                            buildCustomTextField(
                                "", "E-mail adresa", Icons.email, false),
                            buildCustomTextField(
                                "", "Lozinka", Icons.lock, true),
                            buildCustomTextField(
                                "", "Ponovite lozinku", Icons.lock, true),
                            SizedBox(height: 30.0),
                            Align(
                              alignment: Alignment.topRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  RaisedButton(
                                    onPressed: () async {
                                       FocusScope.of(context).unfocus();
                                      _cityID = 1;
                                      if (_email == "" ||
                                          _name == "" ||
                                          _lastName == "" ||
                                          _password == "" ||
                                          _password2 == "") {
                                        _showSnakBarMsg(fillAllFieldsMSG);
                                      } else {
                                        _email = _email.trim();
                                        _name = _name.trim();
                                        _lastName = _lastName.trim();
                                        _password = _password.trim();
                                        _password2 = _password2.trim();
                                        var isValideEmail =
                                            userData.UserData.isEmail(_email);
                                        var isValidPassword =
                                            userData.UserData.validatePassword(
                                                _password);
                                        if (!isValideEmail) {
                                          _showSnakBarMsg(emailWrongFormatMSG);
                                        } else if (isValidPassword == 0) {
                                          _showSnakBarMsg(passwordMinReqMSG);
                                        } else if (_password != _password2)
                                          _showSnakBarMsg(passwordDontMatchMSG);
                                        else {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return LoadingDialog(
                                                  "Registracija korisnika je u toku.");
                                            },
                                            barrierDismissible: false,
                                          );
                                          var p = utf8.encode(_password);
                                          Digest sh = sha1.convert(p);
                                          _password = sh.toString();
                                          //create user data for new user in database
                                          userData.UserData newUser =
                                              userData.UserData(
                                                  _name,
                                                  _lastName,
                                                  _password,
                                                  _email,
                                                  _cityID);
                                          //new user request
                                          int res = await APIServicesUsers
                                              .registration(newUser);
                                          if (res == 0) {
                                            //ako je res 0 to znaci da je email adresa zauzeta
                                            Navigator.pop(context);
                                            _showSnakBarMsg(emailInUseMSG);
                                          } else if (res == 201 || res == 200) {
                                            //201 status code --- user are created
                                            //go to the main home page
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Login(),
                                              ),
                                            );
                                          } else {
                                            Navigator.pop(context);
                                            _showSnakBarMsg(unknownErrorMSG);
                                          }
                                        }
                                      }
                                    },
                                    elevation: 5,
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
                                          fontSize: 13.0,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(width: 26.0),
                                  RaisedButton(
                                    // KADA SE KLIKNE NA REGISTRUJTE SE
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                    },
                                    elevation: 5,
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
                                          fontSize: 13.0,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
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
          obscureText: isPassword,
          cursorColor: Colors.green[400],
          onChanged: (val) {
            switch (hintText) {
              case "Ime":
                {
                  _name = val;
                  break;
                }
              case "Prezime":
                {
                  _lastName = val;
                  break;
                }
              case "E-mail adresa":
                {
                  _email = val;

                  break;
                }
              case "Lozinka":
                {
                  //  var p = utf8.encode(val);
                  //Digest sh = sha1.convert(p);
                  _password = val; //sh.toString();
                  break;
                }
              case "Ponovite lozinku":
                {
                  //  var p = utf8.encode(val);
                  // Digest sh = sha1.convert(p);
                  _password2 = val; //sh.toString();
                  break;
                }
            }
          },
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.grey),
            hintText: hintText,
            prefixIcon: Icon(icon, color: Colors.green[400]),
          ),
        ),
      ],
    );
  }

  void _showSnakBarMsg(String msg) {
    _scaffoldstate.currentState.showSnackBar(
      new SnackBar(
        content: new Text(msg),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
        elevation: 7.0,
      ),
    );
  }
}
