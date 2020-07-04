import 'package:flutter/material.dart';
import 'package:fronend/config/config.dart';
import 'package:fronend/functions/bottomNavigationBar.dart';
import 'package:fronend/main.dart';
import 'package:fronend/models/view/userLikeList.dart';
import 'package:fronend/services/api.services.posts.dart';

class ShowLikes extends StatefulWidget {
  int idPost;

  ShowLikes(idPost) {
    this.idPost = idPost;
  }

  @override
  _ShowLikesState createState() => _ShowLikesState();
}

class _ShowLikesState extends State<ShowLikes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      bottomNavigationBar: MyBottomNavigationBar(0),
    );
  }

  buildBody() {
    return Container(
      child: FutureBuilder<List<UserLike>>(
        future: APIServicesPosts.getUsersWhoLikedPost(globalJWT, widget.idPost),
        builder:
            (BuildContext context, AsyncSnapshot<List<UserLike>> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView.builder(
            itemCount: snapshot.data.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              UserLike like = snapshot.data[index];
              return buildListOfUsers(context, snapshot.data[index]);
            },
          );
        },
      ),
    );
  }

  buildListOfUsers(BuildContext context, UserLike data) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 30.0,
            height: 30.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(wwwrootURL + data.photo),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(80.0),
              border: Border.all(
                color: Colors.white,
                // width: 5.0,
              ),
            ),
          ),
          SizedBox(width: 20.0,),
          Text(data.name + " "  + data.lastname),
        ],
      ),
    );
  }

  buildAppBar() {
    return AppBar(
      title: Text("Sviđanja"),
    );
  }
}
