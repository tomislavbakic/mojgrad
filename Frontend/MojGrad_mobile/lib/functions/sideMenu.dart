// pozvati na glavnoj strani
// drawer: MySideMenu()

import 'package:custom_switch_button/custom_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fronend/config/config.dart';
import 'package:fronend/config/loggedUserData.dart';
import 'package:fronend/functions/logout.dart';
import 'package:fronend/functions/successfulActionDialog.dart';
import 'package:fronend/main.dart';
import 'package:fronend/models/feedback.dart';
import 'package:fronend/screens/settings/changeProfil.dart';
import 'package:fronend/services/api.services.dart';
import 'package:fronend/services/api.services.posts.dart';
import 'package:fronend/services/api.services.user.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fronend/functions/topTenUsers.dart';
import 'package:provider/provider.dart';

class MySideMenu extends StatefulWidget {
  @override
  MySideMenuState createState() => new MySideMenuState();
}

class MySideMenuState extends State<MySideMenu> {
  bool isChecked = isCheckedDark;
  String feedback;
  double grade;
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName:
                new Text("${LoggedUser.data.name} ${LoggedUser.data.lastname}"),
            accountEmail: new Text("${LoggedUser.data.email}"),
            currentAccountPicture: new CircleAvatar(
              backgroundImage: NetworkImage(wwwrootURL + LoggedUser.data.photo),
            ),
          ),
          new ListTile(
            leading: Icon(LineIcons.pencil),
            title: new Text(
              'Izmenite profil',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChangeProfilPage()));
            },
            // OVDE POZOVI ZA LOGOUT
          ),
          new ListTile(
            leading: Icon(LineIcons.comment),
            title: new Text(
              'Pošaljite povratnu informaciju',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => SimpleDialog(
                        elevation: 7.0,
                        contentPadding: EdgeInsets.all(20.0),
                        title: Column(
                          children: <Widget>[
                            Text("Ostavite komentar"),
                            TextField(
                              autofocus: false,
                              maxLines: null,
                              onChanged: (val) {
                                feedback = val;
                              },
                            ),
                            SizedBox(height: 10),
                            RaisedButton(
                                elevation: 5,
                                onPressed: () async {
                                  Feedbacks fb =
                                      new Feedbacks(LoggedUser.id, feedback);
                                  await APIServicesPosts.addFeedback(
                                      globalJWT, fb);

                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SuccessfulActionDialog("Uspešno",
                                          "Povratne informacije su poslate.");
                                    },
                                    barrierDismissible: false,
                                  );
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
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                      ));
            },
          ),
          new ListTile(
            leading: Icon(LineIcons.star),
            title: new Text(
              'Ocenite aplikaciju',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () async {
              grade = await APIServicesUsers.getUserRating(
                  globalJWT, LoggedUser.id);
              
              if (grade == -1) {
                grade = 0.0;
              }
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => SimpleDialog(
                  elevation: 7.0,
                  contentPadding: EdgeInsets.all(20.0),
                  title: Column(
                    children: <Widget>[
                      RatingBar(
                        initialRating: grade,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return Icon(
                                Icons.sentiment_very_dissatisfied,
                                color: Colors.red,
                              );
                            case 1:
                              return Icon(
                                Icons.sentiment_dissatisfied,
                                color: Colors.redAccent,
                              );
                            case 2:
                              return Icon(
                                Icons.sentiment_neutral,
                                color: Colors.amber,
                              );
                            case 3:
                              return Icon(
                                Icons.sentiment_satisfied,
                                color: Colors.lightGreen,
                              );
                            case 4:
                              return Icon(
                                Icons.sentiment_very_satisfied,
                                color: Colors.green,
                              );
                          }
                        },
                        onRatingUpdate: (rating) async {
                          await APIServices.rateMyApp(
                              globalJWT, LoggedUser.id, rating.toInt());
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SuccessfulActionDialog(
                                  "Uspešno", "Uspešno ste ocenili aplikaciju.");
                            },
                            barrierDismissible: false,
                          );
                        },
                      ),
                      SizedBox(height: 20)
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
              );
            },
          ),
          new ListTile(
            leading: Icon(FontAwesomeIcons.trophy),
            title: new Text(
              "Top 10 korisnika",
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TopTenUsersPage()));
            },
          ),
          new ListTile(
            leading: GestureDetector(
              onTap: () {
                Provider.of<ThemeModel>(context).toggleTheme();
                setState(() {
                  isChecked = isCheckedDark;
                });
              },
              child: CustomSwitchButton(
                backgroundColor: Colors.grey,
                unCheckedColor: Colors.white,
                animationDuration: Duration(milliseconds: 500),
                checkedColor: Colors.green,
                checked: isChecked,
              ),
            ),
            title: Text(
              'Promenite temu',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          new ListTile(
            leading: Icon(Icons.exit_to_app),
            title: new Text(
              'Odjavite se',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              showAlertDialog(context);
            },
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget accept = FlatButton(
      child: Text("Da"),
      onPressed: () async {
        logoutUser(context);
      },
    );
    Widget decline = FlatButton(
      child: Text("Ne"),
      onPressed: () {
        Navigator.of(context).pushNamed('/profile');
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
