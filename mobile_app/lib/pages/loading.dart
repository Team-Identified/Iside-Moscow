import 'package:flutter/material.dart';
import "package:mobile_app/services/classNews.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  News test = News();


  void setUpTime() async {
    await test.getData();
    Navigator.pushReplacementNamed(context, '/app', arguments:{'data': test});
  }

  // ignore: non_constant_identifier_names
  @override
  void initState() {
    super.initState();
    setUpTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: SpinKitPouringHourglass(
            color: Colors.white,
            size: 50.0,
          )
        )
        ),
      );
  }

}