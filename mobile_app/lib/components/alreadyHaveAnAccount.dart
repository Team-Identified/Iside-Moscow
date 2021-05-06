import 'package:flutter/material.dart';
import 'package:mw_insider/config.dart';

class AlreadyHaveAnAccount extends StatelessWidget {
  final bool login;
  final Function press;
  const AlreadyHaveAnAccount({
    Key key,
    this.login = true,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Don’t have an Account? " : "Already have an Account? ",
          style: TextStyle(
            color: themeColorShade,
            fontSize: 15.0
          ),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "Sign Up" : "Sign In",
            style: TextStyle(
              color: themeColorShade,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        )
      ],
    );
  }
}