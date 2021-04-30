import 'package:flutter/material.dart';

class CircularProgressWidget extends StatelessWidget {
  final primaryColor = Color.fromARGB(250, 122, 30, 199);
  final String message;
  CircularProgressWidget({@required this.message});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: SizedBox(
            height: 56.0,
            width: 56.0,
            child: CircularProgressIndicator(
              value: null,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          message,
          style: TextStyle(
            fontFamily: "Quicksand",
            fontSize: 19,
          ),
        ),
      ],
    );
  }
}
