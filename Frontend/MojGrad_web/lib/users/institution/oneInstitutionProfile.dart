import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:webproject/auth/logout.dart';
import 'package:webproject/config/configuration.dart';
import 'package:webproject/functions/loadingDialog.dart';
import 'package:webproject/main.dart';
import 'package:webproject/models/view/organisationView.dart';
import 'package:webproject/services/api.services.dart';
import 'package:webproject/services/api.services.org.dart';
import 'package:webproject/services/token.session.dart';
import 'package:crypto/crypto.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:universal_html/prefer_universal/html.dart' as html;
import 'package:smart_dialogs/smart_dialogs.dart';

Color textColor = Colors.grey;
Color colorFix = Colors.grey;
Color backgroundColor = Colors.white;
Color colorMaterial = Colors.red;
FontWeight fontWeightFix = FontWeight.w300;
FontWeight fontWeight = FontWeight.bold;
int fontSize = 17;
int fontSizeMaterial = 15;

class OneInstitution extends StatefulWidget {
  int organisationID;
  OneInstitution(organisationID) {
    this.organisationID = organisationID;
  }
  @override
  _OneInstitutionState createState() => _OneInstitutionState();
}

class _OneInstitutionState extends State<OneInstitution> {
  final ScrollController controller = ScrollController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  String postDescription = "";
  String name = '';
  String error;
  Uint8List data;

  String oldpass = "";
  String newpass = "";
  String newpass2 = "";

