import 'package:flutter/material.dart';


class AuthErrorMessage extends StatelessWidget {
  final String text;

  AuthErrorMessage({
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
        color: Colors.redAccent.withOpacity(0.1),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red,
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }
}