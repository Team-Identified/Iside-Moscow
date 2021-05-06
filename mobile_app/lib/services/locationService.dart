import 'dart:async';
import 'package:location/location.dart';
import 'package:mw_insider/config.dart';
import 'package:mw_insider/services/notificationService.dart';
import 'package:mw_insider/services/permissionService.dart';


class UserLocation{
  final double latitude;
  final double longitude;
  final bool loaded;

  UserLocation({this.latitude, this.longitude, this.loaded=false});
}


class LocationService{
  // Keep track of current location
  UserLocation _currentLocation;
  int currentTime = (new DateTime.now()).millisecondsSinceEpoch;
  int lastUpdateTime = 0;
  int minUpdateDeltaTime = LOCATION_UPDATE_MIN_DELTA;

  //Continuously emit location updates
  StreamController<UserLocation> _locationController =
  StreamController<UserLocation>.broadcast();

  UserLocation loadingUserLocation = UserLocation(
    latitude: null,
    longitude: null,
    loaded: false,
  );

  void onDataReceived(LocationData locationData){
    if (locationData != null){
      currentTime = (new DateTime.now()).millisecondsSinceEpoch;
      if (currentTime - lastUpdateTime > minUpdateDeltaTime || _currentLocation == null){
        lastUpdateTime = currentTime;
        checkNearbyObjectNotification(locationData);
        _currentLocation = UserLocation(
          latitude: locationData.latitude,
          longitude: locationData.longitude,
          loaded: true,
        );
        _locationController.add(_currentLocation);
      }
    }
  }

  LocationService(){
    _locationController.add(loadingUserLocation);

    checkLocationPermission().then((canGet) {
      if (canGet){
        location.onLocationChanged.listen((locationData) {
          onDataReceived(locationData);
        });
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

  void requestLocationUpdate() async {
    UserLocation resLocation = await getLocation();
    if (isUseful(resLocation)){
      _locationController.add(_currentLocation);
    }
  }
}

bool isUseful(UserLocation locationData){
  if (
  locationData != null
  && locationData.loaded
  && locationData.latitude != null
  && locationData.longitude != null
  )
    return true;
  else
    return false;
}
