import 'package:flutter/material.dart';
import 'package:mobile_app/pages/home.dart';
import 'package:mobile_app/pages/news.dart';
import 'package:mobile_app/pages/user.dart';

class CustomBottomAppBar extends StatefulWidget {

  @override
  _CustomBottomAppBarState createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {

  int _currIndex = 1;
  final List<Widget> _children = [
    News(),
    Home(),
    User()
  ];

  void onTappedBar(int index) {
    setState(() {
      _currIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currIndex],
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.blueGrey[500],
          selectedItemColor: Colors.deepPurpleAccent,
          onTap: onTappedBar,
          iconSize: 27.0,
          currentIndex: _currIndex,
          backgroundColor: Colors.white,
          items:
            [
              BottomNavigationBarItem(
                  icon: Icon(Icons.article_rounded),
                  label: 'News'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'Profile'
              ),
            ]
        ),
    );
  }
}
