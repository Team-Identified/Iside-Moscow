import 'dart:math';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mobile_app/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json, utf8;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


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


Future<void> logOut() async{
  await storage.delete(key: 'refresh_jwt');
  await storage.delete(key: 'access_jwt');
}


Future<void> checkToken() async{
  bool hasRefreshToken = await storage.containsKey(key: "refresh_jwt");
  bool hasAccessToken = await storage.containsKey(key: "access_jwt");

  if (!hasRefreshToken){
    await logOut();
    return;
  }

  if (!hasAccessToken) {
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
  final bool isLogged = await isLoggedIn();

  String authData;
  if (isLogged) {
    await checkToken();
    String accessToken = await storage.read(key: "access_jwt");
    authData = "Bearer " + accessToken;
  }

  final String dataJson = json.encode(data);

  Map<String, String> headers;
  if (isLogged) {
    headers = {
      "Content-Type": "application/json",
      "Authorization": authData,
    };
  }
  else {
    headers = {
      "Content-Type": "application/json",
    };
  }

  var response;
  if (type == "post"){
    response = await http.post(
        Uri.http(SERVER_URL, url),
        body: dataJson,
        headers: headers,
    );
  }
  else if (type == "get"){
    response = await http.get(
        Uri.http(SERVER_URL, url),
        headers: headers,
    );
  }
  else if (type == "patch"){
    response = await http.patch(
        Uri.http(SERVER_URL, url),
        body: dataJson,
        headers: headers,
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


String capitalize(String line) {
  return "${line[0].toUpperCase()}${line.substring(1)}";
}


IconData getIcon(String category){
  IconData iconObj;
  if (category == "monument")
    iconObj = Icons.account_circle;
  else if (category == "theatre")
    iconObj = Icons.theater_comedy;
  else if (category == "museum")
    iconObj = Icons.museum;
  else if (category == "government building")
    iconObj = Icons.account_balance;
  else if (category == "mall")
    iconObj = Icons.local_mall;
  else if (category == "red square object")
    iconObj = Icons.star;
  else if (category == "religious building")
    iconObj = MdiIcons.bookCross;
  else if (category == "restaurant")
    iconObj = MdiIcons.silverwareForkKnife;
  else if (category == "skyscraper")
    iconObj = MdiIcons.officeBuilding;
  else if (category == "stadium")
    iconObj = MdiIcons.stadium;
  else if (category == "unknown")
    iconObj = MdiIcons.helpCircle;
  else
    iconObj = Icons.location_on;

  return iconObj;
}


int calculateDistance(lat1, lon1, lat2, lon2){
  const double r = 6371e3;
  final double f1 = lat1 * pi / 180;
  final double f2 = lat2 * pi / 180;
  final double df = (lat2 - lat1) * pi / 180;
  final double dy = (lon2 - lon1) * pi / 180;

  final double a = sin(df / 2) * sin(df / 2) + cos(f1) * cos(f2) * sin(dy / 2) * sin(dy / 2);
  final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  final double d = r * c;
  int distance = d.round();
  return distance;
}
