import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webproject/config/configuration.dart';
import 'package:webproject/functions/loadingDialog.dart';
import 'package:webproject/functions/readMore.dart';
import 'package:webproject/main.dart';
import 'package:webproject/models/postOrg.dart';
import 'package:webproject/models/view/organisationView.dart';
import 'package:webproject/models/view/postOrgView.dart';
import 'package:webproject/services/api.services.org.dart';
import 'package:webproject/services/token.session.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:universal_html/prefer_universal/html.dart' as html;
import 'package:webproject/services/api.services.dart';
import 'package:webproject/config/config.error.dart';
import 'package:webproject/services/api.services.posts.dart';

class NewPost extends StatefulWidget {
  int userType;
  NewPost(int userType) {
    this.userType = userType;
  }

  @override
  _NewPostState createState() => _NewPostState(userType);
}

class _NewPostState extends State<NewPost> {
  int userType;
  _NewPostState(int userType) {
    this.userType = userType;
  }
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  TextEditingController _postDescription = new TextEditingController();
  String name = '';
  String error = '';
  String errorMSG = '';
  Uint8List data;
  OrganisationView org;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        width: MediaQuery.of(context).size.width * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            userType != 1
                ? getOrgData()
                : Container(
                    height: 3,
                  ),
            buildBody(),
          ],
        ),
      ),
    );
  }

  Widget getOrgData() {
    return Container(
      child: FutureBuilder<OrganisationView>(
        future: APIServicesOrg.getOrganisationsDataByID(
            Token.getToken, loggedOrgID),
        builder:
            (BuildContext context, AsyncSnapshot<OrganisationView> snapshot) {
          if (snapshot.hasData) {
            org = snapshot.data;
            return buildNewPost(context, org);
          }
          return Container();
        },
      ),
    );
  }

  Widget buildBody() {
    return Container(
      child: FutureBuilder<List<PostOrgView>>(
        future: APIServicesOrg.getAllOrganisationsPosts(Token.getToken),
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
              return _buildOrganisationPosts(context, post);
            },
          );
        },
      ),
    );
  }

  Widget _buildOrganisationPosts(BuildContext context, PostOrgView post) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10),
      child: buildOrganisationsPost(
        organisationID: post.organisationID,
        organisationName: "${post.name}",
        organisationImage: wwwrootURL + post.organisationPhoto,
        postText: "${post.text}",
        postTime: "${post.time}",
        postImage: post.imagePath != "" ? wwwrootURL + post.imagePath : "",
        postOrganisationID: post.postID,
        dan: post.time.substring(8, 10),
        mesec: post.time.substring(5, 7),
        godina: post.time.substring(0, 4),
      ),
    );
  }

  Widget buildNewPost(context, OrganisationView org) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
      //  width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              org.photo != null
                  ? Container(
                      padding: EdgeInsets.only(left: 20.0),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(wwwrootURL + org.photo),
                            fit: BoxFit.cover),
                      ),
                    )
                  : Container(),
              SizedBox(width: 10.0),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                margin: EdgeInsets.only(bottom: 4.0),
                child: Text(
                  org.name,
                  style: TextStyle(
                      color: Colors.black, //green
                      fontSize: 15.0,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Card(
            elevation: 2,
            child: Container(
              padding: EdgeInsets.all(5),
              child: TextField(
                maxLines: 5,
                autofocus: false,
                controller: _postDescription,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey),
                  hintText: "Tekst",
                  border: InputBorder.none,
                  icon: error != null
                      ? Text('')
                      : data != null
                          ? Container(
                              margin: EdgeInsets.only(left: 10.0),
                              // width: 100,
                              height: 100,
                              child: Image.memory(data))
                          : Text(''), //Text('No data...'),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                errorMSG != ''
                    ? Text(
                        errorMSG,
                        style: TextStyle(color: Colors.red),
                      )
                    : Text(''),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: pickImage,
                        child: Icon(Icons.photo_library, color: Colors.green),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      buildPostButton(context, org),
                    ])
              ]),
        ],
      ),
    );
  }

  Widget buildPostButton(context, OrganisationView org) {
    if (org.isVerificated == true) {
      return RaisedButton(
        child: Text("Objavi",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        onPressed: () async {
          if (_postDescription.text == "") {
            setState(() {
              errorMSG = textMissingMSG;
            });
          } else if (name == '') {
            setState(() {
              errorMSG = pictureMissingMSG;
            });
          } else {
            Dialogs.showLoadingDialog(context, _keyLoader);
            String base64Image = base64Encode(data);
            APIServices.addImageWeb(base64Image, organisationPostsServerRoute)
                .then(
              (value) async {
                String imagePath = jsonDecode(value);
                PostOrg post = new PostOrg(loggedOrgID, _postDescription.text,
                    DateTime.now(), imagePath);
                await APIServicesOrg.newPostFromOrganisation(
                    Token.getToken, post);
                setState(
                  () {
                    data = null;
                    _postDescription.text = "";
                    errorMSG = '';
                    Navigator.of(_keyLoader.currentContext).pop();
                  },
                );
              },
            );
          }
        },
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
        color: Colors.white,
      );
    } else {
      return RaisedButton(
        child: Text("Objavi",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        onPressed: () {
          setState(() {
            errorMSG = noVerificationMSG;
          });
        },
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
        color: Colors.white,
      );
    }
  }

  pickImage() {
    final html.InputElement input = html.document.createElement('input');
    input
      ..type = 'file'
      ..accept = 'image/*';

    input.onChange.listen((e) {
      if (input.files.isEmpty) return;
      final reader = html.FileReader();
      reader.readAsDataUrl(input.files[0]);
      reader.onError.listen((err) => setState(() {
            error = err.toString();
          }));
      reader.onLoad.first.then((res) {
        final encoded = reader.result as String;
        // remove data:image/*;base64 preambule
        final stripped =
            encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');

        setState(() {
          name = input.files[0].name;
          data = base64.decode(stripped);
          error = null;
        });
      });
    });

    input.click();
  }

  // ----------------------------------------------------------------------------------------

  //construction of text object
  Text textFunction(text) {
    return new Text(text,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 17.0,
        ));
  }

  Widget buildOrganisationsPost({
    organisationID,
    postOrganisationID,
    organisationName,
    organisationImage,
    postText,
    postTime,
    postImage,
    dan,
    mesec,
    godina,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(bottom: 0),
      child: Column(
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
                          fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        organisationName,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              "dana " +
                                  dan +
                                  "." +
                                  mesec +
                                  "." +
                                  godina +
                                  "." +
                                  " u " +
                                  postTime.substring(11, 16),
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              organisationID == loggedOrgID
                  ? IconButton(
                      iconSize: 25.0,
                      onPressed: () async {
                        Dialogs.showLoadingDialog(context, _keyLoader);

                        await APIServicesPosts.deleteOrgPostByID(
                            Token.getToken, postOrganisationID);
                        setState(
                          () {
                            Navigator.of(_keyLoader.currentContext).pop();
                          },
                        );
                      },
                      icon: Icon(
                        FontAwesomeIcons.trash,
                        color: Colors.grey[500],
                        size: 23.0,
                      ),
                    )
                  : Container(),
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
                      postText != 'null'
                          ? ReadMoreText(
                              postText,
                              trimLength: 120,
                              trimCollapsedText: ' ...prikaži više',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  height: 1.5,
                                  letterSpacing: .7),
                            )
                          : Text(''),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(children: [
                  postImage != ''
                      ? Center(
                          child: Container(
                            height: MediaQuery.of(context).size.width * 0.15,
                            width: MediaQuery.of(context).size.width * 0.25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(postImage),
                                  fit: BoxFit.fill),
                            ),
                          ),
                        )
                      : Container(),
                ]),
              ]),
        ],
      ),
    );
  }
}
