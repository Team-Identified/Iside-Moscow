import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UnauthorizedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ATTENTION",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  width: screenWidth - 60.0,
                  child: Text(
                    "This page is inaccessible to unauthorized users. Please log in to gain access.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
