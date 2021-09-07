import 'package:flutter/material.dart';

class Page01 extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          child: Image.asset('images/tiny02.jpg'),
        )
      ],
    );
  }
}