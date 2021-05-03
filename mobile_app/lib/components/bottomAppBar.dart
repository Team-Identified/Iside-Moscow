import 'package:flutter/material.dart';
import 'package:mw_insider/pages/newsPage.dart';
import 'package:mw_insider/pages/profilePage.dart';
import 'package:mw_insider/pages/homeObjectPage.dart';


class CustomBottomAppBar extends StatefulWidget {
  final VoidCallback updateFunction;

  CustomBottomAppBar({@required this.updateFunction});

  @override
  _CustomBottomAppBarState createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
  int _currIndex = 1;
  Widget newsPage;
  Widget homePage;
  Widget profilePage;
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
      NewsPage(),
      HomeObjectPage(),
      ProfilePage(onLogOutPressed: () {widget.updateFunction();}),
    ];
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