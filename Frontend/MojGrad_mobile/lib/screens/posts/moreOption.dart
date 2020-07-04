import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fronend/config/config.error.dart';
import 'package:fronend/config/loggedUserData.dart';
import 'package:fronend/functions/successfulActionDialog.dart';
import 'package:fronend/screens/posts/changePostData.dart';
import 'package:fronend/screens/routes/HomePage.dart';
import 'package:fronend/services/api.services.posts.dart';
import 'package:fronend/services/api.services.user.dart';
import 'package:fronend/functions/uploadingDialog.dart';
import '../../main.dart';

String reportText;

showAlertDialog(BuildContext context, postID) {
  Widget positive = FlatButton(
    child: Text("Da"),
    onPressed: () async {
      showDialog(
        context: context,
        builder: (context) {
          return LoadingDialog("Brisanje objave je u toku.");
        },
        barrierDismissible: false,
      );
      await APIServicesPosts.deletePostByID(globalJWT, postID);
      showDialog(
        context: context,
        builder: (context) {
          return SuccessfulActionDialog(
              "Uspešno", "Izmena profilne fotografije je uspešno obavljena.");
        },
        barrierDismissible: false,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage.city(cityID: LoggedUser.data.cityID),
        ),
      );
    },
  );
  Widget negative = FlatButton(
    child: Text("Ne"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Brisanje objave"),
    content: Text("Da li ste sigurni da želite da obrišete objavu?"),
    actions: <Widget>[
      positive,
      negative,
    ],
  );

  showDialog(context: context, child: alert);
}

Widget buildOptionsForLoggedUser(BuildContext context, int postID) {
  return PopupMenuButton<String>(
    padding: EdgeInsets.zero,

    icon: Icon(Icons.more_horiz, size: 25, color: Colors.grey[600]),
    //   onSelected: showMenuSelection,
    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'change',
        child: ListTile(
          leading: Icon(FontAwesomeIcons.pen),
          title: Text('Izmenite'),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChangePost(postID)));
          },
        ),
      ),
      PopupMenuItem<String>(
        value: 'delete',
        child: ListTile(
            leading: Icon(FontAwesomeIcons.eraser),
            title: Text('Obrišite'),
            onTap: () {
              showAlertDialog(context, postID);
            }),
      ),
    ],
  );
}

Widget buildOptionsForOtherUsers(
    BuildContext context, int postID, int postUserID) {
  return PopupMenuButton<String>(
    padding: EdgeInsets.zero,
    icon: Icon(Icons.more_horiz, size: 25, color: Colors.grey[600]),
    // onSelected: showMenuSelection,
    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'report',
        child: ListTile(
          leading: Icon(FontAwesomeIcons.exclamationCircle),
          title: Text('Prijavite objavu'),
          onTap: () async {
            var x = await APIServicesPosts.fetchPostByID(globalJWT, postID);
            if (x == null) {
              showDialog(
                context: context,
                builder: (context) {
                  return SuccessfulActionDialog(
                      deletedPostErrorTitle, deletedPostErrorMSG);
                },
                barrierDismissible: false,
              );
            } else {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => SimpleDialog(
                  contentPadding: EdgeInsets.all(20.0),
                  elevation: 5.0,
                  children: <Widget>[
                    Text("Prijavite objavu"),
                    TextField(
                      autofocus: false,
                      maxLines: null,
                      onChanged: (val) {
                        reportText = val;
                      },
                    ),
                    SizedBox(height: 10),
                    OutlineButton(
                      child: Text("Pošaljite prijavu"),
                      onPressed: () async {
                        await APIServicesPosts.reportPost(
                            globalJWT, reportText, postID, LoggedUser.id);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SuccessfulActionDialog(
                                "Uspešno", "Objava je uspešno prijavljena.");
                          },
                          barrierDismissible: false,
                        );
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      PopupMenuItem<String>(
        value: 'report',
        child: ListTile(
          leading: Icon(FontAwesomeIcons.userMinus),
          title: Text('Prijavite korisnika'),
          onTap: () async {
            var x = await APIServicesPosts.fetchPostByID(globalJWT, postID);
            if (x == null) {
              showDialog(
                context: context,
                builder: (context) {
                  return SuccessfulActionDialog(
                      deletedPostErrorTitle, deletedPostErrorMSG);
                },
                barrierDismissible: false,
              );
            } else {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => SimpleDialog(
                  contentPadding: EdgeInsets.all(20.0),
                  elevation: 5.0,
                  children: <Widget>[
                    Text("Prijavite korisnika"),
                    TextField(
                      autofocus: false,
                      maxLines: null,
                      onChanged: (val) {
                        reportText = val;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    OutlineButton(
                      child: Text("Pošaljite prijavu"),
                      onPressed: () async {
                        await APIServicesUsers.reportUser(
                            globalJWT, LoggedUser.id, postUserID, reportText);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SuccessfulActionDialog(
                                "Uspešno", "Korisnik je uspešno prijavljen.");
                          },
                          barrierDismissible: false,
                        );
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      )
    ],
  );
}

Widget buildOptionsForOtherUsersComment(
    BuildContext context, int commentID, int postID) {
  return PopupMenuButton<String>(
    padding: EdgeInsets.zero,
    icon: Icon(Icons.more_horiz, size: 30, color: Colors.grey[600]),
    // onSelected: showMenuSelection,
    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'report',
        child: ListTile(
          leading: Icon(FontAwesomeIcons.exclamationCircle),
          title: Text('Prijavite komentar'),
          onTap: () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => SimpleDialog(
                contentPadding: EdgeInsets.all(20.0),
                elevation: 5.0,
                children: <Widget>[
                  Text("Prijavite komentar"),
                  TextField(
                    autofocus: false,
                    maxLines: null,
                    onChanged: (val) {
                      reportText = val;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  OutlineButton(
                    child: Text("Pošaljite prijavu"),
                    onPressed: () async {
                      var res = await APIServicesPosts.reportComment(
                          globalJWT, reportText, commentID, LoggedUser.id);

                      Navigator.pop(context);
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SuccessfulActionDialog(
                              "Uspešno", "Komentar je uspešno prijavljen.");
                        },
                        barrierDismissible: false,
                      );
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                ],
              ),
            );
          },
        ),
      )
    ],
  );
}
