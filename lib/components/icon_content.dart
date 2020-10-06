import 'package:flutter/material.dart';
import '../constants.dart';


class IconContent extends StatelessWidget {

  final String label;
  final IconData icon;

  IconContent({this.icon, this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
        ),
        SizedBox( height: 15.0,
        ),
        Text(
            label,
        )
      ],
    );
  }
}