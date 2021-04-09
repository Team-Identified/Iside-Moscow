import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mobile_app/components/NearbyMap.dart';
import 'package:mobile_app/config.dart';
import 'package:mobile_app/tools.dart';
import 'package:mobile_app/components/nearbyObjectsList.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<String> getLocation() async{
    if (locationData == null)
      await updateLocation();
    return "location updated";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          centerTitle: true,
          backgroundColor: Colors.deepPurpleAccent[700],
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder<String>(
          future: getLocation(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: NearbyMap(height: 300.0),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "Nearby Objects",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 21.0,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    SizedBox(
                      height: 3.0,
                      child: Container(color: Colors.deepPurple,),),
                    Flexible(
                        child: Container(
                            color: Colors.grey[300],
                            child: NearbyObjectsList()
                        )
                    ),
                  ],
                ),
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
                        Text("Loading", style: TextStyle(fontSize: 20.0),),
                      ]
                  )
              );
            }
          }
        ),
      ),
    );
  }
}
