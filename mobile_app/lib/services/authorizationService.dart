import 'package:mw_insider/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;


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
