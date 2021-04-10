import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/components/NearbyMap.dart';
import 'package:mobile_app/components/locationPermissionErrorPage.dart';
import 'package:mobile_app/config.dart';
import 'package:mobile_app/tools.dart';
import 'package:mobile_app/components/nearbyObjectsList.dart';


class HomePage extends StatefulWidget {
  final void Function(int) onGoToObject;

  HomePage({Key key, @required this.onGoToObject}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool updateTrigger = false;

  Future<String> getLocation() async{
    bool locationWorking = await canGetLocation();
    if (locationWorking) {
      if (locationData == null){
        await updateLocation();
      }
      return "location updated";
    }
    else return "location error";
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          centerTitle: true,
          backgroundColor: themeColor,
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder<String>(
          future: getLocation(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData && snapshot.data == "location updated") {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 7.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        child: NearbyMap(height: screenHeight / 3)
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      " Nearby Objects",
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
                            child: NearbyObjectsList(onGoToObject: widget.onGoToObject)
                        )
                    ),
                  ],
                ),
              );
            }
            else if (snapshot.hasData && snapshot.data == "location error"){
              return LocationPermissionErrorPage(
                updateFunction: () {
                  setState(() {
                    updateTrigger = !updateTrigger;
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
