import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webproject/config/configuration.dart';
import 'package:webproject/functions/loadingDialog.dart';
import 'package:webproject/functions/readMore.dart';
import 'package:webproject/main.dart';
import 'package:webproject/models/view/postInfo.dart';
import 'package:webproject/services/api.services.posts.dart';
import 'package:webproject/services/token.session.dart';
import 'package:webproject/posts/showCommentsAndSolutions.dart';

class Saved extends StatefulWidget {
  int type;
  Saved(int value) {
    this.type = value;
  }

  @override
  _SavedState createState() => _SavedState(type);
}

class _SavedState extends State<Saved> {
  int type;
  _SavedState(int value) {
    this.type = value;
  }

  final ScrollController controller = ScrollController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white24,
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
                child: FutureBuilder(
                  future: APIServicesPosts.getAllSavedPostsByOrgID(
                      Token.getToken, loggedOrgID),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<PostInfo>> snapshot) {
                    if (!snapshot.hasData)
                      return Container(
                          color: Colors.white,
                          child: Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              )),
                          height: 10);

                    if (snapshot.data.length == 0) {
                      return Container(
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            "Nemate sačuvane objave.",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        PostInfo post = snapshot.data[index];
                        return postListView(context, post);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget postListView(BuildContext contextt, PostInfo post) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
      child: makeFeed(
        userName: "${post.fullname}",
        userImage: wwwrootURL + post.userPhoto,
        feedText: "${post.description}",
        feedTime: "${post.time}",
        feedImage: post.postImage != "" ? wwwrootURL + post.postImage : "",
        userLocation: "${post.address}",
        likes: "${post.likesNumber.toString()}",
        comments: "${post.commentsNumber.toString()}",
        category: "${post.categoryName.toString()}",
        title: "${post.title.toString()}",
        postID: post.id,
        dan: post.time.substring(8, 10),
        mesec: post.time.substring(5, 7),
        godina: post.time.substring(0, 4),
      ),
    );
  }

  Widget makeFeed(
      {postID,
      userName,
      userImage,
      feedTime,
      feedText,
      feedImage,
      userLocation,
      likes,
      comments,
      category,
      title,
      isLiked,
      dan,
      mesec,
      godina}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
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
                          image: NetworkImage(userImage), fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
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
                      SizedBox(
                        height: 3,
                      ),
                      Row(children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Text(
                            userLocation +
                                ", dana " +
                                dan +
                                "." +
                                mesec +
                                "." +
                                godina +
                                "." +
                                " u " +
                                feedTime.substring(11, 16),
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ),
                      ])
                    ],
                  ),
                ],
              ),
              //userType == 2
              //?
              // UKLONI IZ SAČUVANIH
              Container(
                width: 80,
                child: RaisedButton(
                  //iconSize: 25.0,
                  onPressed: () async {
                    Dialogs.showLoadingDialog(context, _keyLoader);
                    await APIServicesPosts.deleteSavedPost(
                        Token.getToken, loggedOrgID, postID);
                    setState(() {
                      Navigator.of(_keyLoader.currentContext).pop();
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                  ),
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  color: Colors.grey[700],
                  child: Text(
                    "Ukloni",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
              // : Container()*/
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          SizedBox(
            height: 5.0,
          ),
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
                        : Text(""),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
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
                                  fit: BoxFit.fill),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(comments),
              IconButton(
                icon: Icon(FontAwesomeIcons.comment, color: Colors.grey[700]),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                      title: new Text("Komentari"),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      content: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 800,
                          child: ShowCommentsAndSolutions(postID, type)),
                    ),
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
