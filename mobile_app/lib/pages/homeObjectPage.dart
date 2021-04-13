import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/pages/homePage.dart';
import 'package:mobile_app/pages/objectPage.dart';


class HomeObjectPage extends StatefulWidget {
  @override
  _HomeObjectPageState createState() => _HomeObjectPageState();
}

class _HomeObjectPageState extends State<HomeObjectPage> {
  Widget currentPage;

  void goToObjectPage(int objectId){
    setState(() {
      currentPage = ObjectPage(objectId: objectId, onGoBack: onGoBackCallBack);
    });
  }

  void onGoBackCallBack(){
    setState(() {
      currentPage = HomePage(onGoToObject: goToObjectPage);
    });
  }

  void initializePage(){
    if (currentPage == null)
      currentPage = HomePage(onGoToObject: goToObjectPage);
  }

  @override
  Widget build(BuildContext context) {
    initializePage();
    return Scaffold(
      body: currentPage,
    );
  }
}
