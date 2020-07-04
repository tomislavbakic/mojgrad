import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webproject/config/configuration.dart';
import 'package:webproject/models/view/blockedUser.dart';
import 'package:webproject/models/view/userInfo.dart';
import 'package:webproject/services/api.services.users.dart';
import 'package:webproject/services/token.session.dart';
import 'package:webproject/users/mobile/allUsers.dart';
import 'package:flutter/foundation.dart';
import 'oneUser.dart';

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer(this.milliseconds);

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class ShowUsersPage extends StatefulWidget {
  @override
  _ShowUsersPageState createState() => _ShowUsersPageState();
}

class _ShowUsersPageState extends State<ShowUsersPage> {
  final ScrollController controller = ScrollController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  // NAKON KOLIKO SEKUNDI SE PRIKAZUJE PROMENA PRI PRETRAZI
  final _debouncer = Debouncer(200);

  List<UserInfo> users = List();
  List<UserInfo> filteredUsers = List();

  List<BlockedUser> blockedUsers = List();
  List<BlockedUser> filteredBlockedUsers = List();

  @override
  void initState() {
    super.initState();
    APIServicesUsers.fetchAllUsers(Token.getToken).then(
      (usersFromServer) {
        if (!mounted) return;
        setState(
          () {
            users = usersFromServer;
            filteredUsers = users;
          },
        );
      },
    );

    APIServicesUsers.fetchBlockedUsers(Token.getToken).then(
      (blockedUsersFromServer) {
        if (!mounted) return;
        setState(
          () {
            blockedUsers = blockedUsersFromServer;
            filteredBlockedUsers = blockedUsers;
          },
        );
      },
    );
  }

  Widget allUsers = ShowAllUsers();

