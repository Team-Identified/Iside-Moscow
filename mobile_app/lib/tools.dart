import 'package:mobile_app/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json, utf8;


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
  var response;
  if (type == "post"){
    response = await http.post(
        Uri.http(SERVER_URL, url),
        body: data,
        headers:{
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
        body: data,
        headers:{
          "Authorization": authData,
        }
    );
  }
  Map resData = json.decode(utf8.decode(response.bodyBytes));
  return resData;
}