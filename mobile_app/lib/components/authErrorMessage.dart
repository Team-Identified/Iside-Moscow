import 'package:flutter/material.dart';
import 'package:mobile_app/config.dart';


class AuthErrorMessage extends StatelessWidget {
  final String text;

  AuthErrorMessage({
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
        width: screenWidth * 0.9,
        color: Colors.red,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }
}