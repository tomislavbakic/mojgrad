import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fronend/config/loggedUserData.dart';
import 'package:fronend/screens/routes/HomePage.dart';
import 'package:fronend/services/api.services.dart' as api;
import 'package:fronend/services/api.services.user.dart';
import '../../main.dart';
import '../../models/view/city.dart';
import 'package:fronend/config/config.error.dart';
import 'package:fronend/functions/uploadingDialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Color boja = Colors.green;

class AdditionalInfo extends StatefulWidget {
  @override
  _AdditionalInfoState createState() => _AdditionalInfoState();
}

class _AdditionalInfoState extends State<AdditionalInfo> {
  int userID = LoggedUser.id; //logged user

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  City _currentCity;
  int godine = 0;
  String _valGender;
  List<String> _genders = ['Muški', "Ženski"];

  //dropdown grad
  Widget buildDropdownButton() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FutureBuilder<List<City>>(
            future: api.APIServices.getAllCities(globalJWT),
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
                  FocusScope.of(context).requestFocus(new FocusNode());
                  setState(() {
                    _currentCity = value;
                  });
                },
                isExpanded: false,
                value: _currentCity == null
                    ? _currentCity
                    : snapshot.data
                        .where((i) => i.name == _currentCity.name)
                        .first,
                hint: Text('Grad'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildDropdownButtonGender() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DropdownButton(
            hint: Text("Odaberite pol"),
            value: _valGender,
            items: _genders.map((value) {
              return DropdownMenuItem(
                child: Text(value),
                value: value,
              );
            }).toList(),
            onChanged: (value) {
              FocusScope.of(context).requestFocus(new FocusNode());
              setState(() {
                _valGender = value;
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldstate,
      resizeToAvoidBottomPadding: false,
      body: buildBody(context),
    );
  }

  //new post body construction
  Widget buildBody(context) {
    return Container(
      color: Colors.grey[800],
      child: Center(
        child: Card(
          color: Colors.grey[50],
          elevation: 6,
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 140),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(
                            FontAwesomeIcons.birthdayCake,
                            color: Colors.green,
                          ),
                          title: TextField(
                            keyboardType: TextInputType.number,
                            maxLines: null,
                            autofocus: false,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            onChanged: (val) {
                              godine = int.parse(val);
                            },
                            cursorColor: Colors.green,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              hintText: 'Broj godina',
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0),
                        ListTile(
                            leading: const Icon(
                              FontAwesomeIcons.venusMars,
                              color: Colors.green,
                            ),
                            title: buildDropdownButtonGender()),
                        SizedBox(height: 40.0),
                        ListTile(
                            leading: const Icon(
                              FontAwesomeIcons.building,
                              color: Colors.green,
                            ),
                            title: buildDropdownButton()),
                        Container(
                            padding: EdgeInsets.all(20),
                            alignment: Alignment.bottomRight,
                            child: buildPostButton(context))
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPostButton(context) {
    return RaisedButton(
        elevation: 7,
        child: Text("Potvrdite", style: TextStyle(color: Colors.green)),
        onPressed: () async {
          FocusScope.of(context).unfocus();
          if (godine > 120) {
            _showSnakBarMsg(ageErrorMSG);
          } else if (_valGender == null ||
              godine == 0 ||
              _currentCity == null) {
            _showSnakBarMsg(fillAllFieldsMSG);
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return LoadingDialog("Upis podataka je u toku.");
              },
              barrierDismissible: false,
            );
            String loverCaseGender = _valGender.toLowerCase();
            var saveResponse = await APIServicesUsers.additionalUserData(
                globalJWT, userID, _currentCity.id, godine, loverCaseGender);

            LoggedUser.data = await APIServicesUsers.fetchUserDataByID(
                globalJWT, LoggedUser.id);

             Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        HomePage.city(cityID: LoggedUser.data.cityID)),
                (route) => false);
          }
        },

        // icon: Icon(Icons.publish),

        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
        color: Colors.white);
  }

  // Method for showing snak bar message
  void _showSnakBarMsg(String msg) {
    _scaffoldstate.currentState.showSnackBar(
      new SnackBar(
        content: new Text(msg),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
        elevation: 7.0,
      ),
    );
  }

  //construction of text object
  Text textFunction(text) {
    return new Text(
      text,
      style: TextStyle(
        color: Colors.grey,
        fontSize: 17.0,
      ),
    );
  }
}
