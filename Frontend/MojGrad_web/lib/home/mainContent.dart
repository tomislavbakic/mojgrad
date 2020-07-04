import 'package:flutter/material.dart';
import 'package:webproject/users/institution/institutions.dart';
import 'package:webproject/screens/feedbacks.dart';
import 'package:webproject/screens/ranks.dart';
import 'package:webproject/users/mobile/showUsers.dart';
import 'package:webproject/posts/showReportedComments.dart';
import 'package:webproject/screens/statistics.dart';
import 'package:webproject/posts/newPostInstituion.dart';
import 'package:webproject/posts/showPosts.dart';
import 'package:webproject/users/admins/addAdministrator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

bool isActive1 = true;
bool isActive2 = false;
bool isActive3 = false;
bool isActive4 = false;
bool isActive5 = false;
bool isActive6 = false;
bool isActive7 = false;
bool isActive8 = false;
bool isActive9 = false;

Widget type = ShowPostsPage(1);
int userType;

class MainContent extends StatefulWidget {
  MainContent(int value) {
    userType = value;
  }
  @override
  _MainContentState createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
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
          ),
          SizedBox(
            height: 10,
          ),
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
                    type = ShowPostsPage(userType);
                    isActive1 = true;
                    isActive2 = false;
                    isActive3 = false;
                    isActive4 = false;
                    isActive5 = false;
                    isActive6 = false;
                    isActive7 = false;
                    isActive8 = false;
                    isActive9 = false;
                  });
                },
              ),
              new ListTile(
                leading: Container(
                  width: 30,
                  child: Icon(
                    FontAwesomeIcons.comments,
                    color: isActive2 ? Colors.green : Colors.grey,
                  ),
                ),
                title: new Text(
                  'Prijavljeni komentari',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  setState(() {
                    type = ShowReportedCommentsPage();
                    isActive1 = false;
                    isActive2 = true;
                    isActive3 = false;
                    isActive4 = false;
                    isActive5 = false;
                    isActive6 = false;
                    isActive7 = false;
                    isActive8 = false;
                    isActive9 = false;
                  });
                },
              ),
              new ListTile(
                leading: Container(
                  width: 30,
                  child: Icon(
                    FontAwesomeIcons.users,
                    color: isActive3 ? Colors.green : Colors.grey,
                  ),
                ),
                title: new Text(
                  'Korisnici',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  setState(() {
                    type = ShowUsersPage();
                    isActive1 = false;
                    isActive2 = false;
                    isActive3 = true;
                    isActive4 = false;
                    isActive5 = false;
                    isActive6 = false;
                    isActive7 = false;
                    isActive8 = false;
                    isActive9 = false;
                  });
                },
              ),
              new ListTile(
                leading: Container(
                  width: 30,
                  child: Icon(
                    isActive4
                        ? FontAwesomeIcons.envelopeOpen
                        : FontAwesomeIcons.envelope,
                    color: isActive4 ? Colors.green : Colors.grey,
                  ),
                ),
                title: new Text(
                  'Utisci korisnika',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  setState(() {
                    type = FeedbackView();
                    isActive1 = false;
                    isActive2 = false;
                    isActive3 = false;
                    isActive4 = true;
                    isActive5 = false;
                    isActive6 = false;
                    isActive7 = false;
                    isActive8 = false;
                    isActive9 = false;
                  });
                },
              ),
              new ListTile(
                leading: Container(
                  width: 30,
                  child: Icon(
                    FontAwesomeIcons.bell,
                    color: isActive9 ? Colors.green : Colors.grey,
                  ),
                ),
                title: new Text(
                  'Obaveštenja institucija',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  setState(() {
                    type = NewPost(userType);
                    isActive1 = false;
                    isActive2 = false;
                    isActive3 = false;
                    isActive4 = false;
                    isActive5 = false;
                    isActive6 = false;
                    isActive7 = false;
                    isActive8 = false;
                    isActive9 = true;
                  });
                },
              ),
              new ListTile(
                leading: Icon(
                  FontAwesomeIcons.chartBar,
                  color: isActive5 ? Colors.green : Colors.grey,
                ),
                title: new Text(
                  'Statistika',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  setState(() {
                    type = Statistics();
                    isActive1 = false;
                    isActive2 = false;
                    isActive3 = false;
                    isActive4 = false;
                    isActive5 = true;
                    isActive6 = false;
                    isActive7 = false;
                    isActive8 = false;
                    isActive9 = false;
                  });
                },
              ),
              new ListTile(
                leading: Container(
                  width: 30,
                  child: Icon(
                    FontAwesomeIcons.user,
                    color: isActive6 ? Colors.green : Colors.grey,
                  ),
                ),
                title: new Text(
                  'Administratori',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  setState(() {
                    type = AddAdministrator();

                    isActive1 = false;
                    isActive2 = false;
                    isActive3 = false;
                    isActive4 = false;
                    isActive5 = false;
                    isActive6 = true;
                    isActive7 = false;
                    isActive8 = false;
                    isActive9 = false;
                  });
                },
              ),
              new ListTile(
                leading: Container(
                  width: 30,
                  child: Icon(
                    FontAwesomeIcons.usersCog,
                    color: isActive7 ? Colors.green : Colors.grey,
                  ),
                ),
                title: new Text(
                  'Institucije',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  setState(() {
                    type = Institutions();

                    isActive1 = false;
                    isActive2 = false;
                    isActive3 = false;
                    isActive4 = false;
                    isActive5 = false;
                    isActive6 = false;
                    isActive7 = true;
                    isActive8 = false;
                    isActive9 = false;
                  });
                },
              ),
              new ListTile(
                leading: Container(
                  width: 30,
                  child: Icon(
                    FontAwesomeIcons.gem,
                    color: isActive8 ? Colors.green : Colors.grey,
                  ),
                ),
                title: new Text(
                  'Nivoi',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  setState(() {
                    type = Ranks();

                    isActive1 = false;
                    isActive2 = false;
                    isActive3 = false;
                    isActive4 = false;
                    isActive5 = false;
                    isActive6 = false;
                    isActive7 = false;
                    isActive8 = true;
                    isActive9 = false;
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
                  type = ShowPostsPage(userType);
                  isActive1 = true;
                  isActive2 = false;
                  isActive3 = false;
                  isActive4 = false;
                  isActive5 = false;
                  isActive6 = false;
                  isActive7 = false;
                  isActive8 = false;
                  isActive9 = false;
                });
              },
            ),
            new ListTile(
              leading: Container(
                width: 30,
                child: Icon(
                  FontAwesomeIcons.comments,
                  color: isActive2 ? Colors.green : Colors.grey,
                ),
              ),
              onTap: () {
                setState(() {
                  type = ShowReportedCommentsPage();
                  isActive1 = false;
                  isActive2 = true;
                  isActive3 = false;
                  isActive4 = false;
                  isActive5 = false;
                  isActive6 = false;
                  isActive7 = false;
                  isActive8 = false;
                  isActive9 = false;
                });
              },
            ),
            new ListTile(
              leading: Container(
                width: 30,
                child: Icon(
                  FontAwesomeIcons.users,
                  color: isActive3 ? Colors.green : Colors.grey,
                ),
              ),
              onTap: () {
                setState(() {
                  type = ShowUsersPage();
                  isActive1 = false;
                  isActive2 = false;
                  isActive3 = true;
                  isActive4 = false;
                  isActive5 = false;
                  isActive6 = false;
                  isActive7 = false;
                  isActive8 = false;
                  isActive9 = false;
                });
              },
            ),
            new ListTile(
              leading: Container(
                width: 30,
                child: Icon(
                  isActive4
                      ? FontAwesomeIcons.envelopeOpen
                      : FontAwesomeIcons.envelope,
                  color: isActive4 ? Colors.green : Colors.grey,
                ),
              ),
              onTap: () {
                setState(() {
                  type = FeedbackView();
                  isActive1 = false;
                  isActive2 = false;
                  isActive3 = false;
                  isActive4 = true;
                  isActive5 = false;
                  isActive6 = false;
                  isActive7 = false;
                  isActive8 = false;
                  isActive9 = false;
                });
              },
            ),
            new ListTile(
              leading: Container(
                width: 30,
                child: Icon(
                  FontAwesomeIcons.bell,
                  color: isActive9 ? Colors.green : Colors.grey,
                ),
              ),
              onTap: () {
                setState(() {
                  type = NewPost(userType);
                  isActive1 = false;
                  isActive2 = false;
                  isActive3 = false;
                  isActive4 = false;
                  isActive5 = false;
                  isActive6 = false;
                  isActive7 = false;
                  isActive8 = false;
                  isActive9 = true;
                });
              },
            ),
            new ListTile(
              leading: Icon(
                FontAwesomeIcons.chartBar,
                color: isActive5 ? Colors.green : Colors.grey,
              ),
              onTap: () {
                setState(() {
                  type = Statistics();
                  isActive1 = false;
                  isActive2 = false;
                  isActive3 = false;
                  isActive4 = false;
                  isActive5 = true;
                  isActive6 = false;
                  isActive7 = false;
                  isActive8 = false;
                  isActive9 = false;
                });
              },
            ),
            new ListTile(
              leading: Container(
                width: 30,
                child: Icon(
                  FontAwesomeIcons.user,
                  color: isActive6 ? Colors.green : Colors.grey,
                ),
              ),
              onTap: () {
                setState(() {
                  type = AddAdministrator();

                  isActive1 = false;
                  isActive2 = false;
                  isActive3 = false;
                  isActive4 = false;
                  isActive5 = false;
                  isActive6 = true;
                  isActive7 = false;
                  isActive8 = false;
                  isActive9 = false;
                });
              },
            ),
            new ListTile(
              leading: Container(
                width: 30,
                child: Icon(
                  FontAwesomeIcons.usersCog,
                  color: isActive7 ? Colors.green : Colors.grey,
                ),
              ),
              onTap: () {
                setState(() {
                  type = Institutions();

                  isActive1 = false;
                  isActive2 = false;
                  isActive3 = false;
                  isActive4 = false;
                  isActive5 = false;
                  isActive6 = false;
                  isActive7 = true;
                  isActive8 = false;
                  isActive9 = false;
                });
              },
            ),
            new ListTile(
              leading: Container(
                width: 30,
                child: Icon(
                  FontAwesomeIcons.gem,
                  color: isActive8 ? Colors.green : Colors.grey,
                ),
              ),
              onTap: () {
                setState(() {
                  type = Ranks();

                  isActive1 = false;
                  isActive2 = false;
                  isActive3 = false;
                  isActive4 = false;
                  isActive5 = false;
                  isActive6 = false;
                  isActive7 = false;
                  isActive8 = true;
                  isActive9 = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
