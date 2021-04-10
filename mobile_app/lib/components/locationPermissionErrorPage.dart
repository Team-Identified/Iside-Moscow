import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/config.dart';
import 'package:mobile_app/tools.dart';
import 'package:app_settings/app_settings.dart';


class LocationPermissionErrorPage extends StatelessWidget {
  final VoidCallback updateFunction;

  const LocationPermissionErrorPage({@required this.updateFunction});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ERROR",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  width: screenWidth - 60.0,
                  child: Text(
                    "Please make sure that you have geolocation enabled and that this application has access to it.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  child: TextButton(
                    onPressed: () {
                      AppSettings.openLocationSettings();
                      updateFunction();
                    },
                    child: Text(
                      "Give permission",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: themeColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
