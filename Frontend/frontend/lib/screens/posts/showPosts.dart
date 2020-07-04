import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fronend/config/config.dart';
import 'package:fronend/config/config.error.dart';
import 'package:fronend/config/loggedUserData.dart';
import 'package:fronend/functions/detailedScreen.dart';
import 'package:fronend/functions/successfulActionDialog.dart';
import 'package:fronend/main.dart';
import 'package:fronend/models/view/postInfo.dart';
import 'package:fronend/screens/posts/commentPage.dart';
import 'package:fronend/screens/posts/flutter_map.dart';
import 'package:fronend/screens/posts/moreOption.dart';
import 'package:fronend/screens/posts/showLikes.dart';
import 'package:fronend/screens/routes/userProfilPage.dart';
import 'package:fronend/services/api.services.posts.dart';
import 'package:fronend/services/api.services.user.dart';

Color boja = Colors.green;

class ShowPosts extends StatefulWidget {
  @override
  _ShowPostsState createState() => _ShowPostsState();
  List<PostInfo> posts = List<PostInfo>();
  ShowPosts(allPosts) {
    posts = allPosts;
  }
}

class _ShowPostsState extends State<ShowPosts> {
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: widget.posts.length,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return _buildPosts(context, widget.posts[index]);
        },
      ),
    );
  }

  Widget _buildPosts(BuildContext context, PostInfo post) {
    return Card(
      elevation: 7.0,
      //shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(top: 8.0, left: 15, right: 15),
        child: makeFeed(
          userID: post.userID,
          userName: "${post.fullname}",
          userImage: wwwrootURL + post.userPhoto,
          feedText: "${post.description}",
          feedTime: "${post.time}",
          ago: "${post.ago}",
          feedImage: post.postImage != "" ? wwwrootURL + post.postImage : "",
          userLocation: "${post.address}",
          likes: "${post.likesNumber.toString()}",
          comments: "${post.commentsNumber.toString()}",
          category: "${post.categoryName.toString()}",
          title: "${post.title.toString()}",
          postID: post.id,
          isLiked: post.isLiked,
          isActive: post.isActive,
          post: post,
        ),
      ),
    );
  }

  Widget makeFeed({
    userID,
    postID,
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
    isActive,
    post,
    ago,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
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
                          image: NetworkImage(userImage), fit: BoxFit.fill),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: InkWell(
                          child: Text(
                            userName,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1),
                          ),
                          onTap: () async {
                            UserProfile.user =
                                await APIServicesUsers.fetchUserDataByID(
                                    globalJWT, userID);

                            Navigator.of(context).pushNamed("/profile");
                          },
                        ),
                      ),
                      SizedBox(height: 3),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              //      width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                userLocation + " ",
                                style:
                                    TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                            ),
                            Text(
                              ago + " ",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              (LoggedUser.id == userID)
                  ? buildOptionsForLoggedUser(context, postID)
                  : buildOptionsForOtherUsers(context, postID, userID)
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 17, height: 1.5, letterSpacing: .7),
          ),
          SizedBox(
            height: 5,
          ),
          feedImage != ''
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return DetailScreen(
                          feedImage, feedTime.toString(), postID);
                    }));
                  },
                  child: Hero(
                    tag: 'imageHero$postID' + feedImage + feedTime.toString(),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            image: NetworkImage(feedImage), fit: BoxFit.cover),
                      ),
                    ),
                  ),
                )
              : Container(),
          SizedBox(
            height: 3,
          ),
          Text(
            category,
            style: TextStyle(
                fontSize: 15, color: Colors.grey, fontStyle: FontStyle.italic),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  makeLikeButton(post),
                  //makeLike(postID, context),
                  SizedBox(width: 2),
                  InkWell(
                    onTap: () async {
                      var x = await APIServicesPosts.fetchPostByID(
                          globalJWT, postID);
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowLikes(postID)));
                      }
                    },
                    child: Text(
                      likes,
                      style: TextStyle(fontSize: 17, color: Colors.grey),
                    ),
                  ),

                  SizedBox(width: 10),
                  makeComment(),
                  SizedBox(width: 5),
                  Text(
                    comments,
                    style: TextStyle(fontSize: 17, color: Colors.grey),
                  ),
                  makeLocationButtonDialog(
                      context, post.latitude, post.longitude, postID),
                ],
              ),
              (category != 'Lepša strana grada')
                  ? makeChallengeButton(context, postID, isActive, userID, post)
                  : makeCommentButton(context, postID, isActive, post),
            ],
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget makeLikeButton(PostInfo post) {
    return IconButton(
      icon: Icon(
        FontAwesomeIcons.leaf,
        size: 20,
      ),
      color: post.isLiked ? BOJA : Colors.grey,
      onPressed: () async {
        var x =
            await APIServicesPosts.likePost(globalJWT, post.id, LoggedUser.id);
        if (x == false) {
          showDialog(
            context: context,
            builder: (context) {
              return SuccessfulActionDialog(
                  deletedPostErrorTitle, deletedPostErrorMSG);
            },
            barrierDismissible: false,
          );
        } else {
          setState(
            () {
              post.setLike = post.isLiked == true ? false : true;
              post.setLikesNum = post.isLiked == true ? 1 : -1;
            },
          );
        }
      },
    );
  }

  Widget makeCommentButton(
      BuildContext context, int postID, bool isActive, PostInfo post) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          color: Colors.green,
          child: Icon(FontAwesomeIcons.comment, color: Colors.white, size: 15),
          onPressed: () async {
            //go to post view page with comments
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
              goToCommentPage(context, postID, post);
            }
          },
        ),
        SizedBox(
          width: 5,
        )
      ],
    );
  }

  Widget makeChallengeButton(BuildContext context, int postID, bool isActive,
      int userID, PostInfo post) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          color: isActive == true ? Colors.green : Colors.blue,
          child: isActive == true
              ? (userID != LoggedUser.id
                  ? Text("UČESTVUJTE",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold))
                  : Text("Pogledajte rešenja",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)))
              : Text("REŠENO",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
          onPressed: () async {
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
              goToCommentPage(context, postID, post);
            }
          },
        ),
        SizedBox(width: 5)
      ],
    );
  }

  Widget goToCommentPage(BuildContext context, int postID, PostInfo post) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => CommentPage(postID)))
        .then((value) {
      setState(() {
        post.likesNumber = int.parse(value['likesNumber']);
        post.commentsNumber = int.parse(value['commentNumber']);
        post.setLike = value['isLiked'];
        post.setActivity = value['isActive'];
      });
    });
  }

  Widget makeRateButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.star,
                color: Colors.grey,
                //   color: Colors.teal,
                size: 20.0,
              ),
              onPressed: () {},
            ),
            SizedBox(
              width: 5,
            )
          ],
        ),
      ),
    );
  }

  Widget makeComment() {
    return Container(
      width: 20,
      height: 25,
      child: Center(
        child: Icon(
          FontAwesomeIcons.comment,
          color: Colors.grey,
          size: 18.0,
        ),
      ),
    );
  }

  Widget makeLike(postID, context) {
    return Container(
      width: 35,
      height: 35,
      child: Center(
        child: IconButton(
          icon: Icon(FontAwesomeIcons.leaf),
          color: boja,
          iconSize: 18.0,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ShowLikes(postID)));
          },
        ),
      ),
    );
  }

  Widget makeLocationButtonDialog(
      BuildContext context, double _latitude, double _longitude, int postID) {
    return IconButton(
        icon: Icon(Icons.location_on),
        color: Colors.red,
        iconSize: 28,
        onPressed: () async {
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowOnMap(_latitude, _longitude)));
          }
        });
  }
}
