import 'package:flutter/material.dart';
import 'package:mobile_app/pages/home.dart';
import 'package:mobile_app/pages/map.dart';
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
    Map(),
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
          selectedItemColor: Colors.blue[500],
          onTap: onTappedBar,
          currentIndex: _currIndex,
          items:
            [
              BottomNavigationBarItem(
                  icon: Icon(Icons.new_releases_sharp),
                  label: 'News'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.map_outlined),
                  label: 'Map'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'User'
              ),
            ]
        ),
    );
  }
}
