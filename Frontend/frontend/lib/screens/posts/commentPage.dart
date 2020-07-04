import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fronend/config/config.dart';
import 'package:fronend/config/loggedUserData.dart';
import 'package:fronend/functions/bottomNavigationBar.dart';
import 'package:fronend/functions/detailedScreen.dart';
import 'package:fronend/functions/images.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fronend/functions/uploadingDialog.dart';
import 'package:fronend/models/comment.dart';
import 'package:fronend/models/postSolution.dart';
import 'package:fronend/models/view/commentInfo.dart';
import 'package:fronend/models/view/postInfo.dart';
import 'package:fronend/models/view/postSolutionInfo.dart';
import 'package:fronend/screens/posts/moreOption.dart';
import 'package:fronend/screens/posts/postAndCommentWidgets.dart';
import 'package:fronend/screens/posts/showLikes.dart';
import 'package:fronend/screens/routes/userProfilPage.dart';
import 'package:fronend/services/api.services.posts.dart';
import 'package:fronend/services/api.services.user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

import 'package:path/path.dart';
import '../../main.dart';
import 'package:fronend/config/config.error.dart';

Color boja = Colors.green;

class CommentPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  final int postID;
  CommentPage(this.postID);
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  String _fullName;
  String _feedTime;
  String _feedText;
  String _feedTitle;
  String _feedImage;
  String _feedLocation;
  String _totalLikes;
  String _totalComments;
  String _category;
  int _postID;
  double _latitude;
  double _longitude;
  bool _isLiked;
  String _userImage; // user psot image
  bool isLikedComment;
  bool isDislikedComment;
  int _postUserID;
  bool _isActive;
  bool loadImage = false;

  File _image;
  File _imageSolution;
  String solutionText = "";

  TextEditingController comment = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //getPostByID(CommentPage.postID);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        key: widget._scaffoldstate,
        //resizeToAvoidBottomPadding: false,
        appBar: buildAppBar(),
        body: WillPopScope(
          onWillPop: () {
            var data = new Map<String, dynamic>();
            data['likesNumber'] = _totalLikes;
            data['commentNumber'] = _totalComments;
            data['isLiked'] = _isLiked;
            data['isActive'] = _isActive;
            Navigator.pop(context, data);
            return new Future(() => false);
          },
          child: buildBody(context),
        ),
        bottomNavigationBar: MyBottomNavigationBar(0),
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      title: Text("Komentari"),
    );
  }

  Widget buildBody(context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildPost(context, screenSize),
          ],
        ),
      ),
    );
  }

  bool comm = false;
  bool solution = true;
  Widget _buildPost(BuildContext context, Size screenSize) {
    return Column(
      children: <Widget>[
        FutureBuilder(
          future: APIServicesPosts.fetchPostByID(globalJWT, widget.postID),
          builder: (BuildContext context, AsyncSnapshot<PostInfo> snapshot) {
            if (!snapshot.hasData)
              return Center(
                  child: Container(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator()));
            else {
              PostInfo _postInfo = snapshot.data;
              _isActive = _postInfo.isActive;
              _postID = _postInfo.id;
              _fullName = _postInfo.fullname;
              _feedTime = _postInfo.time;
              _feedText = _postInfo.description;
              _category = _postInfo.categoryName;
              _feedTitle = _postInfo.title;
              _feedImage = _postInfo.postImage != ""
                  ? wwwrootURL + _postInfo.postImage
                  : "";
              _totalLikes = _postInfo.likesNumber.toString();
              _totalComments = _postInfo.commentsNumber.toString();
              _latitude = _postInfo.latitude;
              _longitude = _postInfo.longitude;
              _isLiked = _postInfo.isLiked;
              _postUserID = _postInfo.userID;
              _feedLocation = "${_postInfo.address} , ${_postInfo.city}";
              _userImage = wwwrootURL + _postInfo.userPhoto;

              return Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: EdgeInsets.only(top: 8.0, left: 20, right: 20),
                    child: makeFeed(
                      userID: _postInfo.userID,
                      context: context,
                      postID: _postID,
                      userName: _fullName,
                      userImage: _userImage,
                      feedTime: _feedTime,
                      feedText: _feedText,
                      feedImage: _feedImage,
                      feedLocation: _feedLocation,
                      isLiked: _isLiked,
                      isActive: _isActive,
                    ),
                  ),
                  buildTextField(context, screenSize),
                  _category != 'Lepša strana grada'
                      ? Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      comm = false;
                                      solution = true;
                                    });
                                  },
                                  child: Text('Rešenja',
                                      style: TextStyle(
                                          color: solution == true
                                              ? Colors.green
                                              : Colors.grey)),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      comm = true;
                                      solution = false;
                                    });
                                  },
                                  child: Text(
                                    'Komentari',
                                    style: TextStyle(
                                        color: comm == true
                                            ? Colors.green
                                            : Colors.grey),
                                  ),
                                ),
                              ]))
                      : Container(),
                  _category == 'Lepša strana grada'
                      ? Container(
                          child: myCommentBody(),
                        )
                      : Container(
                          child: solution == true
                              ? mySolutionBody()
                              : myCommentBody(),
                        )
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget myCommentBody() {
    return FutureBuilder<List<CommentView>>(
      future: APIServicesPosts.getCommentsByPostID(globalJWT, widget.postID),
      builder:
          (BuildContext context, AsyncSnapshot<List<CommentView>> snapshot) {
        if (!snapshot.hasData)
          return Center(
              child: Container(
                  width: 50, height: 50, child: CircularProgressIndicator()));
        if (snapshot.data.length == 0) {
          return Column(
            children: [
              Container(
                child: Text("Nema komentara."),
              ),
              SizedBox(height: 50),
            ],
          );
        } else
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.length,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              CommentView comment = snapshot.data[index];
              return _buildComment(context, comment);
            },
          );
      },
    );
  }

  Widget mySolutionBody() {
    return FutureBuilder<List<PostSolutionInfo>>(
      future: APIServicesPosts.getAllSolutionByPostID(
          globalJWT, widget.postID, LoggedUser.id),
      builder: (BuildContext context,
          AsyncSnapshot<List<PostSolutionInfo>> snapshot) {
        if (!snapshot.hasData)
          return Center(
              child: Container(
                  width: 50, height: 50, child: CircularProgressIndicator()));
        if (snapshot.data.length == 0) {
          return Column(
            children: [
              Container(
                child: Text("Nema rešenja."),
              ),
              SizedBox(height: 50),
            ],
          );
        } else
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.length,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              PostSolutionInfo solution = snapshot.data[index];

              return _buildSolution(context, solution);
            },
          );
      },
    );
  }

  Widget buildTextField(context, Size screenSize) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              left: 5,
              right: 5,
              bottom: 10,
            ),
            width: MediaQuery.of(context).size.width * 0.7,
            child: KeyboardAvoider(
              child: TextField(
                autofocus: false,
                maxLines: null,
                controller: comment,
                decoration: InputDecoration(
                  hintText: "Komentarišite",
                  border: OutlineInputBorder(),
                  icon: Container(
                    height: 50.0,
                    child: Platform.isAndroid
                        ? FutureBuilder<void>(
                            future: retrieveLostData(),
                            builder: (BuildContext context,
                                AsyncSnapshot<void> snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return const Text(
                                    '',
                                    textAlign: TextAlign.center,
                                  );
                                case ConnectionState.done:
                                  return _previewImage();
                                default:
                                  if (snapshot.hasError) {
                                    return Text(
                                      'Fotografija: ${snapshot.error}}',
                                      textAlign: TextAlign.center,
                                    );
                                  } else {
                                    return const Text(
                                      '',
                                      textAlign: TextAlign.center,
                                    );
                                  }
                              }
                            },
                          )
                        : _previewImage,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
              icon: Icon(Icons.image, size: 30),
              color: boja,
              onPressed: getImageGallery),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, size: 30),
            color: boja,
            onPressed: () async {
              if (LoggedUser.data.isBlocked == true) {
                _showSnakBar(blockedAccountMSG);
              } else {
                if (comment.text != "") {
                  String path;
                  String fileName;
                  if (_image != null) {
                    DateTime now = DateTime.now();
                    String convertedDateTime =
                        "${now.year.toString()}${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}${now.hour.toString()}-${now.minute.toString()}";

                    fileName = LoggedUser.id.toString() +
                        "_" +
                        convertedDateTime +
                        "_" +
                        basename(_image.path);
                    uploadImageNew(_image, commentImageUploadURL, fileName);

                    path = commentServerPathImage + fileName;
                  } else {
                    path = null;
                  }
                  Comment newComm = new Comment(
                    comment.text,
                    widget.postID,
                    LoggedUser.id,
                    DateTime.now(),
                    path,
                  );
                  showDialog(
                    context: context,
                    builder: (context) {
                      return LoadingDialog("Postavljanje komentara je u toku.");
                    },
                    barrierDismissible: false,
                  );
                  var res = await APIServicesPosts.addNewComment(
                      globalJWT, newComm, _image, fileName);
                  if (res == true) {
                    APIServicesUsers.fetchUserDataByID(globalJWT, LoggedUser.id)
                        .then((value) {
                      LoggedUser.data = value;
                    });
                    setState(() {
                      _image = null;
                      comment.text = '';
                      Navigator.pop(context);
                    });
                  } else {
                    _showSnakBar(commentMSG);
                  }
                } else {
                  _showSnakBar("Tekst komentara nije unet.");
                }
              }
            },
          ),
        ],
      ),
    );
  }

  //kreira jedan komentar

  Widget _buildComment(BuildContext context, CommentView comment) {
    isLikedComment = comment.isLikedComment;
    isDislikedComment = comment.isDislikedComment;
    return Card(
      elevation: 7,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 10, bottom: 10),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image:
                                  NetworkImage(wwwrootURL + comment.userPhoto),
                              fit: BoxFit.fill),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: InkWell(
                          child: Text(
                            comment.fullName,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1),
                          ),
                          onTap: () async {
                            UserProfile.user =
                                await APIServicesUsers.fetchUserDataByID(
                                    globalJWT, comment.userCommentID);

                            Navigator.of(context).pushNamed("/profile");
                          },
                        ),
                      ),
                    ],
                  ),
                  (LoggedUser.id == comment.userCommentID)
                      ? buildOptionsForLoggedUserComment(
                          context, comment.id, _postID)
                      : buildOptionsForOtherUsersComment(
                          context, comment.id, _postID)
                ]),

            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 5.0, right: 20, bottom: 5),
              child: Text("${comment.text}",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 17, letterSpacing: 1)),
            ),
            //),
            comment.commentPhoto != null ? SizedBox(height: 5) : Container(),
            comment.commentPhoto != null
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return DetailScreen(wwwrootURL + comment.commentPhoto,
                            DateTime.now().toString(), comment.id);
                      }));
                    },
                    child: Center(
                      child: Container(
                        height: 200.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image:
                                NetworkImage(wwwrootURL + comment.commentPhoto),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      child: IconButton(
                        icon: Icon(FontAwesomeIcons.thumbsUp),
                        color: isLikedComment ? boja : Colors.grey,
                        onPressed: () {
                          setState(() {
                            APIServicesPosts.commentReaction(
                                globalJWT, comment.id, LoggedUser.id, 1);
                          });
                        },
                      ),
                    ),
                    Text(
                      comment.likesNumber.toString(),
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      child: IconButton(
                        icon: Icon(FontAwesomeIcons.thumbsDown),
                        color:
                            isDislikedComment ? Colors.red[900] : Colors.grey,
                        onPressed: () {
                          setState(() {
                            APIServicesPosts.commentReaction(
                                globalJWT, comment.id, LoggedUser.id, -1);
                          });
                        },
                      ),
                    ),
                    Text(
                      comment.dislikesNumber.toString(),
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSolution(BuildContext context, PostSolutionInfo solution) {
    isLikedComment = solution.isLikedComment;
    isDislikedComment = solution.isDislikedComment;

    return Card(
      color: solution.userType == 2 ? Colors.green[100] : null,
      elevation: 7,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10, bottom: 10),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image:
                                NetworkImage(wwwrootURL + solution.userPhoto),
                            fit: BoxFit.fill),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: InkWell(
                        child: Text(
                          solution.fullName,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1),
                        ),
                        onTap: () async {
                          print(solution.userSolutionID.toString() +
                              " SDSADASDASDA");
                          UserProfile.user =
                              await APIServicesUsers.fetchUserDataByID(
                                  globalJWT, solution.userSolutionID);

                          Navigator.of(context).pushNamed("/profile");
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 5.0, right: 20, bottom: 5),
              child: Text("${solution.text}",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 17, letterSpacing: 1)),
            ),
            //),
            SizedBox(height: 5),
            solution.solutionPhoto != null
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return DetailScreen(wwwrootURL + solution.solutionPhoto,
                            DateTime.now().toString(), solution.id);
                      }));
                    },
                    child: Center(
                      child: Container(
                        height: 250.0,
                        // width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image: NetworkImage(
                                wwwrootURL + solution.solutionPhoto),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),

            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _category != "Lepša strana grada"
                    ? LoggedUser.id == _postUserID
                        ? _isActive == true
                            ? awkwardSolution(context, solution)
                            : awkwardClosed(context, solution)
                        : awkwardClosedOtherView(context, solution)
                    : Container(
                        child: SizedBox(width: 170.0),
                      ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      child: IconButton(
                        icon: Icon(FontAwesomeIcons.thumbsUp),
                        color: isLikedComment ? boja : Colors.grey,
                        onPressed: () {
                          APIServicesPosts.solutionReaction(
                                  globalJWT, solution.id, LoggedUser.id, 1)
                              .then((value) {
                            setState(() {
                              print(value);
                            });
                          });
                        },
                      ),
                    ),
                    Text(
                      solution.likesNumber.toString(),
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      child: IconButton(
                        icon: Icon(FontAwesomeIcons.thumbsDown),
                        color:
                            isDislikedComment ? Colors.red[900] : Colors.grey,
                        onPressed: () {
                          APIServicesPosts.solutionReaction(
                                  globalJWT, solution.id, LoggedUser.id, -1)
                              .then((value) {
                            setState(() {});
                          });
                        },
                      ),
                    ),
                    Text(
                      solution.dislikesNumber.toString(),
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget awkwardClosed(context, PostSolutionInfo comment) {
    if (comment.isAwarded == true) {
      return Container(
        child: FlatButton(
          child: Text(
            "Nagrađeno!",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
          ),
          color: Colors.green,
          onPressed: () {},
        ),
      );
    } else {
      return Container(
        child: SizedBox(width: 170.0),
      );
    }
  }

  Widget awkwardClosedOtherView(context, PostSolutionInfo comment) {
    if (comment.isAwarded == true) {
      return Container(
        child: FlatButton(
          child: Text(
            "Nagrađeno!",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
          ),
          color: Colors.green,
          onPressed: () {},
        ),
      );
    } else {
      return Container(
        child: SizedBox(width: 170.0),
      );
    }
  }

  //AWKWARD BEST SOLUTION
  Widget awkwardSolution(context, PostSolutionInfo comment) {
    if (comment.isAwarded == true) {
      return Row(
        children: <Widget>[
          Container(
            child: FlatButton(
              child: Text(
                "Nagrađeno!",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800),
              ),
              color: Colors.green,
              onPressed: () {},
            ),
          ),
          SizedBox(width: 30.0),
        ],
      );
    }

    return Container(
      child: FlatButton(
        child: Text(
          "Nagradite rešenje!",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
        ),
        color: Colors.blue,
        onPressed: () async {
          showAlertDialogPrise(context, _postID, comment.id, comment.fullName);
        },
      ),
    );
  }

  //deo za post.....

  Widget makeFeed({
    userID,
    context,
    postID,
    userName,
    userImage,
    feedTime,
    feedText,
    feedImage,
    feedLocation,
    isLiked,
    isActive,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
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
                      SizedBox(
                        height: 3,
                      ),
                      Row(children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            feedTime.substring(11, 16) + ", " + feedLocation,
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ),
                      ])
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
            feedText == null ? "" : feedText,
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
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          image: NetworkImage(feedImage), fit: BoxFit.fill),
                    ),
                  ),
                )
              : Container(),
          SizedBox(
            height: 3,
          ),
          Text(
            _category,
            style: TextStyle(
                fontSize: 15, color: Colors.grey, fontStyle: FontStyle.italic),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  makeLikeButton(postID, isLiked),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowLikes(postID)));
                    },
                    child: Text(
                      _totalLikes,
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  makeComment(),
                  SizedBox(width: 5),
                  Text(
                    _totalComments,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(width: 12.0),
                ],
              ),
              _category != "Lepša strana grada"
                  ? LoggedUser.id == _postUserID
                      ? _isActive == true
                          ? makeCloseChallange(context)
                          : closedChallange()
                      : challangeOtherUserView(context, _isActive)
                  : Text(""),
              makeLocationButton(context, _latitude, _longitude),
            ],
          ),
          SizedBox(height: 10)
        ],
      ),
    );
  }

  Widget closedChallange() {
    return Container(
        child: FlatButton(
      child: Text(
        "Izazov zatvoren!",
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
      color: Colors.blue,
      onPressed: () {
        //no implementation
      },
    ));
  }

  Widget challangeOtherUserView(context, bool isActive) {
    if (isActive == false) {
      return Container(
        child: FlatButton(
          child: Text(
            "Izazov zatvoren!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          color: Colors.redAccent,
          onPressed: () async {},
        ),
      );
    } else {
      return Container(
        child: FlatButton(
          child: Text(
            "Rešite problem",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          color: Colors.blue,
          onPressed: () async {
            if (LoggedUser.data.isBlocked == false) {
              showDialog(
                context: context,
                builder: (_) => new AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  content: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextField(
                            autofocus: false,
                            onChanged: (val) {
                              solutionText = val;
                            },
                            decoration: InputDecoration(
                              hintText: "Opis rešenja",
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Unesite fotografiju",
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 16),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.photo_library,
                                    color: Colors.green),
                                onPressed: getImageGallerySolution,
                              ),
                              IconButton(
                                icon: Icon(Icons.photo_camera,
                                    color: Colors.green),
                                onPressed: getImageCameraSolution,
                              ),
                            ],
                          ),
                          SizedBox(height: 5.0),
                          loadImage == true
                              ? Center(
                                  child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Text("Slika je učitana.")),
                                )
                              : Container(),
                          SizedBox(height: 5.0),
                          RaisedButton(
                              elevation: 2,
                              onPressed: () async {
                                if (solutionText == "" ||
                                    _imageSolution == null) {
                                  _showSnakBar(descriptionAndPictureMissingMSG);
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return LoadingDialog(
                                          "Postavljanje rešenja je u toku.");
                                    },
                                    barrierDismissible: false,
                                  );
                                  DateTime now = DateTime.now();
                                  String convertedDateTime =
                                      "${now.year.toString()}${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}${now.hour.toString()}-${now.minute.toString()}";

                                  String fileName = LoggedUser.id.toString() +
                                      "_" +
                                      convertedDateTime +
                                      "_" +
                                      basename(_imageSolution.path);

                                  PostSolution ps = PostSolution(
                                      solutionText,
                                      widget.postID,
                                      LoggedUser.id,
                                      postSolutionPathImage + fileName);

                                  setState(
                                    () {
                                      APIServicesPosts.addPostSolution(
                                              globalJWT,
                                              ps,
                                              _imageSolution,
                                              fileName)
                                          .then(
                                        (value) {
                                          if (value == true) {
                                            //showSnakBar
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            _showSnakBarGreen(
                                                "Uspešno postavljanje rešenja.");
                                          }
                                        },
                                      );
                                    },
                                  );
                                }
                              },
                              child: Text(
                                'Potvrdite',
                                style: TextStyle(color: Colors.white),
                              ),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              color: Colors.green),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              _showSnakBar(blockedAccountMSG);
            }
          },
        ),
      );
    }
  }

  Widget makeCloseChallange(context) {
    return Container(
      child: FlatButton(
        child: Text(
          "Zatvorite izazov!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        color: Colors.blue,
        onPressed: () {
          showAlertDialogChallange(context, _postID);
        },
      ),
    );
  }

  Widget makeLikeButton(postID, isLiked) {
    return IconButton(
      icon: Icon(
        FontAwesomeIcons.leaf,
        size: 19,
      ),
      color: isLiked ? boja : Colors.grey,
      onPressed: () async {
        var res =
            await APIServicesPosts.likePost(globalJWT, postID, LoggedUser.id);
        setState(
          () {
            print(res);
          },
        );
      },
    );
  }

  void _showSnakBar(String msg) {
    widget._scaffoldstate.currentState.showSnackBar(
      new SnackBar(
        content: new Text(msg),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
        elevation: 7.0,
      ),
    );
  }

  void _showSnakBarGreen(String msg) {
    widget._scaffoldstate.currentState.showSnackBar(
      new SnackBar(
        content: new Text(msg),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        elevation: 7.0,
      ),
    );
  }

  showAlertDialogChallange(BuildContext context, postID) {
    Widget positive = FlatButton(
      child: Text("Da"),
      onPressed: () async {
        //zatvaranje izazova
        await APIServicesPosts.closeChallange(globalJWT, postID);
        setState(() {
          print("Post je zatvoren");
        });
        Navigator.of(context).pop();
      },
    );
    Widget negative = FlatButton(
      child: Text("Ne"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Zatvaranje izazova"),
      content: Text("Da li ste sigurni da želite da zatvorite izazov?"),
      actions: <Widget>[
        positive,
        negative,
      ],
    );
    showDialog(context: context, child: alert);
  }

  Widget buildOptionsForLoggedUserComment(
      BuildContext context, int commentID, int postID) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,

      icon: Icon(Icons.more_horiz, size: 30, color: Colors.grey[600]),
      //   onSelected: showMenuSelection,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: Icon(FontAwesomeIcons.eraser),
            title: Text('Obrišite'),
            onTap: () async {
              showDialog(
                context: context,
                builder: (context) {
                  return LoadingDialog("Brisanje komentara je u toku.");
                },
                barrierDismissible: false,
              );
              await APIServicesPosts.deleteCommentByID(globalJWT, commentID);
              Navigator.pop(context);
              setState(
                () {
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  showCommentAlertDialog(BuildContext context, commentID, postID) {
    Widget positive = FlatButton(
      child: Text("Da"),
      onPressed: () async {
        showDialog(
          context: context,
          builder: (context) {
            return LoadingDialog("Brisanje komentara je u toku.");
          },
          barrierDismissible: false,
        );
        setState(
          () {
            APIServicesPosts.deleteCommentByID(globalJWT, commentID)
                .then((value) {
              Navigator.of(context).pop();
            });
          },
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
      title: Text("Brisanje komentara"),
      content: Text("Da li ste sigurni da želite da obrišete komentar?"),
      actions: <Widget>[
        positive,
        negative,
      ],
    );

    showDialog(context: context, child: alert);
  }

  showAlertDialogPrise(
      BuildContext context, int postID, int commentID, String userName) {
    Widget positive = FlatButton(
      child: Text("Da"),
      onPressed: () async {
        //zatvaranje izazova
        await APIServicesPosts.rewardUser(globalJWT, commentID);

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CommentPage(postID)));
      },
    );
    Widget negative = FlatButton(
      child: Text("Ne"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Nagrađivanje korisnika"),
      content: Text(
          "Da li ste sigurni da želite da nagradite korisnika?\n$userName"),
      actions: <Widget>[
        positive,
        negative,
      ],
    );
    showDialog(context: context, child: alert);
  }

  //get image from device gallery
  Future getImageGallery() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  Future getImageCamera() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  Future getImageGallerySolution() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _imageSolution = image;
      loadImage = true;
    });
  }

  Future getImageCameraSolution() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _imageSolution = image;
      loadImage = true;
    });
  }

  //retrieve the lost data
  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = response.file;
      });
    }
  }

  //widget for image preview
  Widget _previewImage() {
    if (_image != null) {
      return Image.file(_image);
    } else {
      return Text("");
    }
  }

  Widget _previewImageSolution() {
    if (_imageSolution != null) {
      setState(() {
        return Image.file(
          _imageSolution,
        );
      });
    } else {
      return Text("");
    }
  }
}
