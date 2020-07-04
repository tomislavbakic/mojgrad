import 'package:flutter/material.dart';
import 'package:webproject/models/view/blockedUser.dart';
import 'package:webproject/services/api.services.users.dart';
import 'package:webproject/services/token.session.dart';
import 'package:webproject/users/mobile/userListView.dart';

class ShowBlockedUsers extends StatefulWidget {
  @override
  _ListBlockedUsersState createState() => _ListBlockedUsersState();
}

class _ListBlockedUsersState extends State<ShowBlockedUsers> {
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10.0),
        child: ListView(
          controller: controller,
          children: <Widget>[
            new FutureBuilder(
              future: APIServicesUsers.fetchBlockedUsers(Token.getToken),
              builder: (BuildContext context,
                  AsyncSnapshot<List<BlockedUser>> snapshot) {
                if (!snapshot.hasData)
                  return Container(
                      child: Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator()),
                      width: 100,
                      height: 100);
                if (snapshot.data.length == 0) {
                  return Container(
                    padding: EdgeInsets.all(30.0),
                    child: Text("Nema blokiranih korisnika."),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    BlockedUser user = snapshot.data[index];
                    return UserListView(user);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
