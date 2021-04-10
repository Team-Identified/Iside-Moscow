import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/config.dart';
import 'package:mobile_app/tools.dart';
import 'dart:math';


class NearbyObjectsList extends StatefulWidget {
  final void Function(int) onGoToObject;

  NearbyObjectsList({Key key, @required this.onGoToObject}) : super(key: key);

  @override
  _NearbyObjectsListState createState() => _NearbyObjectsListState();
}

class _NearbyObjectsListState extends State<NearbyObjectsList> {
  List<dynamic> nearbyObjects = [];

  Future<void> loadData() async{
    Map requestData = {
      "latitude": locationData.latitude,
      "longitude": locationData.longitude,
    };
    Map response = await serverRequest('post', 'geo_objects/get_nearby_objects', requestData);
    setState(() {
      nearbyObjects = response['objects'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: max(nearbyObjects.length, 1),
      separatorBuilder: (BuildContext context, int index){
        return SizedBox(height: 8.0);
      },
      itemBuilder: (context, index){
        if (nearbyObjects.length > 0) {
          Map currentObject = nearbyObjects[index]['object'];
          String imageUrl = currentObject['image_url'] == null ? animeGirlsUrl : currentObject['image_url'];
          return ObjectCard(
            id: currentObject['id'],
            objectUrl: currentObject['url'],
            distance: nearbyObjects[index]['distance'],
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
          loadData();
          return Container(
            child: Column(
              children: [
                SizedBox(height: 10.0),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                ),
                SizedBox(height: 15.0),
              ],
            ),
          );
        }
      },
    );
  }
}

class ObjectCard extends StatelessWidget {
  final int id;
  final String objectUrl;
  final int distance;
  final String category;
  final String nameRu;
  final String nameEn;
  final String wikiRu;
  final String wikiEn;
  final String imgUrl;
  final String address;
  final void Function(int) onGoToObject;



  const ObjectCard({
    this.id,
    this.objectUrl,
    this.distance,
    this.category,
    this.nameRu,
    this.nameEn,
    this.wikiRu,
    this.wikiEn,
    this.imgUrl,
    this.address,
    this.onGoToObject,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: (){
        onGoToObject(id);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 10.0),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nameRu,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            Text(
              nameEn,
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
            Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          getIcon(category),
                          color: Colors.blueGrey,
                        ),
                        Container(
                          width: screenWidth * 0.6,
                          child: Text(
                            capitalize(category),
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.blueGrey,
                        ),
                        Container(
                          width: screenWidth * 0.6,
                          child: Text(
                            capitalize(address),
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.directions_walk_outlined,
                          color: Colors.blueGrey,
                        ),
                        Container(
                          width: screenWidth * 0.6,
                          child: Text(
                            "${distance.toString()}m",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 100.0,
                  height: 100.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.network(
                      imgUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace){
                        return Image.network(
                          animeGirlsUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress){
                            return progress == null
                                ? child
                                : Container(
                              color: Colors.grey[300],
                              padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 0.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace){
                            return Container(
                              color: Colors.grey[300],
                              padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 0.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      loadingBuilder: (context, child, progress){
                        return progress == null
                            ? child
                            : Container(
                          color: Colors.grey[300],
                          padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 0.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

