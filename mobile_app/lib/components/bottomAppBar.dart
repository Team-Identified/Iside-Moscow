import 'package:flutter/material.dart';
import 'package:mobile_app/pages/newsPage.dart';
import 'package:mobile_app/pages/userPage.dart';
import 'package:mobile_app/pages/homeObjectPage.dart';


class CustomBottomAppBar extends StatefulWidget {
  @override
  _CustomBottomAppBarState createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {

  int _currIndex = 1;
  final List<Widget> _children = [
    NewsPage(),
    HomeObjectPage(),
    UserPage(),
  ];

  void onTappedBar(int index) {
    setState(() {
      _currIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(child: _children[_currIndex]),
        backgroundColor: Colors.deepPurpleAccent,
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
                  label: 'Новости'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Главная'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'Профиль'
              ),
            ]
        ),
      ),
    );
  }
}