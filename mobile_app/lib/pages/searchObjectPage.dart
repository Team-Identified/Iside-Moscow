import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw_insider/pages/objectPage.dart';
import 'package:mw_insider/pages/searchPage.dart';


class SearchObject extends StatefulWidget {
  final VoidCallback onGoBack;
  final String query;

  SearchObject({Key key, @required this.onGoBack, @required this.query}) : super(key: key);

  @override
  _SearchObjectState createState() => _SearchObjectState();
}

class _SearchObjectState extends State<SearchObject> {
  Widget currentPage;


  void goObjectPage(int objectId){
    setState(() {
      currentPage = ObjectPage(onGoBack: onGoBackToSearchCallBack, objectId: objectId);
    });
  }

  void onGoBackToSearchCallBack(){
    setState(() {
      currentPage = SearchPage(onGoBack: widget.onGoBack, goToObject: goObjectPage, query: widget.query);
    });
  }

  void initializePage(){
    if (currentPage == null)
      currentPage = SearchPage(onGoBack: widget.onGoBack, goToObject: goObjectPage, query: widget.query);
  }

  @override
  Widget build(BuildContext context) {
    initializePage();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: currentPage,
    );
  }
}
