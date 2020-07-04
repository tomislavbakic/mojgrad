import 'package:flutter/material.dart';
import 'package:webproject/main.dart';
import 'package:webproject/users/institution/oneInstitutionProfile.dart';
import 'package:webproject/posts/saved.dart';
import 'package:webproject/posts/newPostInstituion.dart';
import 'package:webproject/posts/showPosts.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

bool isActive1 = true;
bool isActive2 = false;
bool isActive3 = false;
bool isActive4 = false;
bool isActive5 = false;
Widget type = ShowPostsPage(2); // 2 za institucije 1 za admine

class MainContentInstitution extends StatefulWidget {
  int userType; // 2 za institucije 1 za admine

  MainContentInstitution(int value) {
    this.userType = value;
  }
  @override
  _MainContentState createState() => _MainContentState(userType);
}

class _MainContentState extends State<MainContentInstitution> {
  int userType; // 2 za institucije 1 za admine

  _MainContentState(int value) {
    this.userType = value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      height: MediaQuery.of(context).size.height,
      //height: 800,
      child: Column(
        children: <Widget>[
          Expanded(
            child: _buildContent(),
            //flex: 7,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Card(
      elevation: 1,
      child: Row(
        children: <Widget>[_buildContentBar(), type],
      ),
    );
  }

  String dropdownValue = 'Korisnici';
  String dropdownValue2 = 'Objave';

  Widget _buildContentBar() {
    if (MediaQuery.of(context).size.width > 900) {
      return Container(
        child: Drawer(
          elevation: 0,
          child: ListView(
            children: <Widget>[
              new ListTile(
                leading: Container(
                  width: 30,
                  child: Icon(
                    FontAwesomeIcons.images,
                    color: isActive1 ? Colors.green : Colors.grey,
                  ),
                ),
                title: new Text(
                  'Objave',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  setState(() {
                    type =
                        ShowPostsPage(userType); // 2 za institucije 1 za admine
                    isActive1 = true;
                    isActive2 = false;
                    isActive3 = false;
                    isActive4 = false;

                    isActive5 = false;
                  });
                },
              ),
              new ListTile(
                leading: Container(
                  width: 30,
                  child: Icon(
                    FontAwesomeIcons.bell,
                    color: isActive2 ? Colors.green : Colors.grey,
                  ),
                ),
                title: new Text(
                  'Oglasite se',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  setState(() {
                    type = NewPost(userType);
                    isActive1 = false;
                    isActive2 = true;
                    isActive3 = false;
                    isActive4 = false;
                    isActive5 = false;
                  });
                },
              ),
              new ListTile(
                leading: Container(
                  width: 30,
                  child: Icon(
                    FontAwesomeIcons.bookmark,
                    color: isActive3 ? Colors.green : Colors.grey,
                  ),
                ),
                title: new Text(
                  'Sačuvano',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  setState(() {
                    type = Saved(userType);
                    isActive1 = false;
                    isActive2 = false;
                    isActive3 = true;
                    isActive4 = false;
                    isActive5 = false;
                  });
                },
              ),
              new ListTile(
                leading: Container(
                  width: 30,
                  child: Icon(
                    FontAwesomeIcons.university,
                    color: isActive4 ? Colors.green : Colors.grey,
                  ),
                ),
                title: new Text(
                  'Profil',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  setState(() {
                    type = OneInstitution(loggedOrgID);
                    isActive1 = false;
                    isActive2 = false;
                    isActive3 = false;
                    isActive4 = true;
                    isActive5 = false;
                  });
                },
              ),
            ],
          ),
        ),
      );
    }
  
    return Container(
      width: 70,
      child: Drawer(
        elevation: 0,
        child: ListView(
          children: <Widget>[
            new ListTile(
              leading: Container(
                width: 30,
                child: Icon(
                  FontAwesomeIcons.images,
                  color: isActive1 ? Colors.green : Colors.grey,
                ),
              ),
              onTap: () {
                setState(() {
                  type =
                      ShowPostsPage(userType); // 2 za institucije 1 za admine
                  isActive1 = true;
                  isActive2 = false;
                  isActive3 = false;
                  isActive4 = false;

                  isActive5 = false;
                });
              },
            ),
            new ListTile(
              leading: Container(
                width: 30,
                child: Icon(
                  FontAwesomeIcons.bell,
                  color: isActive2 ? Colors.green : Colors.grey,
                ),
              ),
              onTap: () {
                setState(() {
                  type = NewPost(userType);
                  isActive1 = false;
                  isActive2 = true;
                  isActive3 = false;
                  isActive4 = false;
                  isActive5 = false;
                });
              },
            ),
            new ListTile(
              leading: Container(
                width: 30,
                child: Icon(
                  FontAwesomeIcons.bookmark,
                  color: isActive3 ? Colors.green : Colors.grey,
                ),
              ),
              onTap: () {
                setState(() {
                  type = Saved(userType);
                  isActive1 = false;
                  isActive2 = false;
                  isActive3 = true;
                  isActive4 = false;
                  isActive5 = false;
                });
              },
            ),
            new ListTile(
              leading: Container(
                width: 30,
                child: Icon(
                  FontAwesomeIcons.university,
                  color: isActive4 ? Colors.green : Colors.grey,
                ),
              ),
              onTap: () {
                setState(() {
                  type = OneInstitution(loggedOrgID);
                  isActive1 = false;
                  isActive2 = false;
                  isActive3 = false;
                  isActive4 = true;
                  isActive5 = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
