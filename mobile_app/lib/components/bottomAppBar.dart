import 'package:flutter/material.dart';
import 'package:mw_insider/config.dart';
import 'package:mw_insider/pages/homeSearchSubmitPage.dart';
import 'package:mw_insider/pages/newsPage.dart';
import 'package:mw_insider/pages/profilePage.dart';
import 'package:mw_insider/pages/strollObjectPage.dart';
import 'package:mw_insider/pages/homePage.dart';


class CustomBottomAppBar extends StatefulWidget {
  final VoidCallback updateFunction;

  CustomBottomAppBar({@required this.updateFunction});

  @override
  _CustomBottomAppBarState createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
  int _currIndex = 0;
  List<Widget> _children;

  void onTappedBar(int index) {
    setState(() {
      _currIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _children = [
      HomeSearchSubmitPage(),
      StrollObjectPage(),
      NewsPage(),
      ProfilePage(onLogOutPressed: () {widget.updateFunction();}),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(child: _children[_currIndex]),
        backgroundColor: themeColor,
        bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.blueGrey[500],
            selectedItemColor: themeColor,
            onTap: onTappedBar,
            iconSize: 27.0,
            currentIndex: _currIndex,
            backgroundColor: Colors.white,
            items:
            [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Главная'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.directions_walk),
                  label: 'Прогулка'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.article_rounded),
                  label: 'Новости'
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