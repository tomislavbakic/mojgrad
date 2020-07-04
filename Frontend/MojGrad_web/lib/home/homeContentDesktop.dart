import 'package:flutter/material.dart';
import 'package:webproject/home/centred_view/centredView.dart';
import 'package:webproject/home/pages/pageBodyDesktop.dart';

import 'draggableScrollBar.dart';

 int type;  // 2 za institucije 1 za admine

void main() => runApp(new HomeContentDesktop(type));

class HomeContentDesktop extends StatelessWidget {

  int type;
  HomeContentDesktop(int value) {
    this.type = value;
  }
  //provide the same scrollController for list and draggableScrollbar
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
   //   backgroundColor: Colors.grey[700],
      body: DraggableScrollbar(
        child: SingleChildScrollView(
          controller: controller,
          child: CenteredView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                PageBodyDesktop(type)
              ],
            ),
          ),
        ),
        heightScrollThumb: 100.0,
        controller: controller,
        
      ),
    );
  }
}
