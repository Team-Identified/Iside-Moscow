import 'package:mw_insider/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json, utf8;
import 'authorizationService.dart';


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
