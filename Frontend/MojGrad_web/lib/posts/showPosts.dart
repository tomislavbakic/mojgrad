import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webproject/config/configuration.dart';
import 'package:webproject/functions/loadingDialog.dart';
import 'package:webproject/functions/readMore.dart';
import 'package:webproject/main.dart';
import 'package:webproject/models/view/categoryView.dart';
import 'package:webproject/models/view/city.dart';
import 'package:webproject/models/view/postInfo.dart';
import 'package:webproject/posts/showLikes.dart';
import 'package:webproject/services/api.services.dart';
import 'package:webproject/services/api.services.posts.dart';
import 'package:webproject/services/token.session.dart';
import 'package:webproject/posts/showCommentsAndSolutions.dart';

class ShowPostsPage extends StatefulWidget {
  int type;
  ShowPostsPage(int value) {
    this.type = value;
  }

  @override
  _ShowPostsPageState createState() => _ShowPostsPageState(type);
}

class _ShowPostsPageState extends State<ShowPostsPage> {
  int cityID = -1;
  int categoryID = -1;
  int postType = 1;
  /*
    Sve obajve = type 1
    Najbolje objave = type 2
    Prijavljene objave = type 3
  */
  int userID;
  int type;
  _ShowPostsPageState(int value) {
    this.type = value;
  }

