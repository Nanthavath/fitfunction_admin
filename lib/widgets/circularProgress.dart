import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CircularProgress extends StatelessWidget {
  String title;

  CircularProgress({this.title = ''});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
