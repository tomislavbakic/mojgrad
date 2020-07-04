import 'package:flutter/material.dart';
import 'package:webproject/home/draggableScrollBar.dart';
import 'package:webproject/home/pages/pageBodyTablet.dart';

import 'package:webproject/home/centred_view/centredView.dart';

int type; // 2 za institucije 1 za admine
void main() => runApp(new HomeContentMobile(type));

class HomeContentMobile extends StatelessWidget {
  int type;
  HomeContentMobile(int value) {
    this.type = value;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DraggableScrollbar(
        child: SingleChildScrollView(
         // controller: ScrollController(),
          child: CenteredView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                PageBodyTablet(type)
              ],
            ),
          ),
        ),
        heightScrollThumb: 100.0,
       controller: ScrollController()
      ),
    );
  }
}
