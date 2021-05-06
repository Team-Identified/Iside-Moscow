import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw_insider/pages/strollPage.dart';
import 'package:mw_insider/pages/objectPage.dart';
import 'package:mw_insider/main.dart';


class StrollObjectPage extends StatefulWidget {
  @override
  _StrollObjectPageState createState() => _StrollObjectPageState();
}

class _StrollObjectPageState extends State<StrollObjectPage> {
  Widget currentPage;

  void goToObjectPage(int objectId){
    setState(() {
      currentPage = ObjectPage(objectId: objectId, onGoBack: onGoBackCallBack);
    });
  }

  void onGoBackCallBack(){
    setState(() {
      currentPage = StrollPage(onGoToObject: goToObjectPage);
    });
  }

  void initializePage(){
    if (currentPage == null)
      currentPage = StrollPage(onGoToObject: goToObjectPage);
  }

  @override
  Widget build(BuildContext context) {
    locationService.requestLocationUpdate();
    initializePage();
    return Scaffold(
      body: currentPage,
    );
  }
}
