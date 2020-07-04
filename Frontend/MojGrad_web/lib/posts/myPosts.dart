import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webproject/config/configuration.dart';
import 'package:webproject/functions/readMore.dart';
import 'package:webproject/models/view/postInfo.dart';
import 'package:webproject/services/api.services.posts.dart';
import 'package:webproject/services/token.session.dart';

Widget show;
Widget likes;
//bool visibleLikes = false;
bool visibleComments = false;

class MyPosts extends StatefulWidget {
  String url;
  int userID;
  MyPosts(url, userID) {
    this.url = url;
    this.userID = userID;
  }
  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  final ScrollController controller = ScrollController();
  bool visibleLikes = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5.0, right: 20.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.all(10.0),
                color: Colors.grey[700],
                child: new Text(
                  'Nazad',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 5.0),
        Container(
          color: Colors.white24, // boja pozadine gde se prikazuju korisnici
          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
          child: FutureBuilder(
            future: APIServicesPosts.getAllUsersPostsByUserID(
                Token.getToken, widget.userID),
            builder:
                (BuildContext context, AsyncSnapshot<List<PostInfo>> snapshot) {
              if (!snapshot.hasData)
                return Container(
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    height: 10);
              return snapshot.data.length != 0
                  ? ListView.builder(
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        PostInfo post = snapshot.data[index];
                        return postListView(context, post);
                      },
                    )
                  : ListTile(
                      title: Text(
                          "Korisnik još uvek nije postavio nijednu objavu."));
            },
          ),
        ),
      ],
    );
  }

  Widget postListView(BuildContext contextt, PostInfo post) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10),
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
              IconButton(
                iconSize: 25.0,
                onPressed: () {
                  setState(
                    () {
                      APIServicesPosts.deletePostByID(Token.getToken, postID);
                    },
                  );
                },
                icon: Icon(
                  FontAwesomeIcons.trash,
                  color: Colors.grey[500],
                  size: 23.0,
                ),
              )
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          horizontalLine(),
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
                //crossAxisAlignment: CrossAxisAlignment.end,
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
        ],
      ),
    );
  }

  Widget horizontalLine() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
    );
  }
}
