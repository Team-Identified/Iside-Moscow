import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location/location.dart';
import 'package:mw_insider/config.dart';
import 'package:mw_insider/services/notificationService.dart';
import 'package:mw_insider/services/permissionService.dart';


class UserLocation{
  final double latitude;
  final double longitude;
  final bool loaded;

  UserLocation({this.latitude, this.longitude, this.loaded});
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

  UserLocation emptyUserLocation = UserLocation(
    latitude: null,
    longitude: null,
    loaded: true,
  );

  LocationService(){
    _locationController.add(loadingUserLocation);

    checkLocationPermission().then((canGet) {
      if (canGet){
        location.onLocationChanged.listen((locationData) {
          if (locationData != null){
            currentTime = (new DateTime.now()).millisecondsSinceEpoch;
            if (currentTime - lastUpdateTime > minUpdateDeltaTime){
              checkNearbyObjectNotification(locationData);
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
        _locationController.add(emptyUserLocation);
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
