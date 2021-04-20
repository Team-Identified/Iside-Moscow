import 'package:flutter/material.dart';
import 'package:mobile_app/components/bottomAppBar.dart';
import 'package:mobile_app/services/locationService.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserLocation>.value(
      initialData: UserLocation(),
      value: LocationService().locationStream,
      child: new MaterialApp(
        home: CustomBottomAppBar(),
      ),
    );
  }
}



