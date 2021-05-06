import 'package:flutter/material.dart';
import 'package:mw_insider/components/bottomAppBar.dart';
import 'package:mw_insider/components/mainLoadingPage.dart';
import 'package:mw_insider/pages/userPage.dart';
import 'package:mw_insider/services/authorizationService.dart';
import 'package:mw_insider/services/locationService.dart';
import 'package:mw_insider/services/permissionService.dart';
import 'package:provider/provider.dart';
import 'components/locationPermissionErrorPage.dart';


LocationService locationService = LocationService();


void main() {
  runApp(Main());
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> with WidgetsBindingObserver {
  bool loggedIn;
  bool permissionGranted;
  bool loading = true;
  Widget logPage;
  Widget permissionPage;
  bool updateTrigger = false;


  void loadData() async {
    bool myLoggedIn = await isLoggedIn();
    bool myPermissionGranted = await checkLocationPermission();

    print("LOGGED: $myLoggedIn, PERMISSION: $myPermissionGranted");

    if (loggedIn != myLoggedIn || permissionGranted != myPermissionGranted){
      setState(() {
        loggedIn = myLoggedIn;
        permissionGranted = myPermissionGranted;
        loading = false;
      });
    }
  }

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
      setState(() {
        updateTrigger = !updateTrigger;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    loadData();

    if (loading){
      return LoadingPage();
    }
    else{
      if (!loggedIn){
        return MaterialApp(home: UserPage(afterLogIn: () {
            setState(() {
              loggedIn = true;
            });
          }),
        );
      }
      else if (!permissionGranted){
        return MaterialApp(home: LocationPermissionErrorPage(),);
      }
    }
    return StreamProvider<UserLocation>.value(
      initialData: UserLocation(),
      value: locationService.locationStream,
      child: MaterialApp(
        home: CustomBottomAppBar(updateFunction: () {
          setState(() {
            updateTrigger = !updateTrigger;
          });
        },),
      ),
    );
  }
}
