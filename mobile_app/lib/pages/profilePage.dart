import 'package:flutter/material.dart';
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
  int points;
  Future<void> getProfile() async {
    var res_get_url = await serverRequest("get", "auth/users/me", null);
    id = res_get_url["id"].toString();
    var res = await serverRequest("get", "/accounts/profile/" + id, null);
    var data = res["user"];
    name = data["username"];
    email = data["email"];
    rank=res["rank"];
    points=res["points"];
    dateJoined = DateFormat('EEEE d MMMM H:mm')
        .format(DateTime.parse(data["date_joined"]));
  }

  @override
  Widget build(BuildContext context) {
    getProfile();
    print(rank);
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/LogoAsMetroName_noF.png"),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black),
              ),
            ),
            SizedBox(height: 10),
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(text: 'Name: ', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22
                  )),
                  TextSpan(text: name, style: TextStyle(
                      fontSize: 22
                  )),

                ],
              ),
            ),
            SizedBox(height: 10),
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(text: 'Joined: '+dateJoined, style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                  )),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(text: 'E-mail: ', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22
                  )),
                  TextSpan(text: email, style: TextStyle(
                      fontSize: 22
                  )),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(text: 'Rank: ', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22
                  )),
                  TextSpan(text: rank, style: TextStyle(
                      fontSize: 22
                  )),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(text: 'Points: ', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22
                  )),
                  TextSpan(text: points.toString(), style: TextStyle(
                      fontSize: 22
                  )),
                ],
              ),
            ),
            SizedBox(height: 10),
            TextButton(
                onPressed: () {
                  widget.onLogOutPressed();
                },
                child: Text("LOG OUT")),
          ],
        ),
      ),
    ));
  }
}
