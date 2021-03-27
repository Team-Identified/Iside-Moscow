import 'package:flutter/material.dart';
import 'package:mobile_app/services/bottomAppBar.dart';
import 'package:mobile_app/pages/news.dart';
import 'package:mobile_app/pages/loading.dart';

void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      initialRoute: '/',
        routes: {
        '/': (context) => Loading(),
          '/app': (context) => CustomBottomAppBar(),
          '/news': (context) => News(),
        },
    );
  }
}



