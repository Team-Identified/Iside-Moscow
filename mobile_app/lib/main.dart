import 'package:flutter/material.dart';
import 'package:mw_insider/components/bottomAppBar.dart';
import 'package:mw_insider/services/backgroundService.dart';
import 'package:mw_insider/services/locationService.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(Main());
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused){
      print("============== APP PAUSED ==================");
    }
    else if (state == AppLifecycleState.resumed){
      print("============== APP RESUMED ==================");
    }
  }


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
