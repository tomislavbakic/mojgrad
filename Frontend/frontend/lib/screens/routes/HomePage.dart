import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fronend/config/loggedUserData.dart';
import 'package:fronend/functions/bottomNavigationBar.dart';
import 'package:fronend/functions/checkbox.dart';
import 'package:fronend/functions/logout.dart';
import 'package:fronend/main.dart';
import 'package:fronend/models/category.dart';
import 'package:fronend/models/view/postInfo.dart';
import 'package:fronend/screens/posts/postFeed.dart';
import 'package:fronend/services/api.services.posts.dart';

import 'organisations.dart';

Color boja = Colors.green;

class HomePage extends StatefulWidget {
  final String jwt;
  final Map<String, dynamic> payload;
  List<Category> category = List<Category>();

  int cityID;
  HomePage.category({this.category, this.jwt, this.payload, this.cityID});
  HomePage(this.jwt, this.payload);
  HomePage.city({this.cityID, this.jwt, this.payload});

  factory HomePage.fromBase64(String jwt) => HomePage(
        jwt,
        json.decode(
          ascii.decode(
            base64.decode(
              base64.normalize(jwt.split(".")[1]),
            ),
          ),
        ),
      );

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  List<PostInfo> beautyList = List<PostInfo>();
  @override
  void initState() {
    super.initState();
    if (widget.cityID == null) logoutUser(context);

    makeImageList();
  }

  void makeImageList() async {
    APIServicesPosts.getBeautyPosts(globalJWT, widget.cityID).then((value) {
      setState(() {
        for (var li in value) {
          beautyList.add(li);
        }
      });
    });
  }

  //build widget
  final _tabs = <Tab>[
    Tab(icon: Icon(Icons.fiber_new), text: 'Objave'),
    Tab(icon: Icon(Icons.feedback), text: 'Aktivno'),
    Tab(icon: Icon(Icons.group), text: 'Institucije'),
    //  Tab(icon: Icon(Icons.check_box)),
  ];

  @override
  Widget build(BuildContext context) {
    print(beautyList.length);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Početna"),
          ),
          body: DefaultTabController(
            length: 3,
            child: Column(
              children: <Widget>[
                Container(
                  constraints: BoxConstraints.expand(height: 40),
                  child: TabBar(
                    indicatorColor: Colors.green,
                    labelColor: Colors.green,
                    unselectedLabelColor: Colors.grey,
                    tabs: <Tab>[
                      Tab(text: 'Novo'),
                      Tab(text: 'Aktivno'),
                      Tab(text: 'Institucije'),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: TabBarView(children: [
                      PostFeed(
                        page: 0,
                        category: widget.category,
                        imgList: beautyList,
                        cityID: widget.cityID,
                      ),
                      PostFeed(
                        page: 1,
                        category: widget.category,
                        imgList: beautyList,
                        cityID: widget.cityID,
                      ),
                      OrgPage(),
                      //       CheckBoxes(),
                    ]),
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: MyBottomNavigationBar(0),
          endDrawer: CheckBoxes()),
    );
  }

  Widget bodyBuilder(BuildContext context) {
    return new PostFeed();
  }

  Widget filter() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: OutlineButton(
        color: Colors.teal,
        child: Text('FILTRIRAJTE', style: TextStyle(color: Colors.grey[700])),
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => SimpleDialog(
              title: Text(
                'Izaberite:',
                style: TextStyle(fontSize: 25),
              ),
              children: <Widget>[
                FlatButton(
                    child: Text('Aktivno'),
                    onPressed: () {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => SimpleDialog(
                                title: Text('Aktivno'),
                              ));
                    }),
                FlatButton(
                    child: Text('Zatvoreno'),
                    onPressed: () {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => SimpleDialog(
                                title: Text('Zatvoreno'),
                              ));
                    }),
                FlatButton(
                    child: Text('Novo'),
                    onPressed: () {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => SimpleDialog(
                                title: Text('Novo'),
                              ));
                    }),
                FlatButton(
                    child: Text('Kategorije'),
                    onPressed: () {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => SimpleDialog(
                              title: CheckBoxes() // izlistava cekbokseve
                              ));
                    })
              ],
            ),
          );
        },
      ),
    );
  }
}
