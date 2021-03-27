import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title:Text("Profile"),
            centerTitle: true,
            backgroundColor: Colors.deepPurpleAccent[700],
          ),
          backgroundColor: Colors.grey[300],
          body: Center(
            child: Text('Profile page'),
          ),
        )
    );
  }
}