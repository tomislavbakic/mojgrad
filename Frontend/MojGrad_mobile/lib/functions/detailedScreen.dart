import 'package:flutter/material.dart';

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
