import 'package:flutter/material.dart';
import 'package:mobile_app/config.dart';


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
            backgroundColor: Colors.deepPurpleAccent[700],
          ),
          backgroundColor: Colors.grey[300],
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Profile page'),
                TextButton(
                  onPressed: () {
                    storage.delete(key: 'refresh_jwt');
                    storage.delete(key: 'access_jwt');
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