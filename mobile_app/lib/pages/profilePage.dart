import 'package:flutter/material.dart';
import 'package:mobile_app/config.dart';
import 'package:mobile_app/tools.dart';


class ProfilePage extends StatefulWidget {
  final VoidCallback onLogOutPressed;

  ProfilePage({@required this.onLogOutPressed});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:
        Scaffold(
          appBar: AppBar(
            title:Text("Profile"),
            centerTitle: true,
            backgroundColor: themeColor,
          ),
          backgroundColor: Colors.grey[300],
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Profile page'),
                TextButton(
                  onPressed: () {
                    logOut();
                    widget.onLogOutPressed();
                  },
                  child: Text("LOG OUT")
                ),
              ],
            ),
          ),
        )
    );
  }
}