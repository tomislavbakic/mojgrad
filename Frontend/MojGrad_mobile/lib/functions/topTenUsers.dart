import 'package:flutter/material.dart';
import 'package:fronend/functions/bottomNavigationBar.dart';
import 'package:fronend/functions/userListView.dart';
import 'package:fronend/models/view/userInfo.dart';
import 'package:fronend/screens/routes/userProfilPage.dart';
import 'package:fronend/services/api.services.user.dart';
import 'package:fronend/main.dart';

import '../config/config.dart';

class TopTenUsersPage extends StatefulWidget {
  @override
  _TopTenUsersPage createState() => _TopTenUsersPage();
}

class _TopTenUsersPage extends State<TopTenUsersPage> {
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldstate,
        resizeToAvoidBottomPadding: false,
        appBar: buildAppBar(),
        body: buildBody(context),
        bottomNavigationBar: MyBottomNavigationBar(4),
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      title: Text("Top 10 korisnika"),
    );
  }

  Widget buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 5),
      //child: SingleChildScrollView(
      //scrollDirection: Axis.vertical,

      child: FutureBuilder(
        future: APIServicesUsers.fetchTopEkoUsersN(globalJWT),
        builder:
            (BuildContext context, AsyncSnapshot<List<UserInfo>> snapshot) {
          if (!snapshot.hasData)
            return Container(
              child: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
              width: 80,
              height: 80,
            );
          return ListView.builder(
            itemCount: snapshot.data.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              UserInfo user = snapshot.data[index];
              return Container(
                child: Card(
                  elevation: 5,
                  child: ListTile(
                    onTap: () async {
                      UserProfile.user =
                          await APIServicesUsers.fetchUserDataByID(
                              globalJWT, snapshot.data[index].id);

                      Navigator.of(context).pushNamed("/profile");
                    },
                    leading: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(wwwrootURL + user.photo),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Text(user.fullname, style: TextStyle(fontSize: 16))
                        ],
                      ),
                    ),
                    title: Text(
                      "EKO: " + user.eko.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
