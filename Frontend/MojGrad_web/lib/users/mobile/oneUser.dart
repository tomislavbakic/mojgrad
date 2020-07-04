import 'package:flutter/material.dart';
import 'package:webproject/config/configuration.dart';
import 'package:webproject/functions/loadingDialog.dart';
import 'package:webproject/functions/myTextStyle.dart';
import 'package:webproject/models/view/userInfo.dart';
import 'package:webproject/services/api.services.users.dart';
import 'package:webproject/services/token.session.dart';
import 'package:webproject/posts/myPosts.dart';
import 'package:webproject/users/mobile/showUsers.dart';

Color textColor = Colors.grey;
Color colorFix = Colors.grey;
Color backgroundColor = Colors.white;
Color colorMaterial = Colors.red;
FontWeight fontWeightFix = FontWeight.w300;
FontWeight fontWeight = FontWeight.bold;
int fontSize = 17;
int fontSizeMaterial = 15;

class OneUserContent extends StatefulWidget {
  int userID;

  OneUserContent(userID) {
    this.userID = userID;
  }

  @override
  _OneUserContentState createState() => _OneUserContentState();
}

class _OneUserContentState extends State<OneUserContent> {
  final ScrollController controller = ScrollController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Container(
          child: FutureBuilder(
            future:
                APIServicesUsers.fetchUserByID(Token.getToken, widget.userID),
            builder: (BuildContext context, AsyncSnapshot<UserInfo> snapshot) {
              if (!snapshot.hasData)
                return Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    ),
                    width: 100,
                    height: 100);
              else {
                UserInfo user = snapshot.data;
                return oneUser(context, user);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget oneUser(BuildContext context, UserInfo user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.green,
            boxShadow: [
              BoxShadow(
                blurRadius: 5.0,
                spreadRadius: 3.0,
                color: Colors.grey,
                offset: Offset(3.0, 3.0),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                child: new Text(
                  'Prikaži objave',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyPosts(postURL, widget.userID)),
                  );
                },
              ),
              user.isBlocked == false
                  ? FlatButton(
                      child: new Text(
                        'Blokiraj korisnika',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      onPressed: () async {
                        Dialogs.showLoadingDialog(context, _keyLoader);
                        await APIServicesUsers.blockUser(
                            Token.getToken, user.id);
                        setState(() {
                          Navigator.of(_keyLoader.currentContext).pop();
                        });
                      })
                  : FlatButton(
                      child: new Text(
                        'Odblokiraj korisnika',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      onPressed: () async {
                        Dialogs.showLoadingDialog(context, _keyLoader);
                        await APIServicesUsers.unblockUser(
                            Token.getToken, user.id);
                        setState(() {
                          Navigator.of(_keyLoader.currentContext).pop();
                        });
                      }),
              FlatButton(
                child: new Text(
                  'Izbriši korisnika',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: () async {
                  Dialogs.showLoadingDialog(context, _keyLoader);
                  await APIServicesUsers.deleteUserByID(
                      Token.getToken, user.id);
                  setState(() {
                    Navigator.of(_keyLoader.currentContext).pop();
                    //Navigator.pop(context);
                    Navigator.of(context).pushReplacement(
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return ShowUsersPage();
                    }));
                  });
                },
              ),
              FlatButton(
                child: new Text(
                  'Nazad',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: () {
                  //Navigator.pop(context);
                  Navigator.of(context).pushReplacement(
                      new MaterialPageRoute(builder: (BuildContext context) {
                    return ShowUsersPage();
                  }));
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 40.0),
              height: MediaQuery.of(context).size.width * 0.18,
              width: MediaQuery.of(context).size.width * 0.18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(wwwrootURL + user.photo),
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(
              width: 50,
            ),
            Container(
              padding: EdgeInsets.only(top: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  item('Ime: ', user.name + " " + user.lastname),
                  SizedBox(height: 10.0),
                  item('Kontakt', user.email),
                  SizedBox(height: 10.0),
                  item('Grad: ', user.cityName),
                  SizedBox(height: 10.0),
                  item('Eko poeni: ', user.eko.toString()),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        MyTextStyle('Rank: ', fontWeightFix, colorFix, 17),
                        SizedBox(width: 10),
                        Container(
                          child: Image.network(
                            wwwrootURL + user.rankImage,
                            height: 50,
                            width: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  item('Broj objava: ', user.postsNumber.toString()),
                  SizedBox(height: 10.0),
                  item('Broj komentara: ', user.commentsNumber.toString()),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 75,
        ),
        Container(
          //width: MediaQuery.of(context).size.width * 0.5,
          child: DataTable(columns: <DataColumn>[
            DataColumn(
              label: Text("Broj prijavljenih komentara"),
              numeric: false,
            ),
            DataColumn(
              label: Text("Broj prijavljenih objava"),
              numeric: false,
            ),
            DataColumn(
              label: Text("Broj prijava"),
              numeric: false,
            ),
            DataColumn(
              label: Text("Ukupno"),
              numeric: false,
            ),
          ], rows: <DataRow>[
            DataRow(cells: <DataCell>[
              DataCell(Text(user.commentReportsNumber.toString())),
              DataCell(Text(user.postReportsNumber.toString())),
              DataCell(Text(user.userReportsNumber.toString())),
              DataCell(Text(user.allReportsNumber.toString())),
            ])
          ]),
        ),
        SizedBox(height: 30.0),
      ],
    );
  }

  Widget item(String text1, String text2) {
    return Container(
      //width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      child: Row(
        children: <Widget>[
          MyTextStyle(text1, FontWeight.w300, Colors.grey, 18),
          SizedBox(width: 10),
          MyTextStyle(text2, FontWeight.bold, Colors.grey[800], 18),
        ],
      ),
    );
  }
}
