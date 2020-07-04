import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fronend/config/config.dart';
import 'package:fronend/config/loggedUserData.dart';
import 'package:fronend/functions/logout.dart';
import 'package:fronend/functions/successfulActionDialog.dart';
import 'package:fronend/functions/uploadingDialog.dart';
import 'package:fronend/main.dart';
import 'package:fronend/models/userData.dart';
import 'package:fronend/models/view/city.dart';
import 'package:fronend/screens/routes/userProfilPage.dart';
import 'package:fronend/services/api.services.dart';
import 'package:fronend/services/api.services.user.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fronend/functions/bottomNavigationBar.dart';
import 'package:fronend/config/config.error.dart';
import 'package:path/path.dart';

Color boja = Colors.green;

City _currentCity;

class ChangeProfilPage extends StatefulWidget {
  @override
  _ChangeProfilPage createState() => _ChangeProfilPage();
}

class _ChangeProfilPage extends State<ChangeProfilPage> {
  NetworkImage _imageUser =
      new NetworkImage(wwwrootURL + LoggedUser.data.photo);

  String oldpass = "";
  String newpass = "";
  String newpass2 = "";

  String newName = LoggedUser.data.name;
  String newLastname = LoggedUser.data.lastname;
  String newEmail = LoggedUser.data.email;
  int newAge = LoggedUser.data.age;

