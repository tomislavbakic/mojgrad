import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fronend/config/config.dart';
import 'package:fronend/functions/bottomNavigationBar.dart';
import 'package:fronend/functions/sideMenu.dart';
import 'package:fronend/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fronend/models/view/postInfo.dart';
import 'package:fronend/models/view/postSolutionInfo.dart';
import 'package:fronend/models/view/userInfo.dart';
import 'package:fronend/screens/posts/commentPage.dart';
import 'package:fronend/screens/posts/showPosts.dart';
import 'package:fronend/services/api.services.posts.dart';

Color boja = Colors.green;

class UserProfile extends StatefulWidget {
  static UserInfo user;
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: buildAppBar(),
        body: buildBody(),
        endDrawer: MySideMenu(),
        bottomNavigationBar: MyBottomNavigationBar(4),
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      title: Text("Profil"),
    );
  }

  //user data for profile page

  final String _fullName =
      UserProfile.user.name + " " + UserProfile.user.lastname;
  final String _email = UserProfile.user.email;
  final String _posts = UserProfile.user.postsNumber.toString();
  final String _comments = UserProfile.user.commentsNumber.toString();
  final String _eko = UserProfile.user.eko.toString();
  final String _rank = UserProfile.user.rankName;
  final NetworkImage _imageUser =
      new NetworkImage(wwwrootURL + UserProfile.user.photo);

  final NetworkImage _rankImage =
      new NetworkImage(wwwrootURL + UserProfile.user.rankImage);

  bool _existAwardedSolution = false;
  Widget buildBody() {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
        children: <Widget>[
        Stack(
          children: <Widget>[
            _buildCoverImage(screenSize),
            Container(
              child: SingleChildScrollView(
                // scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    _buildProfileImage(),
                    SizedBox(height: 10.0),
                    _buildFullName(),
                    SizedBox(height: 10.0),
                    _buildUsername(context),
                   
                   
                  ],
                ),
              ),
            )
          ],
        ),
         Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10.0),
                          _buildStatContainer(),
                          SizedBox(height: 10.0),
                          // _buildButtons(),
                          //_buildButtonsLogout(),
                          SizedBox(height: 10.0),
                          UserProfile.user.commentsNumber > 0
                              ? buildAwardedComments(screenSize, context)
                              : SizedBox(height: 0),
                          SizedBox(height: 10.0),
                          myBody(),
                        ],
                      ),
                    )
      ]),
    );
  }

  Widget buildAwardedComments(screenSize, context) {
    return Container(
      height: 220,
      width: screenSize.width,
      child: FutureBuilder(
        future: APIServicesPosts.getAwardedSolutionsForUser(
            globalJWT, UserProfile.user.id),
        builder: (BuildContext context,
            AsyncSnapshot<List<PostSolutionInfo>> snapshot) {
          if (!snapshot.hasData)
            return Center(
                child: Container(
                    width: 40, height: 40, child: CircularProgressIndicator()));
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              PostSolutionInfo solution = snapshot.data[index];
              return buildOneSolution(context, solution);
            },
          );
        },
      ),
    );
  }

  //buildOneComment(context, CommentView comment)
  Widget buildOneSolution(context, PostSolutionInfo solution) {
    _existAwardedSolution = true;
    return Container(
      padding: EdgeInsets.all(2),
      width: MediaQuery.of(context).size.width * 0.6,
      child: Card(
        elevation: 3,
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //NE BRISATI OVO ZAKOMENTARISANO TOMISLAVE
              /*   ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 50.0),
                child: ReadMoreText(
                  solution.text,
                  trimLines: 2,
                  colorClickableText: Colors.red,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: " ...pogledajte više",
                  trimExpandedText: ' pogledajte manje ',
                ),
              ), */

              solution.solutionPhoto != null
                  ? Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            image: NetworkImage(
                                wwwrootURL + solution.solutionPhoto),
                            fit: BoxFit.cover),
                      ),
                    )
                  : Container(),
              /* Container(
                padding: EdgeInsets.all(3.0),
                child: solution.solutionPhoto != null
                    ? Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Image(
                            image: NetworkImage(
                                wwwrootURL + solution.solutionPhoto),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(),
              ), */
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: <Widget>[
                          makeCommentsLike(), //pravi ikonicu za lajk
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            solution.likesNumber.toString(),
                            style: TextStyle(
                                fontSize: 15,),
                          ),
                        ],
                      )),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      color: Colors.blueGrey[300],
                      child: Text(
                        'Prikažite objavu',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentPage(solution.postID),
                          ),
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget makeCommentsLike() {
    return Container(
      width: 35,
      height: 35,
      child: Center(
        child: Icon(FontAwesomeIcons.leaf, color: boja, size: 18),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: _imageUser,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            // width: 5.0,
          ),
        ),
      ),
    );
  }

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.6,
      width: double.maxFinite,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: _imageUser,
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            alignment: Alignment.center,
            color: Colors.black.withOpacity(0.3),
            child: Text(
              "",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullName() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        _fullName,
        style: TextStyle(
          color: Colors.white,
          fontSize: 28.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildUsername(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        UserProfile.user.cityName,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      //   color: Colors.grey[850],
      fontSize: 16.0,
      fontWeight: FontWeight.w300,
    );

    TextStyle _statCountTextStyle = TextStyle(
      //  color: Colors.grey[850],
      fontSize: 24.0,
      fontWeight: FontWeight.w300,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: _statCountTextStyle,
        ),
        Text(
          label,
          style: _statLabelTextStyle,
        ),
      ],
    );
  }

  Widget _buildRank(String label, String count) {
 
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: 25,
          backgroundImage: _rankImage,
          backgroundColor: Colors.grey[200],
        ),
        SizedBox(height: 5,),
        Text(
          label,
         // style: _statLabelTextStyle,
        ),
      ],
    );
  }

  Widget _buildStatContainer() {
    return Container(
      height: 140.0,
      margin: EdgeInsets.only(top: 8.0),
      //  decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildStatItem("Broj objava", _posts),
              _buildStatItem("Nagrađena rešenja", _comments),
              _buildStatItem("EKO poeni", _eko),
            ],
          ),
          SizedBox(height: 20),
          _buildRank(_rank, _eko)
        ],
      ),
    );
  }

  Widget myBody() {
    return Container(
      child: FutureBuilder<List<PostInfo>>(
        //call posts by user ID
        future: APIServicesPosts.getAllUsersPostsByUserID(
            globalJWT, UserProfile.user.id),
        builder:
            (BuildContext context, AsyncSnapshot<List<PostInfo>> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          if (snapshot.data.length == 0)
            return Container(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Text("Korisnik nema objava."),
                  )
                ],
              ),
            );
          return ShowPosts(snapshot.data);
        },
      ),
    );
  }
}
