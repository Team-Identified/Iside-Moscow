import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:location/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


Color themeColor = Colors.deepPurpleAccent.shade700;

 // const String SERVER_URL = "10.0.2.2:8000";
const String SERVER_URL = "192.168.1.215:8000";

final storage = FlutterSecureStorage();

const String animeGirlsUrl = "https://i09.kanobu.ru/r/98337ae40ef114cf07c92cac8dbb9688/1040x700/u.kanobu.ru/editor/images/51/c48787a0-4259-47a3-b32a-ddb4f311c753.jpg";

Location location = new Location();

