import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';


bool backgroundServiceRunning = false;


void startBackgroundService() async {
  if (Platform.isAndroid){
    var methodChannel = MethodChannel("com.identified.mw_insider");
    String data = await methodChannel.invokeMethod("startService");
    backgroundServiceRunning = true;
    debugPrint(data);
  }
}


void stopBackgroundService() async {
  if (Platform.isAndroid){
    var methodChannel = MethodChannel("com.identified.mw_insider");
    String data = await methodChannel.invokeMethod("stopService");
    backgroundServiceRunning = false;
    debugPrint(data);
  }
}


void switchBackgroundService(){
  if (backgroundServiceRunning)
    stopBackgroundService();
  else
    startBackgroundService();
}
