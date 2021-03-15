import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title:Text("Home"),
            centerTitle: true,
            backgroundColor: Colors.deepPurpleAccent[700],
          ),
          backgroundColor: Colors.grey[300],
          body: Center(
            child: Text('Home page'),
          ),
        )
    );
  }
}
