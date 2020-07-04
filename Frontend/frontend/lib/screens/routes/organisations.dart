import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fronend/config/config.dart';
import 'package:fronend/config/loggedUserData.dart';
import 'package:fronend/models/view/postOrganisationView.dart';
import 'package:fronend/services/api.services.posts.dart';
import '../../main.dart';

Color boja = Colors.green;

class OrgPage extends StatefulWidget {
  @override
  _OrgPageState createState() => _OrgPageState();
}

class _OrgPageState extends State<OrgPage> {
  bool isLikedPost;
  bool isDislikedPost;
  @override
  Widget build(BuildContext context) {
    return Scaffold( body: buildBody());
  }

  Widget buildBody() {
    return Container(
      child: FutureBuilder<List<PostOrgView>>(
        future: APIServicesPosts.getAllOrganisationsPosts(globalJWT),
        builder:
            (BuildContext context, AsyncSnapshot<List<PostOrgView>> snapshot) {
          if (!snapshot.hasData)
            return Center(
                child: Container(
                    width: 50, height: 50, child: CircularProgressIndicator()));
          return ListView.builder(
            itemCount: snapshot.data.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              PostOrgView post = snapshot.data[index];
              return _buildPosts(context, snapshot.data[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildPosts(BuildContext contextt, PostOrgView post) {
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
        padding: EdgeInsets.only(top: 5.0, left: 25, right: 25),
        child: buildOrganisationsPost(
          organisationID: post.organisationID,
          organisationName: "${post.name}",
          organisationImage: wwwrootURL + post.organisationPhoto,
          postText: "${post.text}",
          postTime: "${post.time}",
          postImage: post.imagePath != "" ? wwwrootURL + post.imagePath : "",
          postOrganisationID: post.postID,
          likesNumber: post.likesNumber,
          dislikesNumber: post.dislikesNumber,
          isLiked: post.isLiked,
          isDisliked: post.isDisliked,
        ),
      ),
    );
  }

  Widget buildOrganisationsPost({
    organisationID,
    postOrganisationID,
    organisationName,
    organisationImage,
    postText,
    postTime,
    postImage,
    likesNumber,
    dislikesNumber,
    isLiked,
    isDisliked,
  }) {
    isLikedPost = isLiked;
    isDislikedPost = isDisliked;
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
                          image: NetworkImage(organisationImage),
                          fit: BoxFit.fill),
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
                            organisationName,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1),
                          ),
                          onTap: () async {},
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Row(children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            postTime.substring(11, 16),
                            style: TextStyle(fontSize: 13,),
                          ),
                        ),
                      ])
                    ],
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            postText,
            style: TextStyle(
                fontSize: 17,
                height: 1.5,
                letterSpacing: .7),
          ),
          SizedBox(
            height: 5,
          ),
          postImage != ''
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return DetailScreen(
                          postImage, postTime.toString(), postOrganisationID);
                    }));
                  },
                  child: Hero(
                    tag: 'imageHero$postOrganisationID' +
                        postImage +
                        postTime.toString(),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            image: NetworkImage(postImage), fit: BoxFit.cover),
                      ),
                    ),
                  ),
                )
              : Container(),
          SizedBox(
            height: 3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    child: IconButton(
                      icon: Icon(FontAwesomeIcons.thumbsUp),
                      color: isLikedPost ? boja : Colors.grey,
                      onPressed: () async {
                        await APIServicesPosts.orgPostReaction(
                            globalJWT, postOrganisationID, LoggedUser.id, 1);
                        setState(
                          () {},
                        );
                      },
                    ),
                  ),
                  Text(
                    likesNumber.toString(),
                    style: TextStyle(fontSize: 15,),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    child: IconButton(
                      icon: Icon(FontAwesomeIcons.thumbsDown),
                      color: isDislikedPost ? Colors.red[900] : Colors.grey,
                      onPressed: () async {
                        await APIServicesPosts.orgPostReaction(
                            globalJWT, postOrganisationID, LoggedUser.id, -1);
                        setState(
                          () {},
                        );
                      },
                    ),
                  ),
                  Text(
                    dislikesNumber.toString(),
                    style: TextStyle(fontSize: 15,),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  String photo;
  String time;
  int postID;

  DetailScreen(String photo, String time, int post) {
    this.photo = photo;
    this.time = time;
    this.postID = post;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero$postID' + photo + time,
            child: Image.network(
              photo,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
