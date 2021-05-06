import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mw_insider/config.dart';
import 'package:mw_insider/services/backendCommunicationService.dart';
import 'package:mw_insider/services/locationService.dart';
import 'package:latlong/latlong.dart';
import 'package:mw_insider/services/uiService.dart';
import 'package:provider/provider.dart';


class NearbyMap extends StatefulWidget {
  final double height;

  NearbyMap({this.height});

  @override
  _NearbyMapState createState() => _NearbyMapState();
}

class _NearbyMapState extends State<NearbyMap> {
  var locationData;

  Future<Map> loadData() async{
    if (!isUseful(locationData)){
      return {
        "nearbyObjects": [],
        "userLocation": null,
      };
    }

    Map requestData = {
      "latitude": locationData.latitude,
      "longitude": locationData.longitude,
    };

    Map response = await serverRequest('post', 'geo_objects/get_nearby_objects', requestData);
    List<Map<String, dynamic>> objectPoints = [];
    for (int i = 0; i < response['objects'].length; ++i){
      Map<String, dynamic> point = {
        "latitude": response['objects'][i]['object']['latitude'],
        "longitude": response['objects'][i]['object']['longitude'],
        "category": response['objects'][i]['object']['category'],
      };
      objectPoints.add(point);
    }
    Map data = {
      "nearbyObjects": objectPoints,
      "userLocation": requestData,
    };

    return data;
  }

  @override
  Widget build(BuildContext context) {
    locationData = Provider.of<UserLocation>(context);

    return FutureBuilder<Map>(
      future: loadData(),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData && isUseful(locationData)){
          List<Marker> markers = [];
          for (int i = 0; i < snapshot.data['nearbyObjects'].length; ++i){
            double markerLat = snapshot.data['nearbyObjects'][i]['latitude'];
            double markerLon = snapshot.data['nearbyObjects'][i]['longitude'];
            String markerCategory = snapshot.data['nearbyObjects'][i]['category'];

            IconData markerIconData = getIcon(markerCategory);

            Marker marker = Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(markerLat, markerLon),
              builder: (ctx) =>
                  Container(
                    child: Icon(markerIconData, color: themeColor),
                  ),
            );
            markers.add(marker);
          }

          Marker myMarker = Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(locationData.latitude, locationData.longitude),
            builder: (ctx) =>
                Container(
                  child: Icon(Icons.location_on, color: Colors.redAccent, size: 40.0,),
                ),
          );
          markers.add(myMarker);

          return Container(
            height: widget.height,
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(locationData.latitude, locationData.longitude),
                zoom: 13.5,
              ),
              layers: [
                TileLayerOptions(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']
                ),
                MarkerLayerOptions(
                  markers: markers,
                ),
              ],
            ),
          );
        }
        else{
          return Container(
            height: widget.height,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(themeColorShade),
              ),
            ),
          );
        }
      },
    );
  }
}
