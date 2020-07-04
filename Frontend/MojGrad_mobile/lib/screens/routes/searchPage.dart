import 'package:flutter/material.dart';
import 'package:fronend/config/config.dart';
import 'package:fronend/functions/bottomNavigationBar.dart';
import 'package:fronend/main.dart';
import 'package:fronend/screens/routes/userProfilPage.dart';
import 'package:fronend/models/view/userInfo.dart';
import 'package:fronend/services/api.services.user.dart';
import '../../models/view/userInfo.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<UserInfo> users = List();
  List<UserInfo> filteredUsers = List();
  String search = "A";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: PreferredSize(
          child: buildAppBar(),
          preferredSize: Size.fromHeight(120),
        ),
        body: buildSearchedUser(search),
        bottomNavigationBar: MyBottomNavigationBar(3),
      ),
    );
  }

  Widget buildAppBar() {
    return Container(
      padding: EdgeInsets.only(top: 30),
      margin: EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width,
      child: Material(
        color: Colors.grey[200],
        elevation: 3.0,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        child: TextField(
          onChanged: (string) {
            setState(
              () {
                search = string;
                buildSearchedUser(search);
              },
            );
          },
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            counterStyle: TextStyle(fontSize: 15.0),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            hintText: 'Pretraga',
            hintStyle: TextStyle(color: Colors.grey[600]),
            suffixIcon: Icon(
              Icons.search,
              color: Colors.grey[600],
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget buildSearchedUser(search) {
    return Container(
      child: FutureBuilder<List<UserInfo>>(
        future: APIServicesUsers.getSearchedUsed(globalJWT, search),
        builder:
            (BuildContext context, AsyncSnapshot<List<UserInfo>> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: Container(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            );
          if (snapshot.data.length == 0) {
            return Container(
              padding: EdgeInsets.only(
                  top: 20, left: MediaQuery.of(context).size.width * 0.25),
              child: Text("Nije pronađen nijedan korisnik."),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              UserInfo user = snapshot.data[index];
              return buildUser(context, user);
            },
          );
        },
      ),
    );
  }

  Widget buildUser(context, UserInfo user) {
    return Container(
      child: userList(
          fullname: "${user.name}" + " " + "${user.lastname}",
          rankName: "${user.rankName}",
          imagePath: "${user.photo}",
          userId: user.id),
    );
  }

  Widget userList({
    userId,
    imagePath,
    fullname,
    rankName,
  }) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          UserProfile.user =
              await APIServicesUsers.fetchUserDataByID(globalJWT, userId);

          Navigator.of(context).pushNamed("/profile");
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(wwwrootURL +
                imagePath), // ovo treba -> image: NetworkImage(wwwrootURL + user.photo),
          ),
          title:
              Text(fullname, style: TextStyle(fontSize: 14)), // user.fullname
          subtitle:
              Text(rankName, style: TextStyle(fontSize: 12)), // user.username
        ),
      ),
    );
  }
}
