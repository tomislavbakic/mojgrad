import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fronend/config/config.error.dart';
import 'package:fronend/config/loggedUserData.dart';
import 'package:fronend/services/api.services.user.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:fronend/main.dart';
import 'package:fronend/screens/routes/HomePage.dart';
import '../../main.dart';
import 'additionalInfo.dart';
import 'package:fronend/functions/uploadingDialog.dart';

class Login extends StatelessWidget {
  String _email = "";
  String _password = "";

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

  String forgottenEmailPass = '';
  Widget bodyBuilder(context) {
    return KeyboardAvoider(
      autoScroll: true,
      child: Container(
        color: Colors.grey[800], //screen background
        child: Center(
          child: Card(
            //   color: Colors.grey[50],
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
                                height: 220.0,
                                width: 220.0,
                              ),
                            ),
                            buildCustomTextField(
                                "", "E-mail adresa", Icons.email, false),
                            SizedBox(height: 15.0),
                            buildCustomTextField(
                                "", "Lozinka", Icons.lock, true),
                            SizedBox(height: 10.0),
                            InkWell(
                                onTap: () {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        SimpleDialog(
                                      elevation: 7.0,
                                      contentPadding: EdgeInsets.all(20.0),
                                      title: Column(
                                        children: <Widget>[
                                          Text(
                                            "Na ovu e-mail adresu biće Vam poslata nova lozinka. Nakon prijave savetujemo Vam da je odmah promenite.",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.redAccent),
                                          ),
                                          TextField(
                                              autofocus: false,
                                              onChanged: (val) {
                                                forgottenEmailPass = val;
                                              },
                                              decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  hintText:
                                                      'Unesite Vašu e-mail adresu')),
                                          SizedBox(height: 10),
                                          RaisedButton(
                                              elevation: 5,
                                              onPressed: () {
                                                if (forgottenEmailPass == "") {
                                                  _showSnakBarMsg(
                                                      missingEmailMSG);
                                                } else {
                                                  APIServicesUsers.resetPassword(
                                                          forgottenEmailPass)
                                                      .then((value) {
                                                    if (value == false) {
                                                      print("NIJE USPESNO ");
                                                    } else {
                                                      print("USPESNO");
                                                    }
                                                  });
                                                }
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Potvrdite',
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                              shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        30.0),
                                              ),
                                              color: Colors.white),
                                          SizedBox(height: 10)
                                        ],
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Zaboravili ste lozinku?',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(height: 10.0),
                            Align(
                              alignment: Alignment.topRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  RaisedButton(
                                    // KADA SE KLIKNE NA PRIJAVITE SE
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus();
                                      _email = _email.trim();
                                      _password = _password.trim();
                                      if (_email == "" || _password == "") {
                                        _showSnakBarMsg(fillAllFieldsMSG);
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return LoadingDialog(
                                                "Provera korisnika je u toku.");
                                          },
                                          barrierDismissible: false,
                                        );
                                        var jwt =
                                            await APIServicesUsers.checkUser(
                                                _email, _password);
                                        if (jwt != null) {
                                          storage.write(key: "jwt", value: jwt);
                                          globalJWT = jwt;
                                          var load = json.decode(ascii.decode(
                                              base64.decode(base64.normalize(
                                                  jwt.split(".")[1]))));

                                          LoggedUser.id =
                                              int.parse(load['nameid']);
                                          LoggedUser.data =
                                              await APIServicesUsers
                                                  .fetchUserDataByID(
                                                      globalJWT, LoggedUser.id);

                                          if (LoggedUser.data.gender == null &&
                                              LoggedUser.data.age == 0) {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AdditionalInfo()));
                                          } else {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        HomePage.city(
                                                            cityID: LoggedUser
                                                                .data.cityID)),
                                                (route) => false);
                                          }
                                        } else {
                                          Navigator.pop(context);
                                          _showSnakBarMsg(
                                              wrongEmailOrPasswordMSG);
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
                                      "Prijavite se",
                                      style: TextStyle(
                                          color: Colors.green, //green
                                          fontSize: 13.0,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(width: 26.0),
                                  RaisedButton(
                                    onPressed: () async {
                                      Navigator.of(context)
                                          .pushNamed("/singup");
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
                                      "Registrujte se",
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
            if (isPassword == false) {
              _email = val;
            } else {
              var p = utf8.encode(val);
              Digest sh = sha1.convert(p);
              _password = sh.toString();
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
