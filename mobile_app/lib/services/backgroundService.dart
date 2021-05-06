import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';


bool backgroundServiceRunning = false;


Future<void> startBackgroundService() async {
  if (Platform.isAndroid){
    var methodChannel = MethodChannel("com.identified.mw_insider");
    String data = await methodChannel.invokeMethod("startService");
    backgroundServiceRunning = true;
    debugPrint(data);
  }
}


Future<void> stopBackgroundService() async {
  if (Platform.isAndroid){
    var methodChannel = MethodChannel("com.identified.mw_insider");
    String data = await methodChannel.invokeMethod("stopService");
    backgroundServiceRunning = false;
    debugPrint(data);
  }
}


Future<bool> switchBackgroundService() async {
  if (backgroundServiceRunning)
    await stopBackgroundService();
  else
    await startBackgroundService();
  return backgroundServiceRunning;
}
