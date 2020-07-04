import 'package:flutter/material.dart';
import 'package:webproject/config/configuration.dart';
import 'package:webproject/models/view/userLikeList.dart';
import 'package:webproject/services/token.session.dart';

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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 500,
            child: buildBody(),
          ),
        ],
      ),
    );
  }

  buildBody() {
    return Card(
      child: FutureBuilder<List<UserLike>>(
        future: UserLike.getUsersWhoLikedPost(Token.getToken, widget.idPost),
        builder:
            (BuildContext context, AsyncSnapshot<List<UserLike>> snapshot) {
          if (!snapshot.hasData)
            return Container(
              child: Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.grey[50]),
                  )),
              width: 10,
              padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
              /*height: 30*/
            );

          return ListView.builder(
            itemCount: snapshot.data.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              UserLike like = snapshot.data[index];
              print(like.toMap().toString());
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 30.0,
            height: 30.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(wwwrootURL + data.photo),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            data.name + " " + data.lastname,
            style: TextStyle(letterSpacing: 1, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
