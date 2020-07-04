import 'package:flutter/material.dart';

class Dialogs {
  static showLoadingDialog(BuildContext context,GlobalKey key) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          key: key,
          backgroundColor: Colors.black54,
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text(
                    "Sačekajte....",
                    style: TextStyle(color: Colors.white54),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