  final ScrollController controller = ScrollController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    userID = type == 1 ? loggedAdminID : loggedOrgID;
    return Expanded(
      child: ListView(
        children: <Widget>[
          SizedBox(height: 20),
          MediaQuery.of(context).size.width < 700
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //SizedBox(width: 50),
                    type == 1 ? postsDropdown() : Container(),
                    SizedBox(width: 10),
                    cityDropdown(),
                    SizedBox(width: 10),
                    categoryDropdown(),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //SizedBox(width: 50),
                    type == 1 ? postsDropdown() : Container(),
                    SizedBox(width: 30),
                    cityDropdown(),
                    SizedBox(width: 30),
                    categoryDropdown(),
                  ],
                ),
          SizedBox(height: 5),
          Container(
            color: Colors.white24,
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
            child: FutureBuilder(
              future: APIServicesPosts.getAllPostsByFilter(
                  Token.getToken, userID, cityID, categoryID, postType),
              builder: (BuildContext context,
                  AsyncSnapshot<List<PostInfo>> snapshot) {
                if (!snapshot.hasData)
                  return Container(
                      color: Colors.white,
                      child: Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      height: 10);
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    PostInfo post = snapshot.data[index];
                    return postListView(context, post);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget postListView(BuildContext contextt, PostInfo post) {
    return Card(
      color: type == 1
          ? Colors.white
          : (post.isActive == true ? Colors.white : Colors.green[100]),
      elevation: 1,
      // width: MediaQuery.of(context).size.width * 0.5,
      margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3),

      child: makeFeed(
        userName: "${post.fullname}",
        userImage: wwwrootURL + post.userPhoto,
        //feedTime: post.time,
        feedText: "${post.description}",
        feedTime: "${post.time}",
        feedImage: post.postImage != "" ? wwwrootURL + post.postImage : "",
        userLocation: "${post.address}",
        likes: "${post.likesNumber.toString()}",
        comments: "${post.commentsNumber.toString()}",
        category: "${post.categoryName.toString()}",
        title: "${post.title.toString()}",
        postID: post.id,
        dan: post.time.substring(8, 10),
        mesec: post.time.substring(5, 7),
        godina: post.time.substring(0, 4),
        isSaved: post.isSaved,
        isActive: post.isActive,
        //isLiked: post.isLiked,
      ),
    );
  }

  Widget makeFeed(
      {postID,
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
      dan,
      mesec,
      godina,
      isSaved,
      isActive}) {
    return Container(
      decoration: BoxDecoration(
        color: type == 1
            ? Colors.white
            : (isActive == true ? Colors.white : Colors.green[100]),
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(bottom: 0),
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
                          image: NetworkImage(userImage), fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, //!
                    children: <Widget>[
                      Container(
                        //           width: MediaQuery.of(context).size.width * 0.4,
                        child: Text(
                          userName,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Row(children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Text(
                            userLocation +
                                ", dana " +
                                dan +
                                "." +
                                mesec +
                                "." +
                                godina +
                                "." +
                                " u " +
                                feedTime.substring(11, 16),
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ),
                      ])
                    ],
                  ),
                ],
              ),
              type == 1
                  ? IconButton(
                      iconSize: 25.0,
                      onPressed: () async {
                        //Dialogs.showLoadingDialog(context, _keyLoader);
                        /*await APIServicesPosts.deletePostByID(
                            Token.getToken, postID);*/
                        await showAlertDialog(context, postID);
                        setState(
                          () {},
                        );
                      }, // AKCIJA OBRISI KORISNIKA IZ SISTEMA
                      icon: Icon(
                        FontAwesomeIcons.trash,
                        color: Colors.grey[500],
                        size: 23.0,
                      ),
                    )
                  : (isActive == true
                      ? IconButton(
                          iconSize: 20.0,
                          onPressed: () async {
                            Dialogs.showLoadingDialog(context, _keyLoader);
                            if (isSaved == false) {
                              await APIServicesPosts.addSavedPost(
                                  Token.getToken, loggedOrgID, postID);
                            } else {
                              await APIServicesPosts.deleteSavedPost(
                                  Token.getToken, loggedOrgID, postID);
                            }
                            setState(
                              () {
                                Navigator.of(_keyLoader.currentContext).pop();
                              },
                            );
                          }, //SACUVAJ OBJAVU
                          icon: isSaved != true
                              ? Icon(
                                  FontAwesomeIcons.bookmark,
                                  size: 23.0,
                                )
                              : Icon(
                                  FontAwesomeIcons.bookmark,
                                  color: Colors.yellow[800],
                                  size: 23.0,
                                ),
                        )
                      : Text(
                          "REŠENO",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                              height: 1.5,
                              letterSpacing: .7),
                        )),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          //horizontalLine(),
          SizedBox(
            height: 5.0,
          ),
          type == 1
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            title != 'null'
                                ? ReadMoreText(
                                    title,
                                    trimLength: 45,
                                    trimCollapsedText: ' ...prikaži više',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        height: 1.5,
                                        letterSpacing: .7),
                                  )
                                : Text(''),
                            feedText != "null"
                                ? ReadMoreText(
                                    feedText,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[800],
                                        height: 1.5,
                                        letterSpacing: .7),
                                  )
                                : Text(""),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(//crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                        feedImage != ''
                            ? Center(
                                child: Container(
                                  height: 100,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: NetworkImage(feedImage),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                              )
                            : Container(),
                      ]),
                    ])
              : Column(
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                title != 'null'
                                    ? ReadMoreText(
                                        title,
                                        trimLength: 45,
                                        trimCollapsedText: ' ...prikaži više',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            height: 1.5,
                                            letterSpacing: .7),
                                      )
                                    : Text(''),
                                feedText != "null"
                                    ? ReadMoreText(
                                        feedText,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey[800],
                                            height: 1.5,
                                            letterSpacing: .7),
                                      )
                                    : Text(""),
                              ],
                            ),
                          ),
                        ]),
                    SizedBox(
                      height: 5,
                    ),
                    Column(children: [
                      feedImage != ''
                          ? Center(
                              child: Container(
                                height:
                                    350, //MediaQuery.of(context).size.height * 0.45,
                                width:
                                    450, //MediaQuery.of(context).size.width * 0.25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(feedImage),
                                      fit: BoxFit.fill),
                                ),
                              ),
                            )
                          : Container(),
                    ]),
                  ],
                ),

          Row(
            children: <Widget>[
              Text(likes),
              IconButton(
                icon: Icon(FontAwesomeIcons.leaf, color: Colors.grey[700]),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                            title: new Text("Ovo se dopada"),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            content: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: 400,
                              child: ShowLikes(postID),
                            ),
                          ));
                },
              ),
              SizedBox(width: 5),
              Text(comments),
              IconButton(
                icon: Icon(FontAwesomeIcons.comment, color: Colors.grey[700]),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                      title: type == 1
                          ? new Text("Komentari")
                          : new Text("Rešenja"),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      content: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 800,
                        child: ShowCommentsAndSolutions(postID, type),
                      ),
                    ),
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }

  String dropdownValue = 'Sve';

  Widget postsDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: dropdownValue,
        // icon: Icon(Icons.arrow_downward),
        items: <String>["Sve", "Najbolje", "Prijavljene"]
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
            if (newValue == "Sve")
              postType = 1;
            else if (newValue == "Prijavljene")
              postType = 2;
            else if (newValue == "Najbolje") postType = 3;
          });
        },
      ),
    );
  }

  City dropdownValueCity;
  Widget cityDropdown() {
    return FutureBuilder(
      future: APIServices.getAllCities(Token.getToken),
      builder: (BuildContext context, AsyncSnapshot<List<City>> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          // snapshot.data.add(allCity);
          return Container(
              child: DropdownButtonHideUnderline(
            child: DropdownButton(
              underline: Container(
                height: 2,
                color: Colors.green,
              ),
              iconEnabledColor: Colors.black,
              items: snapshot.data
                  .map((City city) => DropdownMenuItem<City>(
                        value: city,
                        child: Text(
                          city.name,
                          style: TextStyle(color: Colors.black),
                        ),
                      ))
                  .toList(),
              onChanged: (City newValue) {
                setState(() {
                  dropdownValueCity = newValue;
                  cityID = newValue.id;
                });
              },
              value: dropdownValueCity == null
                  ? dropdownValueCity
                  : snapshot.data
                      .where((i) => i.name == dropdownValueCity.name)
                      .first,
              hint: Text(
                'Grad',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ));
        }
      },
    );
  }

  CategoryView dropdownValueCategory;
  Widget categoryDropdown() {
    return FutureBuilder(
      future: APIServices.getAllCategories(Token.getToken),
      builder:
          (BuildContext context, AsyncSnapshot<List<CategoryView>> snapshot) {
        if (!snapshot.hasData) {
          return Center();
        } else {
          return DropdownButtonHideUnderline(
            child: DropdownButton(
              underline: Container(
                height: 2,
                color: Colors.green,
              ),
              iconEnabledColor: Colors.black,
              items: snapshot.data
                  .map(
                      (CategoryView category) => DropdownMenuItem<CategoryView>(
                            value: category,
                            child: Text(
                              category.name,
                              style: TextStyle(color: Colors.black),
                            ),
                          ))
                  .toList(),
              onChanged: (CategoryView newValue) {
                setState(() {
                  dropdownValueCategory = newValue;
                  categoryID = newValue.id;
                });
              },
              value: dropdownValueCategory == null
                  ? dropdownValueCategory
                  : snapshot.data
                      .where((i) => i.name == dropdownValueCategory.name)
                      .first,
              hint: Text(
                'Kategorija',
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        }
      },
    );
  }

  showAlertDialog(BuildContext context, postID) {
    Widget accept = FlatButton(
      child: Text("Da"),
      onPressed: () async {
        setState(
          () {
            APIServicesPosts.deletePostByID(Token.getToken, postID);
          },
        );
        Navigator.of(context, rootNavigator: true).pop(true);
      },
    );
    Widget decline = FlatButton(
      child: Text("Ne"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop(true);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Brisanje objave"),
      content: Text("Da li ste sigurni da želite da obrišete objavu?"),
      actions: <Widget>[
        accept,
        decline,
      ],
    );

    showDialog(context: context, child: alert);
  }
}
