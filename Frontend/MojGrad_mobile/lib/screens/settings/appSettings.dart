//import 'package:custom_switch_button/custom_switch_button.dart';
import 'package:custom_switch_button/custom_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:fronend/config/loggedUserData.dart';
import 'package:fronend/main.dart';
import 'package:fronend/models/feedback.dart';
import 'package:fronend/services/api.services.dart';
import 'package:fronend/services/api.services.posts.dart';

class AppSettings extends StatefulWidget {
  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  bool isChecked = false;
  String feedback;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(),
        body: buildBody(),
        //bottomNavigationBar: MyBottomNavigationBar(-1),
      ),
    );
  }

  Widget buildBody() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Uključite noćni režim"),
          SizedBox(height: 10.0),
          GestureDetector(
            onTap: () {
              setState(() {
                isChecked = !isChecked;
              });
            },
            child: CustomSwitchButton(
              backgroundColor: Colors.blueGrey,
              unCheckedColor: Colors.white,
              animationDuration: Duration(milliseconds: 500),
              checkedColor: Colors.teal,
              checked: isChecked,
            ),
          ),
          SizedBox(height: 20.0),
          FlatButton(
            child: Text('Feedback'),
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => SimpleDialog(
                  //contentPadding: EdgeInsets.all(20.0),
                  elevation: 5.0,
                  children: <Widget>[
                    Text("Ostavite komentar"),
                    TextField(
                      autofocus: true,
                      maxLines: null,
                      onChanged: (val) {
                        feedback = val;
                      },
                    ),
                    OutlineButton(
                      child: Text("Pošaljite"),
                      onPressed: () async {
                        Feedbacks fb = new Feedbacks(LoggedUser.id, feedback);
                        var res =
                            await APIServicesPosts.addFeedback(globalJWT, fb);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AppSettings()));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 20.0),
          Text("Ocenite aplikaciju"),
        ],
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      title: Text("Podešavanja"),
    );
  }
}
