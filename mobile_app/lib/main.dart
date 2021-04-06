import 'package:flutter/material.dart';
import 'package:mobile_app/components/BottomAppBar.dart';
import 'package:mobile_app/pages/homePage.dart';
void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: CustomBottomAppBar(),
    );
  }
}



