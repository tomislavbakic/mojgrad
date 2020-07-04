import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webproject/functions/readMore.dart';
import 'package:webproject/models/view/reportedComment.dart';
import 'package:webproject/models/view/postInfo.dart';
import 'package:webproject/services/api.services.posts.dart';
import 'package:webproject/services/api.services.users.dart';
import 'package:webproject/services/token.session.dart';
import 'package:webproject/config/configuration.dart';

class ShowReportedCommentsPage extends StatefulWidget {
  @override
  _ShowReportedCommentsPageState createState() =>
      _ShowReportedCommentsPageState();
}

class _ShowReportedCommentsPageState extends State<ShowReportedCommentsPage> {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: <Widget>[
          SizedBox(height: 5),
          Container(
            color: Colors.white24,
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
            child: FutureBuilder(
              future: APIServicesPosts.getAllReportedComment(Token.getToken),
              builder: (BuildContext context,
                  AsyncSnapshot<List<ReportedCommentView>> snapshot) {
                if (!snapshot.hasData)
                  return Container(
                    color: Colors.white,
                    child: Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.white),
                        )),
                    height: 10,
                  );
                if (snapshot.data.length == 0) {
                  return Center(child: Text("Nema prijavljenih komentara."));
                }
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      ReportedCommentView comment = snapshot.data[index];
                      return reportedCommentListView(context, comment);
                    });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPost(BuildContext context, int postID, text) {
    return FutureBuilder(
      future: APIServicesPosts.fetchPostByID(Token.getToken, postID),
      builder: (BuildContext context, AsyncSnapshot<PostInfo> snapshot) {
        if (!snapshot.hasData)
          return CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          );
        else {
          PostInfo post = snapshot.data;
          return postView(context, post, text);
        }
      },
    );
  }

  Widget reportedCommentListView(
      BuildContext context, ReportedCommentView comment) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10),
      child: makeFeed(
        description:
            comment.description != null ? "${comment.description}" : "",
        text: comment.commentText != null ? "${comment.commentText}" : "",
        photo: "${comment.commentPhoto}",
        commentID: comment.commentID,
        userName: "${comment.userFullname}",
        userID: comment.userDataID,
        isBlocked: comment.isBlocked,
        postID: comment.postID,
        comment: comment,
      ),
    );
  }

  Widget postView(BuildContext context, PostInfo post, text) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10),
      child: makeFeedPost(
        userName: "${post.fullname}",
        userImage: wwwrootURL + post.userPhoto,
        userLocation: "${post.address}",
        feedTime: "${post.time}",
        dan: post.time.substring(8, 10),
        mesec: post.time.substring(5, 7),
        godina: post.time.substring(0, 4),
        title: "${post.title.toString()}",
        feedText: "${post.description}",
        feedImage: post.postImage != "" ? wwwrootURL + post.postImage : "",
        text: text,
      ),
    );
  }

  Widget makeFeedPost(
      {userName,
      userImage,
      userLocation,
      feedTime,
      dan,
      mesec,
      godina,
      title,
      feedText,
      feedImage,
      text}) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(userImage), fit: BoxFit.cover)),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          userName,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1),
                        ),
                      ),
                      SizedBox(height: 3),
                      Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              userLocation +
                                  ", dana " +
                                  dan +
                                  "." +
                                  mesec +
                                  "." +
                                  godina +
                                  ". u " +
                                  feedTime.substring(11, 16),
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    title != 'null'
                        ? ReadMoreText(
                            title,
                            trimLength: 45,
                            trimCollapsedText: ' ...prikaži više',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                height: 1.5,
                                letterSpacing: .7),
                          )
                        : Text(''),
                    feedText != "null"
                        ? ReadMoreText(
                            feedText,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[800],
                                height: 1.5,
                                letterSpacing: .7),
                          )
                        : Text('')
                  ],
                ),
              ),
              SizedBox(width: 20),
              Column(
                children: [
                  feedImage != ''
                      ? Center(
                          child: Container(
                            height: 100,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(feedImage),
                                fit: (BoxFit.fill),
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              )
            ],
          ),
          SizedBox(height: 3),
          Row(
            children: [
              Container(
                child: Text(
                  text,
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget makeFeed(
      {reportID,
      description,
      text,
      photo,
      commentID,
      userName,
      userID,
      isBlocked,
      postID,
      comment}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text(
                    description,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text(
                    "„" + text + "“",
                    style: TextStyle(fontSize: 14),
                  ),
                )
              ],
            ),
          ),
          Container(
            child: RaisedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          content: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 250,
                              child: buildPost(context, postID, text)),
                        ));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
              ),
              color: Colors.white,
              child: Text(
                "Više",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 15,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            child: buildOptions(context, commentID, userID, isBlocked, comment),
          )
        ],
      ),
    );
  }

  Widget buildOptions(BuildContext context, int commentID, int userID,
      bool isBlocked, ReportedCommentView comment) {
    return PopupMenuButton<String>(
      tooltip: 'Opcije',
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert, size: 25, color: Colors.grey[600]),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: Icon(
              FontAwesomeIcons.trash,
              color: Colors.grey[500],
            ),
            title: Text("Ukloni komentar", style: TextStyle(fontSize: 14)),
            contentPadding: EdgeInsets.zero,
            onTap: () {
              showAlertDialogComment(context, commentID);
            },
          ),
        ),
        // NIJEE DOBRO !!!!!!
        // comment.isBlocked == true
        //     ? PopupMenuItem<String>(
        //         value: 'unblock',
        //         child: ListTile(
        //           leading: Icon(FontAwesomeIcons.check, color: Colors.green),
        //           title: Text("Odblokiraj korisnika",
        //               style: TextStyle(fontSize: 14)),
        //           contentPadding: EdgeInsets.zero,
        //           onTap: () {
        //             showAlertDialogUnblock(context, userID, comment);
        //           },
        //         ),
        //       )
        //     : PopupMenuItem<String>(
        //         value: 'block',
        //         child: ListTile(
        //           leading: Icon(FontAwesomeIcons.times, color: Colors.red),
        //           title: Text("Blokiraj korisnika",
        //               style: TextStyle(fontSize: 14)),
        //           contentPadding: EdgeInsets.zero,
        //           onTap: () {
        //             showAlertDialogBlock(context, userID, comment);
        //           },
        //         ),
        //       ),
      ],
    );
  }

  showAlertDialogUnblock(context, userID, ReportedCommentView comm) {
    Widget accept = FlatButton(
      child: Text("Da"),
      onPressed: () async {
        await APIServicesUsers.unblockUser(Token.getToken, userID);
        setState(
          () {
            comm.block = false;
          },
        );
        Navigator.of(context).pop();
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
      title: Text("Odblokiranje korisnika"),
      content: Text("Da li ste sigurni da želite da odblokirate korisnika?"),
      actions: <Widget>[
        accept,
        decline,
      ],
    );

    showDialog(context: context, child: alert);
  }

  showAlertDialogBlock(BuildContext context, userID, ReportedCommentView comm) {
    Widget accept = FlatButton(
      child: Text("Da"),
      onPressed: () async {
        await APIServicesUsers.blockUser(Token.getToken, userID);
        setState(
          () {
            comm.block = true;
          },
        );
        Navigator.pop(context);
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
      title: Text("Blokiranje korisnika"),
      content: Text("Da li ste sigurni da želite da blokirate korisnika?"),
      actions: <Widget>[
        accept,
        decline,
      ],
    );

    showDialog(context: context, child: alert);
  }

  showAlertDialogComment(BuildContext context, commentID) {
    Widget accept = FlatButton(
      child: Text("Da"),
      onPressed: () async {
        await APIServicesPosts.deleteCommentByID(Token.getToken, commentID);
        setState(
          () {
            Navigator.of(context).pop();
          },
        );
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
      title: Text("Brisanje komentara"),
      content: Text("Da li ste sigurni da želite da uklonite komentar?"),
      actions: <Widget>[
        accept,
        decline,
      ],
    );

    showDialog(context: context, child: alert);
  }
}
