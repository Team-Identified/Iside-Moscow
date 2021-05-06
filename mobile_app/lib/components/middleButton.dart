import 'package:flutter/material.dart';
import 'package:mw_insider/config.dart';


class MiddleButton extends StatelessWidget {
  final String text;
  final Function press;

  MiddleButton({
    @required this.text,
    @required this.press,
  });

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.7,
      child: TextButton(
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: themeColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ),
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}