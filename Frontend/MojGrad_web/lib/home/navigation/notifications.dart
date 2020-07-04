import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Text("OBAVEŠTENJA SE NALAZE OVDE"),
      ),
    );
  }
}
