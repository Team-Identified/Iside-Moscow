import 'package:flutter/material.dart';
import 'package:mobile_app/components/BottomAppBar.dart';
import 'dart:async';
import 'package:mobile_app/tools.dart';


void main() {
  const locationUpdateFrequency = const Duration(minutes: 5);
  new Timer.periodic(locationUpdateFrequency, (Timer t) {
    updateLocation();
  });
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: CustomBottomAppBar(),
    );
  }
}



