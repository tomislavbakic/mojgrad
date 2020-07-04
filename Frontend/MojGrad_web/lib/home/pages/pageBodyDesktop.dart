import 'package:flutter/material.dart';
import 'package:webproject/home/navigation/navigationBar.dart';
import 'package:webproject/home/mainContent.dart';
import 'package:webproject/home/mainContentInstitution.dart';

class PageBodyDesktop extends StatefulWidget {
  int type; //2 institucije, 1 admin
  PageBodyDesktop(int value) {
    this.type = value;
  }
  @override
  _PageBodyDesktopState createState() => _PageBodyDesktopState(type);
}

class _PageBodyDesktopState extends State<PageBodyDesktop> {
  int type;

  _PageBodyDesktopState(int value) {
    this.type = value;
  }

  @override
  Widget build(BuildContext context) {
   
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: Card(
            color: Colors.blueGrey[100],
            elevation: 1,
            child: Container(
              child: Column(
                children: <Widget>[
                  //za admina 1, za institucije 2
                  NavigationBar(),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: type == 1
                        ? MainContent(1)
                        : MainContentInstitution(2), // OneUserContent()  // 2 za institucije 1 za admine
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "© LEVEL UP 2020",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(" Sva prava zadržana."),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
