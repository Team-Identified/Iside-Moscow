import 'package:mobile_app/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;


void refreshAccess() async {
  var res = await http.post(
      Uri.http(SERVER_URL, '/auth/jwt/refresh/'),
      body: {
        "refresh": storage.read(key: "refresh")
      }
  );
  if(res.statusCode == 200) {
    String access = json.decode(res.body)["access"];
    storage.write(key: "access_jwt", value: access);
  }
}


void checkToken() async{
  String accessToken = await storage.read(key: "access");
  var res = await http.post(
      Uri.http(SERVER_URL, '/auth/jwt/verify/'),
      body: {
        "token":  accessToken,
      }
  );
  if(res.statusCode != 200) {
    refreshAccess();
  }
}


Future<Map> serverRequest(String type, Map data, String url) async{
  await checkToken();
  String accessToken = await storage.read(key: "access");
  String authData = "Bearer " + accessToken;
  var res;
  if (type == "post"){
    res = await http.post(
        Uri.http(SERVER_URL, url),
        body: data,
        headers:{
          "Authorization": authData,
        }
    );
  }
  else if (type == "get"){
    res = await http.get(
        Uri.http(SERVER_URL, url),
        headers:{
          "Authorization": authData,
        }
    );
  }
  else if (type == "patch"){
    res = await http.patch(
        Uri.http(SERVER_URL, url),
        body: data,
        headers:{
          "Authorization": authData,
        }
    );
  }
  Map resData = json.decode(res.body);
  return resData;
}