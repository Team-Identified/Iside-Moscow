import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';


bool serviceEnabled;
LocationPermission permissionGranted;
Location location = Location();


Future<bool> checkLocationPermission() async {
  serviceEnabled = await checkService();
  if (!serviceEnabled) {
    return false;
  }

  permissionGranted = await Geolocator.checkPermission();
  return permissionGranted == LocationPermission.always;
}


Future<bool> checkService() async {
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return false;
    }
  }
  return true;
}


Future<bool> getAlwaysPermission() async {
  permissionGranted = await Geolocator.checkPermission();
  if (permissionGranted != LocationPermission.always){
    await AppSettings.openAppSettings();
    permissionGranted = await Geolocator.checkPermission();
  }
  print(permissionGranted);
  return permissionGranted == LocationPermission.always;
}
