import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw_insider/pages/homePage.dart';
import 'package:mw_insider/pages/searchObjectPage.dart';
import 'package:mw_insider/pages/submitObjectPage.dart';


class HomeSearchSubmitPage extends StatefulWidget {
  const HomeSearchSubmitPage({Key key}) : super(key: key);

  @override
  _HomeSearchSubmitPageState createState() => _HomeSearchSubmitPageState();
}

class _HomeSearchSubmitPageState extends State<HomeSearchSubmitPage> {
  Widget currentPage;

  void goSearchPage(String query){
    setState(() {
      currentPage = SearchObject(onGoBack: onGoBackCallBack, query: query);
    });
  }

  void goSubmitPage(){
    setState(() {
      currentPage = SubmitObjectPage(onGoBack: onGoBackCallBack);
    });
  }

  void onGoBackCallBack(){
    setState(() {
      currentPage = HomePage(onGoToSearch: goSearchPage, onGoToSubmit: goSubmitPage);
    });
  }

  void initializePage(){
    if (currentPage == null)
      currentPage = HomePage(onGoToSearch: goSearchPage, onGoToSubmit: goSubmitPage);
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
