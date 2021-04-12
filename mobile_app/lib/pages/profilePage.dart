import 'package:flutter/material.dart';
import 'package:mobile_app/components/Button.dart';
import 'package:mobile_app/config.dart';
import 'package:mobile_app/tools.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert' show json;
import 'package:mobile_app/config.dart';

import '../tools.dart';
import '../tools.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback onLogOutPressed;

  ProfilePage({@required this.onLogOutPressed});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  String name, email, rank, dateJoined, id;
  String points;
  Future<void> getProfile() async {
    var resGetUrl = await serverRequest("get", "auth/users/me", null);
    id = resGetUrl["id"].toString();
    Map res = await serverRequest("get", "accounts/profile/" + id, null);
    Map data = res["user"];
    name = data["username"];
    email = data["email"];
    rank = res["rank"];
    points = res["points"].toString();
    dateJoined = DateFormat('EEEE d MMMM H:mm')
        .format(DateTime.parse(data["date_joined"]));
  }

  @override
  Widget build(BuildContext context) {
    getProfile();
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 85,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                ),
                SizedBox(height: 30),
                Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Welcome back, ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)
                      ),
                      TextSpan(
                          text: name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)
                      ),
                    ],
                  ),

                ),
                Card(
                    color: Colors.white70,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.calendar_today,
                        color: Colors.deepPurple[900],
                      ),
                      title: Text(
                        dateJoined,
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 22,color: Colors.black),
                      ),
                    )),
                Card(
                    color: Colors.white70,
                    margin:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.email,
                        color: Colors.deepPurple[900],
                      ),
                      title: Text(
                        email,
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 22,color: Colors.black),
                      ),
                    )),
                Card(
                    color: Colors.white70,
                    margin:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.star,
                        color: Colors.deepPurple[900],
                      ),
                      title: Text(
                        "Rank: "+rank+", Points: "+points,
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 22,color: Colors.black),
                      ),
                    )),
                Button(
                    text: "LOG OUT",
                    press: () {
                      widget.onLogOutPressed();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
