import 'package:flutter/material.dart';
import 'package:webproject/config/configuration.dart';

class UserListView extends StatefulWidget {
  dynamic user;
  //dynamic blockedUser;

  UserListView(dynamic x) {
    this.user = x;
  }

  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: userList(widget.user, context),
    );
  }

  Widget userList(user, BuildContext context) {
    return ListTile(
      leading: Container(
        width: 300,
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(wwwrootURL + user.photo),
                    fit: BoxFit.cover),
              ),
            ),
            Text(
              user.fullname,
            ),
          ],
        ),
      ),
      trailing: Text(
        user.eko.toString() + " EKO poena",
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
    );
  }
}
