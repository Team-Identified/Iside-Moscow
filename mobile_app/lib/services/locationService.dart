import 'dart:async';
import 'package:location/location.dart';
import 'package:mobile_app/config.dart';


class UserLocation{
  final double latitude;
  final double longitude;
  final bool loaded;

  UserLocation({this.latitude, this.longitude, this.loaded});
}


class LocationService{
  // Keep track of current location
  UserLocation _currentLocation;

  var location = Location();
  var serviceEnabled;
  var permissionGranted;
  int currentTime = (new DateTime.now()).millisecondsSinceEpoch;
  int lastUpdateTime = 0;
  int minUpdateDeltaTime = LOCATION_UPDATE_MIN_DELTA;


  Future<bool> canGetLocation() async{
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  //Continuously emit location updates
  StreamController<UserLocation> _locationController =
    StreamController<UserLocation>.broadcast();

  LocationService(){
    _locationController.add(UserLocation(
      latitude: null,
      longitude: null,
      loaded: false,
    ));

    canGetLocation().then((canGet) {
      if (canGet){
        location.onLocationChanged.listen((locationData) {
          if (locationData != null){
            currentTime = (new DateTime.now()).millisecondsSinceEpoch;
            if (currentTime - lastUpdateTime > minUpdateDeltaTime){
              print("LOCATION UPDATED");
              lastUpdateTime = currentTime;
              _locationController.add(UserLocation(
                latitude: locationData.latitude,
                longitude: locationData.longitude,
                loaded: true,
              ));
            }
          }
        });
      }
      else{
        _locationController.add(UserLocation(
          latitude: null,
          longitude: null,
          loaded: true,
        ));
      }
    });
  }

  Stream<UserLocation> get locationStream => _locationController.stream;

  Future<UserLocation> getLocation() async {
    try{
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
    }catch(e){
      print("Could not get the location $e");
    }

    return _currentLocation;
  }
}