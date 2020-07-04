import 'package:flutter/material.dart';
import 'package:webproject/models/view/userInfo.dart';
import 'package:webproject/services/api.services.users.dart';
import 'package:webproject/services/token.session.dart';
import 'package:webproject/users/mobile/userListView.dart';

class ShowBestUsers extends StatefulWidget {
  @override
  _ListBestUsersState createState() => _ListBestUsersState();
}

class _ListBestUsersState extends State<ShowBestUsers> {
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
              future: APIServicesUsers.fetchTopEkoUsersN(Token.getToken),
              builder: (BuildContext context,
                  AsyncSnapshot<List<UserInfo>> snapshot) {
                if (!snapshot.hasData)
                  return Container(
                      child: Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator()),
                      width: 100,
                      height: 100);
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    UserInfo user = snapshot.data[index];
                    return UserListView(user);
                  },
                );
              },
            ),
          ],
        ),
        //child: Text("blokirani"),
      ),
    );
  }
}
