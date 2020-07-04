import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webproject/main.dart';
import 'package:webproject/models/admin.dart';
import 'package:webproject/models/view/adminInfo.dart';
import 'package:webproject/services/api.services.dart';
import 'package:webproject/services/api.services.users.dart';
import 'package:webproject/services/token.session.dart';
import 'package:webproject/config/config.error.dart';

class AddAdministrator extends StatefulWidget {
  @override
  _AddAdministratorState createState() => _AddAdministratorState();
}

class _AddAdministratorState extends State<AddAdministrator> {
  String username = "";
  String pass = "";
  String pass2 = "";
  String error = "";
  String good = "";
  List<String> listAdmins = List<String>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.27,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Text("Dodajte novog administratora",
                              style: TextStyle(
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700])),
                          SizedBox(height: 20.0),
                          buildCustomTextField(
                              "", "Korisničko ime", Icons.person, false),
                          SizedBox(height: 15.0),
                          buildCustomTextField(
                              "", "Lozinka", Icons.lock_outline, true),
                          SizedBox(height: 15.0),
                          buildCustomTextField(
                              "", "Ponovite lozinku", Icons.lock, true),
                          SizedBox(height: 40.0),
                          Align(
                            alignment: Alignment.topRight,
                            child: RaisedButton(
                              // KADA SE KLIKNE NA DODAJ
                              onPressed: () async {
                                username = username.trim();
                                pass = pass.trim();
                                pass2 = pass2.trim();
                                if (username == "" ||
                                    pass == "" ||
                                    pass2 == "") {
                                  setState(() {
                                    error = fillAllFieldsMSG;
                                    good = "";
                                  });
                                } else if (pass != pass2) {
                                  setState(() {
                                    error = passwordDontMatchMSG;
                                    good = "";
                                  });
                                } else if (APIServices.validatePassword(pass) !=
                                    1) {
                                  setState(() {
                                    error = passwordMinReqMSG;
                                    good = "";
                                  });
                                } else {
                                  var sh = utf8.encode(pass);
                                  Digest password = sha1.convert(sh);
                                  Admin admin =
                                      new Admin(username, password.toString());
                                  await APIServices.addNewAdministrator(
                                          Token.getToken, admin)
                                      .then(
                                    (value) {
                                      if (value == true) {
                                        setState(
                                          () {
                                            good =
                                                "Administrator $username je uspešno kreiran.";
                                            error = "";
                                          },
                                        );
                                      } else {
                                        setState(
                                          () {
                                            error = adminAddFailMSG;
                                            good = "";
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
                                "  Dodaj  ",
                                style: TextStyle(
                                    color: Colors.green, //green
                                    fontSize: 15.0,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          error != ""
                              ? writeErrorMessage(error)
                              : good != "" ? writeGoodMessage(good) : Text(""),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.27,
                          color: Colors.white,
                          child: Text("Lista administratora",
                              style: TextStyle(
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800])),
                        ),
                        SizedBox(height: 5),
                        FutureBuilder(
                          future: APIServices.getAllAdminsInfo(Token.getToken),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<AdminInfo>> snapshot) {
                            if (!snapshot.hasData)
                              return Container(
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator()),
                                  width: 100,
                                  height: 100);
                            return ListView.builder(
                              itemCount: snapshot.data.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return adminListView(
                                    snapshot.data[index], index + 1, context);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget adminListView(AdminInfo admin, int index, BuildContext context) {
    print(loggedAdminHead);
    return Container(
      width: MediaQuery.of(context).size.width * 0.27,
      height: 50.0,
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(index.toString() + ".  " + admin.username),
            loggedAdminHead == 1
                ? admin.isHead == false
                    ? IconButton(
                        iconSize: 20.0,
                        // AKCIJA OBRISI ADMINA IZ SISTEMA
                        onPressed: () async {
                          var deletion =
                              await APIServices.deleteAdminByUsername(
                                  Token.getToken, admin.username);
                          setState(
                            () {
                              print(deletion);
                            },
                          );
                        },
                        icon: Icon(
                          FontAwesomeIcons.trash,
                          color: Colors.red,
                        ),
                      )
                    : Container()
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget writeErrorMessage(error) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Text(error,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  Widget writeGoodMessage(good) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Text(good,
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          )),
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
            switch (hintText) {
              case "Korisničko ime":
                username = value;
                break;
              case "Lozinka":
                pass = value;
                break;
              case "Ponovite lozinku":
                pass2 = value;
                break;
              default:
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

  Widget horizontalLine() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
    );
  }
}
