import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fronend/config/config.dart';
import 'package:fronend/config/loggedUserData.dart';
import 'package:fronend/functions/bottomNavigationBar.dart';
import 'package:fronend/functions/uploadingDialog.dart';
import 'package:fronend/main.dart';
import 'package:fronend/models/view/changePostModel.dart';
import 'package:fronend/models/view/postInfo.dart';
import 'package:fronend/screens/routes/HomePage.dart';
import 'package:fronend/services/api.services.posts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

Color boja = Colors.green;

class ChangePost extends StatefulWidget {
  int postID;
  ChangePost(int postID) {
    this.postID = postID;
  }

  @override
  _ChangePostState createState() => _ChangePostState();
}

class _ChangePostState extends State<ChangePost> {
  TextEditingController title = new TextEditingController();
  TextEditingController description = new TextEditingController();
  String path;
  File _image;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Izmenite objavu"),
          actions: <Widget>[
            buildChangeButton(context)
          ], //sa dozom sumnje, ovo radi
        ),
        body: buildBody(context),
        bottomNavigationBar: MyBottomNavigationBar(0),
      ),
    );
  }

  PostInfo post;
  Widget buildBody(BuildContext context) {
    return FutureBuilder(
        future: APIServicesPosts.fetchPostByID(globalJWT, widget.postID),
        builder: (BuildContext context, AsyncSnapshot<PostInfo> snapshot) {
          if (!snapshot.hasData)
            return CircularProgressIndicator();
          else {
            post = snapshot.data;

            title.text = post.title;
            description.text = post.description;
            path = post.postImage != null ? wwwrootURL + post.postImage : "";
            return buildPostData(context, post);
          }
        });
  }

  Widget buildPostData(context, PostInfo post) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            textFunction("Naslov"),
            TextField(
              controller: title,
            ),
            SizedBox(height: 20.0),
            textFunction("Opis"),
            TextField(
              controller: description,
              maxLines: null,
            ),
            SizedBox(height: 20.0),
            Center(
              child: Container(
                child: _image == null
                    ? Image.network(wwwrootURL + post.postImage)
                    : Image(image: FileImage(_image)),
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                    onPressed: getImageCamera,
                    tooltip: 'Napravite novu fotografiju',
                    icon: Icon(Icons.camera),
                    color: boja),
                IconButton(
                    onPressed: getImageGallery,
                    tooltip: 'Izaberite iz galerije',
                    icon: Icon(Icons.photo_library),
                    color: boja),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChangeButton(context) {
    return IconButton(
      icon: const Icon(Icons.check, size: 30),
      onPressed: () async {
        showDialog(
          context: context,
          builder: (context) {
            return LoadingDialog("Izmena objave je u toku.");
          },
          barrierDismissible: false,
        );

        DateTime now = DateTime.now();
        String fileName;
        String convertedDateTime;
        if (_image != null) {
          convertedDateTime =
              "${now.year.toString()}${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}${now.hour.toString()}-${now.minute.toString()}";

          fileName = LoggedUser.id.toString() +
              "_" +
              convertedDateTime +
              "_" +
              basename(_image.path);

          path = postServerPathImage + fileName;
        } else
          path = post.postImage;

        ChangePostModel updatedPost =
            new ChangePostModel(post.id, title.text, description.text, path);

        var res = await APIServicesPosts.updatePostData(
            globalJWT, updatedPost, _image, fileName);
        if (res == true) {
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      HomePage.city(cityID: LoggedUser.data.cityID)),
              (route) => false);
        } else {
          Navigator.pop(context);
          print("NIJE USPESNO");
          //mogao bi snak bar;
        }
      },
    );
  }

  Widget previewImage() {
    if (_image != null) {
      return Image.file(_image);
    } else {
      return Text("");
    }
  }

  //get image from the camera
  Future getImageCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
      path = null;
    });
  }

  //get image from device gallery
  Future getImageGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      path = null;
    });
  }

  Text textFunction(text) {
    return new Text(text,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 17.0,
          //  fontWeight: FontWeight.bold,
        ));
  }
}