  @override
  Widget build(BuildContext context) {
    {
      return Expanded(
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.grey,
          ),
          debugShowCheckedModeBanner: false,
          home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: AppBar(
                  backgroundColor: Colors.green,
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Svi korisnici",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1),
                          ),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Blokirani korisnici",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              body: TabBarView(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 15.0),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Material(
                          elevation: 3.0,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          child: TextField(
                            onChanged: (string) {
                              _debouncer.run(
                                () {
                                  setState(
                                    () {
                                      filteredUsers = users
                                          .where((u) => (u.fullname
                                              .toLowerCase()
                                              .contains(string.toLowerCase())))
                                          .toList();
                                    },
                                  );
                                },
                              );
                            },
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              counterStyle: TextStyle(fontSize: 15.0),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              hintText: 'Pretraga',
                              suffixIcon: Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 11.0),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.all(10.0),
                          itemCount: filteredUsers.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Card(
                                elevation: 3,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OneUserContent(
                                              filteredUsers[index].id)),
                                    );
                                  },
                                  leading: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Row(children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(right: 10),
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: NetworkImage(wwwrootURL +
                                                  filteredUsers[index].photo),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: Text(
                                          filteredUsers[index].fullname,
                                        ),
                                      ),
                                    ]),
                                  ),
                                  title: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    child: Text(
                                      filteredUsers[index].eko.toString() +
                                          " EKO poena",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  trailing: IconButton(
                                    iconSize: 20.0,
                                    onPressed: () async {
                                      /*Dialogs.showLoadingDialog(
                                          context, _keyLoader);*/
                                      setState(() {
                                        showAlertDialog(
                                            context, filteredUsers[index].id);
                                      });
                                      /*await APIServicesUsers.deleteUserByID(
                                          Token.getToken,
                                          filteredUsers[index].id);
                                      APIServicesUsers.fetchAllUsers(
                                              Token.getToken)
                                          .then(
                                        (usersFromServer) {
                                          if (!mounted) return;
                                          setState(
                                            () {
                                              users = usersFromServer;
                                              filteredUsers = users;
                                            },
                                          );
                                        },
                                      );*/
                                    }, // AKCIJA OBRISI KORISNIKA IZ SISTEMA
                                    icon: Icon(
                                      FontAwesomeIcons.trash,
                                      color: Colors.grey,
                                      //size: 10.0,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  // ODAVDE KRECU BLOKIRANI
                  Column(
                    children: [
                      SizedBox(height: 15.0),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          child: TextField(
                            onChanged: (string) {
                              _debouncer.run(
                                () {
                                  setState(
                                    () {
                                      filteredBlockedUsers = blockedUsers
                                          .where(
                                            (u) => (u.fullname
                                                .toLowerCase()
                                                .contains(
                                                    string.toLowerCase())),
                                          )
                                          .toList();
                                    },
                                  );
                                },
                              );
                            },
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              counterStyle: TextStyle(fontSize: 15.0),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              hintText: 'Pretraga',
                              suffixIcon: Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 11.0),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.all(10.0),
                          itemCount: filteredBlockedUsers.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(left: 10.0, right: 10.0),
                              child: Card(
                                elevation: 3,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OneUserContent(
                                            filteredBlockedUsers[index].id),
                                      ),
                                    );
                                  },
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(wwwrootURL +
                                              filteredBlockedUsers[index]
                                                  .photo),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  title: Text(
                                      filteredBlockedUsers[index].fullname),
                                  /*Container(
                                    /*width:
                                        MediaQuery.of(context).size.width * 0.3,*/
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(filteredBlockedUsers[index]
                                            .fullname),
                                        Expanded(
                                          flex: 1,
                                          child: FlatButton(
                                              child: new Text(
                                                'Odblokiraj',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.red),
                                              ),
                                              onPressed: () async {
                                                Dialogs.showLoadingDialog(
                                                    context, _keyLoader);
                                                await APIServicesUsers
                                                    .unblockUser(
                                                        Token.getToken,
                                                        filteredBlockedUsers[
                                                                index]
                                                            .id);

                                                setState(() {
                                                  Navigator.of(_keyLoader
                                                          .currentContext)
                                                      .pop();
                                                  /*Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ShowUsersPage()));*/
                                                  //APIServicesUsers.unblockUser(Token.getToken, user.id);
                                                });
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),*/
                                  // OVDE BI MOŽDA TREBALO DA STOJI OPCIJA ODBLOKIRAJ
                                  trailing: IconButton(
                                    iconSize: 20.0,
                                    onPressed: () async {
                                      setState(() {
                                        showAlertDialogForBlocked(context,
                                            filteredBlockedUsers[index].id);
                                      });
                                      /*await APIServicesUsers.deleteUserByID(
                                          Token.getToken,
                                          filteredUsers[index].id);
                                      APIServicesUsers.fetchBlockedUsers(
                                              Token.getToken)
                                          .then(
                                        (blockedUsersFromServer) {
                                          if (!mounted) return;
                                          setState(
                                            () {
                                              blockedUsers =
                                                  blockedUsersFromServer;
                                              filteredBlockedUsers =
                                                  blockedUsers;
                                            },
                                          );
                                        },
                                      );*/
                                    },
                                    icon: Icon(
                                      FontAwesomeIcons.trash,
                                      color: Colors.grey,
                                      //size: 10.0,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  showAlertDialog(BuildContext context, userID) {
    Widget accept = FlatButton(
      child: Text("Da"),
      onPressed: () async {
        await APIServicesUsers.deleteUserByID(Token.getToken, userID);
        APIServicesUsers.fetchAllUsers(Token.getToken).then(
          (usersFromServer) {
            if (!mounted) return;
            setState(
              () {
                users = usersFromServer;
                filteredUsers = users;
                //Navigator.of(_keyLoader.currentContext).pop();
              },
            );
          },
        );
        setState(() {});
        Navigator.of(context, rootNavigator: true).pop(true);
      },
    );
    Widget decline = FlatButton(
      child: Text("Ne"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop(true);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Brisanje korisnika"),
      content: Text("Da li ste sigurni da želite da obrišete korisnika?"),
      actions: <Widget>[
        accept,
        decline,
      ],
    );

    showDialog(context: context, child: alert);
  }

  showAlertDialogForBlocked(BuildContext context, userID) {
    Widget accept = FlatButton(
      child: Text("Da"),
      onPressed: () async {
        await APIServicesUsers.deleteUserByID(Token.getToken, userID);
        APIServicesUsers.fetchBlockedUsers(Token.getToken).then(
          (blockedUsersFromServer) {
            if (!mounted) return;
            setState(
              () {
                blockedUsers = blockedUsersFromServer;
                filteredBlockedUsers = blockedUsers;
              },
            );
          },
        );

        setState(() {});
        Navigator.of(context, rootNavigator: true).pop(true);
      },
    );

    Widget decline = FlatButton(
      child: Text("Ne"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop(true);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Brisanje korisnika"),
      content: Text("Da li ste sigurni da želite da obrišete korisnika?"),
      actions: <Widget>[
        accept,
        decline,
      ],
    );

    showDialog(context: context, child: alert);
  }
}
