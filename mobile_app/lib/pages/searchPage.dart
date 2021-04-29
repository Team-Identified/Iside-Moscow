import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw_insider/services/backendCommunicationService.dart';


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String data = "THIS IS SEARCH PAGE";

  Future<String> loadData() async {
    Map requestData = {
      'search_query': 'Музей',
    };
    Map response = await serverRequest('post', 'geo_objects/search', requestData);

    return response['results'][0]['object']['name_ru'];
  }

  @override
  void initState() {
    super.initState();

    loadData().then((responseData){
      if (!mounted)
        return;
      else{
        setState(() {
          data = responseData;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    loadData();

    return Scaffold(
      body: Container(
        child: Center(
          child: Text(data),
        ),
      ),
    );
  }
}
