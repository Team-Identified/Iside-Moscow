import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw_insider/config.dart';
import 'package:mw_insider/services/backgroundService.dart';


class TrackingSwitchButton extends StatefulWidget {
  @override
  _TrackingSwitchButtonState createState() => _TrackingSwitchButtonState();
}

class _TrackingSwitchButtonState extends State<TrackingSwitchButton> {
  bool serviceEnabled = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return  Container(
      width: screenWidth * 0.8,
      height: 60.0,
      child: TextButton(
        child: Text(
          backgroundServiceRunning ? "Завершить прогулку" : "Начать прогулку",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: themeColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
        onPressed: () async {
          bool result = await switchBackgroundService();
          setState(() {
            serviceEnabled = result;
          });
        },
      ),
    );
  }
}