  int newCityID = LoggedUser.data.cityID;
  String _name;
  String _lastname;
  String _email;
  String _userLocation;
  File _image;

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    _name = LoggedUser.data.name;
    _lastname = LoggedUser.data.lastname;
    _email = LoggedUser.data.email;
    _userLocation = LoggedUser.data.cityName;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldstate,
        resizeToAvoidBottomPadding: false,
        appBar: buildAppBar(context),
        body: buildBody(context),
        bottomNavigationBar: MyBottomNavigationBar(4),
      ),
    );
  }

  Widget buildAppBar(context) {
    return AppBar(
      title: Text("Izmenite profil"),
      actions: <Widget>[_buildConfirmButton(context)],
    );
  }

  Widget buildBody(BuildContext context) {
    // Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 40, right: 40, top: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildProfileImage(),
                      _buildImageIcon(context),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  _buildText(context, 'Ime: ', newName, "name"),
                  SizedBox(height: 10.0),
                  _buildText(context, 'Prezime: ', newLastname, "lastname"),
                  SizedBox(height: 10.0),
                  _buildText(context, 'E-mail adresa: ', newEmail, "email"),
                  SizedBox(height: 10.0),
                  _buildChangeAge(context, 'Broj godina: ', newAge, "age"),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Grad: ",
                            style: TextStyle(
                                color: Colors.blueGrey, fontSize: 18.0)),
                        Container(
                            alignment: Alignment.bottomLeft,
                            child: buildDropdownButton()),
                      ]),
                  SizedBox(
                    height: 10,
                  ),
                  _buildDeleteAndChangePassword(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //dropdown grad
  Widget buildDropdownButton() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FutureBuilder<List<City>>(
              future: APIServices.getAllCities(globalJWT),
              builder:
                  (BuildContext context, AsyncSnapshot<List<City>> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return DropdownButton<City>(
                  items: snapshot.data
                      .map((city) => DropdownMenuItem<City>(
                            child: Text(city.name),
                            value: city,
                          ))
                      .toList(),
                  onChanged: (City value) {
                    _showSnakBarMsgChange(
                        "Da biste sačuvali izmene, pritisnite dugme u gornjem desnom uglu.");
                    setState(() {
                      _currentCity = value;
                      newCityID = value.id;
                    });
                  },
                  isExpanded: false,
                  value: _currentCity == null
                      ? _currentCity
                      : snapshot.data
                          .where((i) => i.name == _currentCity.name)
                          .first,
                  hint: Text(_userLocation), //njegova lokacija trenutno
                );
              }),
        ],
      ),
    );
  }

  Future getImage(context) async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
      if (_image != null) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return LoadingDialog("Izmena profilne fotografije je u toku.");
          },
          barrierDismissible: false,
        );

        DateTime now = DateTime.now();
        String convertedDateTime =
            "${now.year.toString()}${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}${now.hour.toString()}-${now.minute.toString()}";

        String fileName = LoggedUser.id.toString() +
            "_" +
            convertedDateTime +
            "_" +
            basename(_image.path);

        APIServicesUsers.updateProfilePicture(
                globalJWT, _image, LoggedUser.id, fileName)
            .then((value) async {
          if (value == true) {
            LoggedUser.data = await APIServicesUsers.fetchUserDataByID(
                globalJWT, LoggedUser.id);
            UserProfile.user = LoggedUser.data;
            Navigator.pop(context);
            setState(() {
              UserProfile.user = LoggedUser.data;
              _imageUser = new NetworkImage(wwwrootURL + LoggedUser.data.photo);
            });

            showDialog(
              context: context,
              builder: (context) {
                return SuccessfulActionDialog("Uspešno",
                    "Izmena profilne fotografije je uspešno obavljena.");
              },
              barrierDismissible: false,
            );
          } else {}
        });
      }
    });
  }

  Future takeImage(context) async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 60);
    Navigator.pop(context);
    if (image != null) {
      showDialog(
        context: context,
        builder: (context) {
          return LoadingDialog("Izmena profilne fotografije je u toku.");
        },
        barrierDismissible: false,
      );
      setState(() {
        _image = image;
        if (_image != null) {
          DateTime now = DateTime.now();
          String convertedDateTime =
              "${now.year.toString()}${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}${now.hour.toString()}-${now.minute.toString()}";

          String fileName = LoggedUser.id.toString() +
              "_" +
              convertedDateTime +
              "_" +
              basename(_image.path);
          APIServicesUsers.updateProfilePicture(
                  globalJWT, _image, LoggedUser.id, fileName)
              .then((value) async {
            if (value == true) {
              LoggedUser.data = await APIServicesUsers.fetchUserDataByID(
                  globalJWT, LoggedUser.id);
              setState(() {
                UserProfile.user = LoggedUser.data;
                _imageUser =
                    new NetworkImage(wwwrootURL + LoggedUser.data.photo);
              });

              Navigator.pop(context);

              showDialog(
                context: context,
                builder: (context) {
                  return SuccessfulActionDialog("Uspešno",
                      "Izmena profilne fotografije je uspešno obavljena.");
                },
                barrierDismissible: false,
              );
              // Navigator.of(context).pushNamed('/profile');
            } else {}
          });
        }
      });
    }
  }

  Future uploadPic(BuildContext context) async {}

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 180.0,
        height: 180.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: _imageUser,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(100.0),
        ),
      ),
    );
  }

  Widget _buildImageIcon(context) {
    return Padding(
      padding: EdgeInsets.only(top: 120.0),
      child: IconButton(
        icon: Icon(
          FontAwesomeIcons.camera,
          size: 30.0,
        ),
        onPressed: () {
          showAlertDialog(context);
        },
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget camera = FlatButton(
      child: Text("Kamera"),
      onPressed: () async {
        takeImage(context);
      },
    );
    Widget gallery = FlatButton(
      child: Text("Galerija"),
      onPressed: () {
        getImage(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Nova fotografija"),
      content: Text("Odakle želite da izaberete novu fotografiju?"),
      actions: <Widget>[
        camera,
        gallery,
      ],
    );

    showDialog(context: context, child: alert);
  }

  Widget _buildText(
      BuildContext context, String text, String text1, String pom) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //  crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Align(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                child: Text(text,
                    style: TextStyle(color: Colors.blueGrey, fontSize: 18.0)),
              ),
              Align(
                // alignment: Alignment.centerLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(text1,
                      style: TextStyle(
                        fontSize: 17.0,
                      )),
                ),
              ),
            ],
          ),
        ),
        Align(
          //alignment: Alignment.centerLeft,
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
    );
  }

  Widget _buildChangeAge(
      BuildContext context, String text, int godine, String pom) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Align(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                child: Text(text,
                    style: TextStyle(color: Colors.blueGrey, fontSize: 18.0)),
              ),
              Align(
                child: Text(godine.toString(),
                    style: TextStyle(
                      fontSize: 17.0,
                    )),
              ),
            ],
          ),
        ),
        Align(
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
                  title: _changeUserAge(context, godine, pom),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _changeUserAge(BuildContext context, int godine, String pom) {
    int value;
    return Column(
      children: <Widget>[
        TextField(
          keyboardType: TextInputType.number,
          maxLines: null,
          autofocus: false,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ],
          onChanged: (val) {
            value = int.parse(val);
          },
          cursorColor: Colors.green,
          decoration: InputDecoration(hintText: godine.toString()),
        ),
        SizedBox(height: 10),
        RaisedButton(
            elevation: 5,
            onPressed: () {
              setState(() {
                newAge = value;
              });

              Navigator.pop(context);

              _showSnakBarMsgChange(
                  "Da biste sačuvali izmene, pritisnite dugme u gornjem desnom uglu.");
            },
            child: Text(
              'Potvrdite',
              style: TextStyle(color: Colors.white),
            ),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
            color: Colors.green),
        SizedBox(height: 10)
      ],
    );
  }

  Widget _changeUserData(BuildContext context, String text, String pom) {
    String value;
    return Column(
      children: <Widget>[
        TextField(
          autofocus: true,
          onChanged: (val) {
            value = val;
          },
          decoration: InputDecoration(hintText: text),
        ),
        SizedBox(height: 10),
        RaisedButton(
            elevation: 5,
            onPressed: () {
              switch (pom) {
                case "name":
                  {
                    setState(() {
                      newName = value;
                      text = newName;
                    });
                    break;
                  }
                case "lastname":
                  {
                    setState(() {
                      newLastname = value;
                      text = newLastname;
                    });
                    break;
                  }
                case "email":
                  {
                    setState(() {
                      newEmail = value;
                      text = newEmail;
                    });
                    break;
                  }
              }
              Navigator.pop(context);
              _showSnakBarMsgChange(
                  "Da biste sačuvali izmene, pritisnite dugme u gornjem desnom uglu.");
            },
            child: Text(
              'Potvrdite',
              style: TextStyle(color: Colors.white),
            ),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
            color: Colors.green),
        SizedBox(height: 10)
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return IconButton(
      color: Colors.white,
      onPressed: () async {
        /*   if (newEmail != LoggedUser.data.email) {
          if (UserData.isEmail(newEmail) == false) {
            _showSnakBarMsg(emailWrongFormatMSG);
            return;
          } else {
            //checking email address in database
            APIServicesUsers.checkEmail(newEmail).then((value) {
              if (value == "true") {
                _showSnakBarMsg(emailInUseMSG);
                return;
              }
            });
          }
        } */

        if (newEmail != LoggedUser.data.email ||
            newLastname != LoggedUser.data.lastname ||
            newName != LoggedUser.data.name ||
            newAge != LoggedUser.data.age ||
            newCityID != LoggedUser.data.cityID) {
          if (newEmail != LoggedUser.data.email &&
              UserData.isEmail(newEmail) == false) {
            _showSnakBarMsg(emailWrongFormatMSG);
          } else if (newEmail != LoggedUser.data.email &&
              await APIServicesUsers.checkEmail(newEmail) == 'true') {
            _showSnakBarMsg(emailInUseMSG);
            return;
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return LoadingDialog("Izmena podataka je u toku.");
              },
              barrierDismissible: false,
            );
            APIServicesUsers.changeUserData(globalJWT, LoggedUser.id, newName,
                    newLastname, newEmail, newAge, newCityID)
                .then((value) async {
              if (value == true) {
                await APIServicesUsers.fetchUserDataByID(
                        globalJWT, LoggedUser.id)
                    .then((value) {
                  LoggedUser.data = value;
                  UserProfile.user = value;
                  Navigator.pop(context);

                  UserProfile.user = LoggedUser.data;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SuccessfulActionDialog(
                          "Uspešno", "Izmena podataka je uspešno obavljena.");
                    },
                    barrierDismissible: false,
                  );
                });
              } else {}
            });
          }
        } else {}
      },
      icon: const Icon(Icons.check, size: 30),
    );
  }

  Widget _buildDeleteAndChangePassword(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildPassword(context),
        FlatButton(
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
              'Obrišite profil',
              style: TextStyle(color: Colors.white),
            ),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
            color: Colors.grey[700]),
      ],
    );
  }

  Widget _buildConfirmPassword(BuildContext context) {
    String confirmationPassword = "";
    return Column(
      children: <Widget>[
        Text('Potvrdite lozinku: '),
        TextField(
          onChanged: (val) {
            confirmationPassword = val;
          },
          decoration: InputDecoration(
            labelText: "Lozinka",
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
        FlatButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return LoadingDialog("Brisanje naloga je u toku.");
                },
                barrierDismissible: false,
              );
              APIServicesUsers.deleteUserByID(
                      globalJWT, LoggedUser.id, confirmationPassword)
                  .then((value) {
                if (value == true) {
                  //function delete logged user data and stored token data;
                  Navigator.pop(context);
                  logoutUser(context);
                } else {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  _showSnakBarMsg(deleteAccountMSG);
                }
              });
            },
            child: Text(
              'Potvrdite',
              style: TextStyle(color: Colors.white),
            ),
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: boja),
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
            labelText: "Potvrdite lozinku",
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
        SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: FlatButton(
              onPressed: () {
                oldpass = oldpass.trim();
                newpass = newpass.trim();
                newpass2 = newpass2.trim();
                if (newpass == newpass2) {
                  var passConfirm = UserData.validatePassword(newpass);
                  if (passConfirm != 1) {
                    Navigator.pop(context);
                    _showSnakBarMsg(passwordMinReqMSG);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return LoadingDialog("Izmena lozinke je u toku.");
                      },
                      barrierDismissible: false,
                    );
                    APIServicesUsers.changePassword(
                            globalJWT, LoggedUser.id, oldpass, newpass)
                        .then((value) {
                      print(value);
                      if (value == true) {
                        Navigator.pop(context);
                        Navigator.pop(context);

                        UserProfile.user = LoggedUser.data;
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SuccessfulActionDialog("Uspešno",
                                "Izmena lozinke je uspešno obavljena.");
                          },
                          barrierDismissible: false,
                        );
                      } else {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        _showSnakBarMsg(changePasswordMSG);
                      }
                    });
                  }
                } else {
                  Navigator.pop(context);
                  _showSnakBarMsg(passwordDontMatchMSG);
                }
              },
              child: Text(
                'Potvrdite',
                style: TextStyle(color: Colors.white),
              ),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              color: boja),
        ),
        SizedBox(height: 5),
      ],
    );
  }

  Widget _buildPassword(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      color: Colors.green,
      child: Text('Promenite lozinku', style: TextStyle(color: Colors.white)),
      onPressed: () {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => SimpleDialog(
                title: _buildChangePassword(context),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)))));
      },
    );
  }

  void _showSnakBarMsg(String msg) {
    _scaffoldstate.currentState.showSnackBar(
      new SnackBar(
        content: new Text(
          msg,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
        elevation: 7.0,
      ),
    );
  }

  void _showSnakBarMsgChange(String msg) {
    _scaffoldstate.currentState.showSnackBar(
      new SnackBar(
        content: new Text(
          msg,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: Colors.yellow[900],
        duration: Duration(seconds: 3),
        elevation: 7.0,
      ),
    );
  }
}
