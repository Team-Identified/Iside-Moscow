import 'package:flutter/material.dart';
import 'package:mobile_app/pages/home.dart';
import 'package:mobile_app/pages/map.dart';
import 'package:mobile_app/pages/news.dart';
import 'package:mobile_app/services/BottomAppBar.dart';

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