  bool isSmallScreen(context) {
    return MediaQuery.of(context).size.width < 700;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: FutureBuilder(
            future: APIServicesOrg.getOrganisationsDataByID(
                Token.getToken, loggedOrgID),
            builder: (BuildContext context,
                AsyncSnapshot<OrganisationView> snapshot) {
              if (!snapshot.hasData)
                return Container(
                    child: Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator()),
                    width: 100,
                    height: 100);
              else {
                OrganisationView organisation = snapshot.data;
                return oneUser(context, organisation);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget oneUser(BuildContext context, OrganisationView org) {
    String imagePath = org.photo == null
        ? wwwrootURL + "Upload//Organisations//default.png"
        : wwwrootURL + org.photo;
    Size displaySize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: displaySize.width < 1000
            ? Container(
                margin: EdgeInsets.only(top: 80),
                padding: EdgeInsets.all(3),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildText(
                          context, 'Ime: ', org.name, "name", displaySize),
                      SizedBox(height: 10.0),
                      _buildText(
                          context, 'E-mail: ', org.email, "email", displaySize),
                      SizedBox(height: 10.0),
                      _buildText(context, 'Mesto: ', org.location, "place",
                          displaySize),
                      SizedBox(height: 10.0),
                      _buildPassword(context, 'Lozinka: ', "*********"),
                      SizedBox(height: 30.0),
                      _buildDeleteButton(context),
                    ],
                  ),
                ))
            : Container(
                margin: EdgeInsets.only(top: 80),
                padding: EdgeInsets.all(3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        name == ""
                            ? Container(
                                width: displaySize.width / 9,
                                height: displaySize.width / 9,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(imagePath),
                                      fit: BoxFit.cover),
                                ),
                              )
                            : Container(
                                child: Image.memory(
                                  data,
                                  width: displaySize.width / 9,
                                  height: displaySize.width / 9,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                              ),
                        _buildImageIcon(context),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildText(
                              context, 'Ime: ', org.name, "name", displaySize),
                          SizedBox(height: 10.0),
                          _buildText(context, 'E-mail: ', org.email, "email",
                              displaySize),
                          SizedBox(height: 10.0),
                          _buildText(context, 'Mesto: ', org.location, "place",
                              displaySize),
                          SizedBox(height: 10.0),
                          _buildPassword(context, 'Lozinka: ', "*********"),
                          SizedBox(height: 30.0),
                          _buildDeleteButton(context),
                        ],
                      ),
                    ),
                  ],
                )),
      ),
    );
  }

  pickImage() {
    final html.InputElement input = html.document.createElement('input');
    input
      ..type = 'file'
      ..accept = 'image/*';

    input.onChange.listen(
      (e) {
        if (input.files.isEmpty) return;
        final reader = html.FileReader();
        reader.readAsDataUrl(input.files[0]);
        reader.onError.listen((err) => setState(() {
              error = err.toString();
            }));
        reader.onLoad.first.then(
          (res) {
            final encoded = reader.result as String;
            // remove data:image/*;base64 preambule
            final stripped =
                encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');

            setState(
              () {
                name = input.files[0].name;
                data = base64.decode(stripped);
                error = null;
                String img = base64Encode(data);
                APIServices.addImageWeb(img, organisationCoverPhotoServerRoute)
                    .then(
                  (value) {
                    String route = jsonDecode(value);
                    APIServicesOrg.orgChangePhoto(
                        Token.getToken, loggedOrgID, route);
                  },
                );
              },
            );
          },
        );
      },
    );
    input.click();
  }

  Widget _buildText(BuildContext context, String text, String text1, String pom,
      displaySize) {
    return Container(
      width: displaySize.width < 1000
          ? MediaQuery.of(context).size.width * 0.4
          : MediaQuery.of(context).size.width * 0.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  text,
                  style: TextStyle(color: Colors.blueGrey, fontSize: 18.0),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: Text(
                    text1,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                FontAwesomeIcons.pen,
                color: Colors.green,
                size: 15.0,
              ),
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => SimpleDialog(
                    elevation: 7.0,
                    contentPadding: EdgeInsets.all(20.0),
                    title: _changeUserData(context, text1, pom),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _changeUserData(BuildContext context, String text, String pom) {
    String value = "";
    return Column(
      children: <Widget>[
        Text("Izmeni"),
        TextField(
          autofocus: true,
          onChanged: (val) {
            value = val;
          },
          decoration: InputDecoration(hintText: text),
        ),
        SizedBox(height: 10),
        RaisedButton(
            onPressed: () async {
              switch (pom) {
                case "name":
                  {
                    if (value != "")
                      await APIServicesOrg.orgChangeName(
                          Token.getToken, loggedOrgID, value);
                    setState(
                      () {
                        Navigator.of(context).pop();
                      },
                    );

                    break;
                  }

                case "email":
                  {
                    if (value != "") {
                      if (APIServices.isEmail(value) == true) {
                        await APIServicesOrg.orgChangeEmail(
                            Token.getToken, loggedOrgID, value);
                      }
                    }
                    setState(
                      () {
                        Navigator.of(context).pop();
                      },
                    );

                    break;
                  }
                case "place":
                  {
                    if (value != "") {
                      await APIServicesOrg.orgChangePlace(
                          Token.getToken, loggedOrgID, value);
                    }
                    setState(
                      () {
                        Navigator.of(context).pop();
                      },
                    );
                    break;
                  }
              }
            },
            child: Text(
              'Potvrdi',
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
            color: Colors.white),
        SizedBox(height: 10)
      ],
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return RaisedButton(
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => SimpleDialog(
              title: _buildConfirmPassword(context),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
          );
        },
        child: Text(
          'Obriši profil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
        color: Colors.grey[700]);
  }

  Widget _buildConfirmPassword(BuildContext context) {
    String confirmationPassword = "";
    return Column(
      children: <Widget>[
        Text('Potvrdi lozinku: '),
        TextField(
          onChanged: (val) {
            confirmationPassword = val;
          },
          decoration: InputDecoration(
            labelText: "lozinka",
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          obscureText: true,
        ),
        SizedBox(
          height: 20,
        ),
        RaisedButton(
            onPressed: () {
              Dialogs.showLoadingDialog(context, _keyLoader);
              APIServicesOrg.deleteOrgByID(
                      Token.getToken, loggedOrgID, confirmationPassword)
                  .then((value) {
                print(value);
                if (value == true) {
                  //function delete logged user data and stored token data;
                  Navigator.pop(context);
                  logoutUser(context);
                  Info.show("Uspenšno ste izbrisali svoju instituciju");
                } else {
                  Navigator.pop(context);
                  Info.show("Pogrešna lozinka");
                  //_showDialog(context);
                  print("get");
                }
              });
            },
            child: Text(
              'Potvrdi',
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.white),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  Widget _buildChangePassword(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
            labelText: "Stara lozinka",
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          obscureText: true,
          onChanged: (val) {
            oldpass = val;
          },
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          decoration: InputDecoration(
            labelText: "Nova lozinka",
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          obscureText: true,
          onChanged: (val) {
            newpass = val;
          },
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          decoration: InputDecoration(
            labelText: "Potvrdi lozinku",
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          obscureText: true,
          onChanged: (val) {
            newpass2 = val;
          },
        ),
        SizedBox(height: 10),
        Align(
          alignment: Alignment.bottomCenter,
          child: RaisedButton(
              onPressed: () {
                if (oldpass == "" || newpass == "" || newpass2 == "") {
                  Info.show("Morate popuniti sva polja");
                } else if (APIServices.validatePassword(newpass) == 0) {
                  Info.show(
                      "Nova lozinka mora sadržati najmanje: 8 karaktera, jedno malo slovo, jedno veliko slovo i jednu cifru.");
                } else if (newpass != newpass2) {
                  Info.show("Nove lozinke se ne poklapaju");
                } else {
                  Dialogs.showLoadingDialog(context, _keyLoader);

                  var sh = utf8.encode(oldpass);
                  Digest oldpassword = sha1.convert(sh);
                  sh = utf8.encode(newpass);
                  Digest password = sha1.convert(sh);

                  APIServicesOrg.orgChangePassword(Token.getToken, loggedOrgID,
                          oldpassword.toString(), password.toString())
                      .then((value) {
                    if (value == true) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Info.show("Uspešno ste promenili svoju lozinku");
                    } else {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Info.show("Neuspešna promena lozinke");
                    }
                  });
                }
              },
              child: Text(
                'Potvrdi',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              color: Colors.white),
        ),
        SizedBox(height: 5),
      ],
    );
  }

  Widget _buildPassword(BuildContext context, String text, String pass) {
    return Container(
      width: MediaQuery.of(context).size.width < 1000
          ? MediaQuery.of(context).size.width * 0.4
          : MediaQuery.of(context).size.width * 0.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Text(text,
                    style: TextStyle(color: Colors.blueGrey, fontSize: 18.0)),
                Text(pass,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                FontAwesomeIcons.pen,
                color: Colors.green,
                size: 15.0,
              ),
              onPressed: () {
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => SimpleDialog(
                        title: _buildChangePassword(context),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageIcon(context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: FlatButton(
        onPressed: pickImage,
        child: Icon(
          Icons.image,
          color: Colors.grey[700],
          size: 50,
        ),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
        color: Colors.white,
      ),
    );
  }

  void _showDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'What do you want to remember?'),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () {},
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xFF1BC0C5),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
