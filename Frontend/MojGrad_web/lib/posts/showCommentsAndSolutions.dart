import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:webproject/config/configuration.dart';
import 'package:webproject/functions/loadingDialog.dart';
import 'package:webproject/main.dart';
import 'package:webproject/models/postSolution.dart';
import 'package:webproject/models/view/commentInfo.dart';
import 'package:webproject/models/view/organisationView.dart';
import 'package:webproject/models/view/postSolutionInfo.dart';
import 'package:webproject/services/api.services.dart';
import 'package:webproject/services/api.services.org.dart';
import 'package:webproject/services/api.services.posts.dart';
import 'package:webproject/services/token.session.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;
import 'package:webproject/config/config.error.dart';

class ShowCommentsAndSolutions extends StatefulWidget {
  final int postID;
  int type;

  ShowCommentsAndSolutions(this.postID, this.type);
  _ShowCommentsAndSolutionsState createState() =>
      _ShowCommentsAndSolutionsState();
}

class _ShowCommentsAndSolutionsState extends State<ShowCommentsAndSolutions> {
  Color boja = Colors.green;

  bool isLikedComment;
  bool isDislikedComment;
  bool _isActive;

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  TextEditingController _submittedString = new TextEditingController();
  //ZA SLIKU
  String name = '';
  String error = '';
  String errorMSG = '';
  Uint8List data;
  OrganisationView org;

  @override
  void initState() {
    super.initState();
    APIServicesOrg.getOrganisationsDataByID(Token.getToken, loggedOrgID).then(
      (value) {
        setState(
          () {
            org = value;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: buildBody(context),
    );
  }

  bool comm = true;
  bool solution = false;
  Widget buildBody(context) {
    return Center(
      child: Container(
        alignment: Alignment.topCenter,
        width: MediaQuery.of(context).size.width, // *0.4
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //widget.type == 2 ? SizedBox(height: 15) : Text(''),
              widget.type == 2 ? buildTextField(context) : SizedBox(height: 0),
              errorMSG != null
                  ? Text(
                      errorMSG,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )
                  : Text(''),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        setState(
                          () {
                            comm = true;
                            solution = false;
                          },
                        );
                      },
                      child: Text(
                        'Komentari',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        setState(
                          () {
                            comm = false;
                            solution = true;
                          },
                        );
                      },
                      child:
                          Text('Rešenja', style: TextStyle(color: Colors.grey)),
                    )
                  ],
                ),
              ),
              Container(
                child: comm == true ? myCommentBody() : mySolutionBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }

// ------------------------------------------------------------------

  Widget mySolutionBody() {
    return FutureBuilder<List<PostSolutionInfo>>(
      future: APIServicesPosts.getAllSolutionByPostID(
        Token.getToken,
        widget.postID,
        loggedOrgID,
      ),
      builder: (BuildContext context,
          AsyncSnapshot<List<PostSolutionInfo>> snapshot) {
        if (!snapshot.hasData)
          return Center(
              child: Container(
                  width: 50, height: 50, child: CircularProgressIndicator()));
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

  Widget _buildSolution(BuildContext context, PostSolutionInfo solution) {
    isLikedComment = solution.isLikedComment;
    isDislikedComment = solution.isDislikedComment;
    return Card(
      elevation: 1,
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
                      padding: EdgeInsets.only(bottom: 10),
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Text(
                        solution.fullName,
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              padding: EdgeInsets.only(top: 5.0, bottom: 10),
              child: Text("${solution.text}",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, letterSpacing: .7)),
            ),
            //SizedBox(height: 10),
            solution.commentPhoto != null
                ? Center(
                    child: Container(
                      height: 350.0,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image:
                              NetworkImage(wwwrootURL + solution.commentPhoto),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

// -----------------------------------------------------------------

  Widget myCommentBody() {
    return FutureBuilder<List<CommentView>>(
      future: CommentView.getCommentsByPostID(Token.getToken, widget.postID),
      builder:
          (BuildContext context, AsyncSnapshot<List<CommentView>> snapshot) {
        if (!snapshot.hasData)
          return Center(
              child: Container(
                  width: 50, height: 50, child: CircularProgressIndicator()));
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

  Widget buildTextField(context) {
    if (_isActive == false) {
      return Container();
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: 10,
                right: 5,
                bottom: 10,
              ),
              width: MediaQuery.of(context).size.width * 0.2,
              child: TextField(
                autofocus: false,
                maxLines: null,
                controller: _submittedString,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Predložite rešenje...",
                  icon: error != null
                      ? Text('')
                      : data != null
                          ? Container(
                              height: 100,
                              width: 100,
                              child: Image.memory(data))
                          : Text(''),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.image, size: 30),
              color: boja,
              onPressed: pickImage,
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: 30),
              color: boja,
              onPressed: () async {
                if (org.isVerificated == true) {
                  if (_submittedString.text == "") {
                    setState(
                      () {
                        errorMSG = textMissingMSG;
                      },
                    );
                  } else if (name == '') {
                    setState(
                      () {
                        errorMSG = pictureMissingMSG;
                      },
                    );
                  } else {
                    Dialogs.showLoadingDialog(context, _keyLoader);
                    String base64Img = base64.encode(data);
                    APIServices.addImageWeb(base64Img, solutionServerRoute)
                        .then(
                      (value) async {
                        String imagePath = jsonDecode(value);
                        PostSolution ps = new PostSolution(
                            _submittedString.text,
                            widget.postID,
                            loggedOrgID,
                            imagePath);
                        await APIServicesPosts.addPostSolution(
                            Token.getToken, ps);
                        setState(
                          () {
                            data = null;
                            _submittedString.text = "";
                            errorMSG = '';
                            Navigator.of(_keyLoader.currentContext).pop();
                          },
                        );
                      },
                    );
                  }
                } else {
                  setState(
                    () {
                      errorMSG = noVerificationMSG;
                    },
                  );
                }
              },
            ),
          ],
        ),
      );
    }
  }

  //kreira jedan komentar

  Widget _buildComment(BuildContext context, CommentView comment) {
    isLikedComment = comment.isLikedComment;
    isDislikedComment = comment.isDislikedComment;
    return Card(
      elevation: 1,
      child: Container(
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
                        padding: EdgeInsets.only(bottom: 10),
                        width: MediaQuery.of(context).size.width * 0.2,
                        //child: InkWell(
                        child: Text(
                          comment.fullName,
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: .5),
                        ),
                        /*onTap: () async {
                            //ako ocete da idete na profil usera
                          },*/
                        //),
                      ),
                    ],
                  ),
                ]),
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
              child: Text("${comment.text}",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, letterSpacing: .7)),
            ),
            comment.commentPhoto != null
                ? Center(
                    child: Container(
                      height: 350.0,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image:
                              NetworkImage(wwwrootURL + comment.commentPhoto),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  //za sliku

  pickImage() {
    final html.InputElement input = html.document.createElement('input');
    input
      ..type = 'file'
      ..accept = 'image/*';

    input.onChange.listen(
      (e) {
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
      },
    );

    input.click();
  }
}
