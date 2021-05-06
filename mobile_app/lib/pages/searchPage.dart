import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mw_insider/components/searchBar.dart';
import 'package:mw_insider/components/searchResults.dart';
import 'package:mw_insider/config.dart';

class SearchPage extends StatefulWidget {
  final VoidCallback onGoBack;
  final void Function(int) goToObject;
  final String query;

  SearchPage({Key key, @required this.onGoBack, @required this.goToObject,
    @required this.query}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery;


  void onSubmit(String query){
    if (query != "") {
      if (mounted) {
        setState(() {
          searchQuery = query;
        });
      }
    }
  }

  Widget getGoBackButton(double screenWidth){
    return Container(
      width: screenWidth * 0.7,
      child: TextButton.icon(
        icon: Icon(MdiIcons.arrowLeft),
        label: Text("Вернуться"),
        onPressed: widget.onGoBack,
        style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            primary: themeColorShade,
            backgroundColor: themeColor.withOpacity(0.1),
            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30)))
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (searchQuery == null) {
      setState(() {
        searchQuery = widget.query;
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.0),
            Center(child: SearchBar(onSubmit: onSubmit)),
            Center(child: getGoBackButton(screenWidth),),
            SizedBox(height: 10.0),
            SizedBox(
              height: 2.0,
              child: Container(color: themeColor),
            ),
            Flexible(child: new SearchResults(query: searchQuery, onGoToObject: widget.goToObject)),
          ],
        ),
      ),
    );
  }
}
