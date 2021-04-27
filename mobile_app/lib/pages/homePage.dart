import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw_insider/components/NearbyMap.dart';
import 'package:mw_insider/components/locationPermissionErrorPage.dart';
import 'package:mw_insider/services/locationService.dart';
import 'package:mw_insider/components/nearbyObjectsList.dart';
import 'package:mw_insider/services/permissionService.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  final void Function(int) onGoToObject;

  HomePage({Key key, @required this.onGoToObject}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool updateTrigger = false;
  dynamic locationData;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    locationData = Provider.of<UserLocation>(context);

    return FutureBuilder<bool>(
      future: checkLocationPermission(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data){
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: NearbyMap(height: screenHeight / 3),
                ),
                SizedBox(
                  height: 3.0,
                  child: Container(color: Colors.deepPurple)),
                Flexible(
                    child: Container(
                        color: Colors.grey[300],
                        child: NearbyObjectsList(onGoToObject: widget.onGoToObject)
                    )
                ),
              ],
            ),
          );
        }
        else if (snapshot.hasData && !snapshot.data && locationData.loaded == true){
          return LocationPermissionErrorPage(
            updateFunction: () {
              setState(() {
                updateTrigger = !updateTrigger;
                LocationService();
              });
            },
          );
        }
        else{
          return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                    ),
                    SizedBox(height: 20.0),
                    Text("Loading", style: TextStyle(fontSize: 20.0)),
                  ]
              )
          );
        }
      },
    );
  }
}
