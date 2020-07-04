import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
              child: Image.asset(
                "images/mojgradfull.png",
                width: MediaQuery.of(context).size.width * 0.65,
              ),
            ),
      ),
    );
  }
}
