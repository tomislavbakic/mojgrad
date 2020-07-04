import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fronend/config/loggedUserData.dart';
import 'package:fronend/screens/auth/singup.dart';
import 'package:fronend/screens/posts/newPostPage.dart';
import 'package:fronend/screens/routes/HomePage.dart';
import 'package:fronend/screens/routes/notifications.dart' as not;
import 'package:fronend/screens/routes/searchPage.dart';
import 'package:fronend/screens/routes/userProfilPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fronend/services/api.services.user.dart';
import 'package:provider/provider.dart';
import 'config/config.dart';
import 'functions/loadingScreen.dart';
import 'screens/auth/login.dart';

final storage = FlutterSecureStorage();
void main() => runApp(ChangeNotifierProvider<ThemeModel>(
    create: (BuildContext context) => ThemeModel(), child: MyApp()));
//global
String globalJWT;

class MyApp extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";

    var payload = json.decode(
        ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1]))));

    if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
        .isAfter(DateTime.now())) {
      LoggedUser.id = int.parse(payload['nameid']);

      LoggedUser.data =
          await APIServicesUsers.fetchUserDataByID(jwt, LoggedUser.id);

      if (LoggedUser.data == null) {
        storage.delete(key: "jwt");
        return "";
      } else {
        globalJWT = jwt;
        return jwt;
      }
    } else
      return "";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MojGrad',
      theme: Provider.of<ThemeModel>(context).currentTheme,
      routes: {
        '/home': (BuildContext context) => new HomePage.fromBase64(globalJWT),
        '/newPost': (BuildContext context) => new NewPost(),
        '/notifications': (BuildContext context) =>
            new not.NotificationsPage(), //
        '/profile': (BuildContext context) => new UserProfile(),
        '/search': (BuildContext context) => new SearchPage(),
        '/singup': (BuildContext context) => new SingUp(),
        '/login': (BuildContext context) => new Login()
      }, // home: Login(),
      home: FutureBuilder(
        future: jwtOrEmpty,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingScreen();
          }
          if (snapshot.data != "") {
            var str = snapshot.data;
            var jwt = str.split(".");
            if (jwt.length != 3) {
              return Login();
            } else {
              var payload = json.decode(
                  ascii.decode(base64.decode(base64.normalize(jwt[1]))));
              if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
                  .isAfter(DateTime.now())) {
                if (LoggedUser.data == null) {
                  return Login();
                } else
                  return HomePage.city(cityID: LoggedUser.data.cityID);
              } else {
                return Login();
              }
            }
          } else {
            return Login();
          }
        },
      ),
    );
  }
}
