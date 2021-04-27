import 'package:geolocator/geolocator.dart';


int calculateDistance(lat1, lon1, lat2, lon2){
  final double d = Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  int distance = d.round();
  return distance;
}
