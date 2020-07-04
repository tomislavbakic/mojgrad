import 'package:flutter/material.dart';

class SuccessfulActionDialog extends StatelessWidget {
  final String title;
  final String message;
  SuccessfulActionDialog(this.title, this.message);

  @override
  Widget build(BuildContext _context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(_context).size.width * 0.07,
          vertical: MediaQuery.of(_context).size.width * 0.03,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(_context).size.width * 0.04),
            ),
            SizedBox(height: 10.0),
            Container(
              width: MediaQuery.of(_context).size.width * 0.5,
              child: Text(
                message,
                style: TextStyle(
                    fontSize: MediaQuery.of(_context).size.width * 0.04,
                    color: Colors.black),
              ),
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                closeDialog(_context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void closeDialog(context) {
    return Navigator.pop(context);
  }
}
