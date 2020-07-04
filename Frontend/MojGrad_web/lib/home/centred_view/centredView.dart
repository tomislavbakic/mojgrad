import 'package:flutter/material.dart';

class CenteredView extends StatelessWidget {
  //iskorisceno za potrebe prikaza Korisnika(jednina), obrisati ako se ne koristi

  final Widget child;
  const CenteredView({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
    
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 1200,
        ),
        child: child,
      ),
    );
  }
}
