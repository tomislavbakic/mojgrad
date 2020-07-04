import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String message;
  LoadingDialog(this.message);

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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            SizedBox(width: MediaQuery.of(_context).size.width * 0.04),
            Container(
              width: MediaQuery.of(_context).size.width * 0.45,
              child: Text(
                message,
                style: TextStyle(
                    fontSize: MediaQuery.of(_context).size.width * 0.04,
                    color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
