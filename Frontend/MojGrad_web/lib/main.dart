import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webproject/auth/org/loginInstitution.dart';
import 'package:webproject/services/token.session.dart';
import 'package:webproject/home/homeView.dart';

void main() => runApp(MyApp());

int loggedAdminID;
int loggedOrgID;
int loggedAdminHead;

class MyApp extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var jwt = Token.getToken;
    if (jwt == null) return "";
    if (jwt == "") return "";

    var payload = json.decode(
        ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1]))));

    if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
        .isAfter(DateTime.now())) {
      if (payload['sub'] == "admin") {
        loggedAdminID = int.parse(payload['nameid']);
        loggedAdminHead = int.parse(payload['Head']);
      } else {
        loggedOrgID = int.parse(payload['nameid']);
      }
      return jwt;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moj grad',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FutureBuilder(
        future: jwtOrEmpty,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          if (snapshot.data != "") {
            var str = snapshot.data;
            var jwt = str.split(".");

            if (jwt.length != 3) {
              return LoginInstitution();
            } else {
              var payload = json.decode(
                  ascii.decode(base64.decode(base64.normalize(jwt[1]))));

              if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
                  .isAfter(DateTime.now())) {
                return payload['sub'] == "admin" ? HomePage(1) : HomePage(2);
              } else {
                return LoginInstitution();
              }
            }
          } else {
            return LoginInstitution();
          }
        },
      ),
    );
  }
}
