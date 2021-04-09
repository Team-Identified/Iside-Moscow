import 'package:mobile_app/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json, utf8;
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';


Future<void> refreshAccess() async {
  var response = await http.post(
      Uri.http(SERVER_URL, '/auth/jwt/refresh/'),
      body: {
        "refresh": await storage.read(key: "refresh_jwt")
      }
  );
  if(response.statusCode == 200) {
    String access = json.decode(response.body)["access"];
    await storage.write(key: "access_jwt", value: access);
  }
}


Future<bool> isLoggedIn() async {
  bool hasToken = await storage.containsKey(key: "access_jwt");
  if (!hasToken)
    return false;

  String accessToken = await storage.read(key: "access_jwt");
  var response = await http.post(
      Uri.http(SERVER_URL, '/auth/jwt/verify/'),
      body: {
        "token":  accessToken,
      }
  );
  return response.statusCode == 200;
}


Future<void> checkToken() async{
  bool hasToken = await storage.containsKey(key: "access_jwt");
  if (!hasToken) {
    await refreshAccess();
    return;
  }

  String accessToken = await storage.read(key: "access_jwt");
  var response = await http.post(
      Uri.http(SERVER_URL, '/auth/jwt/verify/'),
      body: {
        "token":  accessToken,
      }
  );

  if(response.statusCode != 200) {
    await refreshAccess();
  }
}


Future<Map> serverRequest(String type, String url, Map data) async{
  await checkToken();
  String accessToken = await storage.read(key: "access_jwt");
  String authData = "Bearer " + accessToken;

  final String dataJson = json.encode(data);

  var response;
  if (type == "post"){
    response = await http.post(
        Uri.http(SERVER_URL, url),
        body: dataJson,
        headers:{
          "Content-Type": "application/json",
          "Authorization": authData,
        }
    );
  }
  else if (type == "get"){
    response = await http.get(
        Uri.http(SERVER_URL, url),
        headers:{
          "Authorization": authData,
        }
    );
  }
  else if (type == "patch"){
    response = await http.patch(
        Uri.http(SERVER_URL, url),
        body: dataJson,
        headers:{
          "Content-Type": "application/json",
          "Authorization": authData,
        }
    );
  }
  Map resData = json.decode(utf8.decode(response.bodyBytes));
  return resData;
}


void tryLaunch(String url) async{
  // bool ability = await canLaunch(url);
  // if (ability){
  //   await launch(url);
  // }
  await launch(url);
}


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

bool serviceEnabled;
PermissionStatus permissionGranted;
LocationData locationData;

Future<void> updateLocation() async{
  bool canGet = await canGetLocation();
  if (canGet) {
    locationData = await location.getLocation();
    print("LOCATION UPDATED");
  }
}
