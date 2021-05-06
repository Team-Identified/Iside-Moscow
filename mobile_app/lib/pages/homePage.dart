import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw_insider/components/lastExploredObjectCard.dart';
import 'package:mw_insider/components/searchBar.dart';
import 'package:mw_insider/components/submitObjectButton.dart';
import 'package:mw_insider/components/trackingSwitchButton.dart';
import 'package:mw_insider/components/userExplorationStats.dart';


class HomePage extends StatefulWidget {
  final void Function(String) onGoToSearch;
  final void Function() onGoToSubmit;

  HomePage({Key key, @required this.onGoToSearch, @required this.onGoToSubmit}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void onSearchSubmit(String query){
    if (query != "")
      widget.onGoToSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.0),
            Center(child: SearchBar(onSubmit: onSearchSubmit,)),
            Center(child: SubmitObjectButton(goSubmit: widget.onGoToSubmit)),
            SizedBox(height: 10.0),
            LastExploredObjectCard(),
            Expanded(child: UserExplorationStats()),
            Center(child: TrackingSwitchButton()),
            SizedBox(height: 7.0),
          ],
        ),
      ),
    );
  }
}
