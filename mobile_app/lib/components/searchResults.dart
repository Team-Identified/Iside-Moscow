import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw_insider/components/loadingCircle.dart';
import 'package:mw_insider/components/objectCard.dart';
import 'package:mw_insider/config.dart';
import 'package:mw_insider/services/backendCommunicationService.dart';
import 'package:mw_insider/services/geoService.dart';
import 'package:mw_insider/services/locationService.dart';
import 'package:provider/provider.dart';


class SearchResults extends StatefulWidget {
  final String query;
  final void Function(int) onGoToObject;

  SearchResults({Key key, @required this.query, @required this.onGoToObject}) : super(key: key);

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  bool loaded = false;
  bool loading = false;
  String currentQuery;
  List<dynamic> results;

  void loadData() async {
    if (mounted){
      setState(() {
        loading = true;
      });
      if (widget.query != currentQuery){
        setState(() {
          currentQuery = widget.query;
        });
      }
    }

    Map requestData = {
      'search_query': widget.query,
    };
    Map response = await serverRequest('post', '/geo_objects/search', requestData);
    if (mounted){
      setState(() {
        loaded = true;
        loading = false;
        results = response['results'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var locationData = Provider.of<UserLocation>(context);

    if (currentQuery != widget.query){
      loaded = false;
      loading = false;
      results = null;
    }

    if (!loaded){
      if (!loading)
        loadData();
      return Center(child: LoadingCircle());
    }
    else{
      return ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: themeColor,
          child: ListView.separated(
            padding: EdgeInsets.all(0.0),
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: max(results.length, 1),
            separatorBuilder: (BuildContext context, int index){
              return SizedBox(height: 8.0);
            },
            itemBuilder: (context, index){
              if (results.length > 0) {
                Map currentObject = results[index]['object'];
                String imageUrl = currentObject['image_url'] == null ? animeGirlsUrl : currentObject['image_url'];
                int distance = 0;
                if (isUseful(locationData)){
                  distance = calculateDistance(
                    locationData.latitude,
                    locationData.longitude,
                    currentObject['latitude'],
                    currentObject['longitude'],
                  );
                }
                return ObjectCard(
                  id: currentObject['id'],
                  objectUrl: currentObject['url'],
                  distance: distance,
                  category: currentObject['category'],
                  nameRu: currentObject['name_ru'],
                  nameEn: currentObject['name_en'],
                  wikiRu: currentObject['wiki_ru'],
                  wikiEn: currentObject['wiki_en'],
                  imgUrl: imageUrl,
                  address: currentObject['address'],
                  onGoToObject: widget.onGoToObject,
                );
              }
              else{
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 30.0),
                  child: Center(
                    child: Text(
                      "Ничего не найдено",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      );
    }
  }
}
