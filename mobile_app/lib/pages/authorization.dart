import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json, base64, ascii;
import 'package:mobile_app/config.dart';
import 'package:mobile_app/pages/profile.dart';


class User extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void displayDialog(context, title, text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
            title: Text(title),
            content: Text(text)
        ),
  );

  Future<Map> attemptLogIn(String username, String password) async {
    var res = await http.post(
        Uri.http(SERVER_URL, '/auth/jwt/create/'),
        body: {
          "username": username,
          "password": password
        }
    );
    if(res.statusCode == 200) return json.decode(res.body);
    return null;
  }

  Future<int> attemptSignUp(String email,String username, String password) async {
    var res = await http.post(
        Uri.http(SERVER_URL, '/auth/users/'),
        body: {
          "email": email,
          "username": username,
          "password": password
        }
    );
    return res.statusCode;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:Text("News"),
          centerTitle: true,
          backgroundColor: Colors.deepPurpleAccent[700],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
            TextField(
            controller: _emailController,
            decoration: InputDecoration(
                labelText: 'E-mail'
            ),
          ),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                    labelText: 'Username'
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password'
                ),
              ),
              TextButton(
                  onPressed: () async {
                    var username = _usernameController.text;
                    var password = _passwordController.text;
                    var jwt = await attemptLogIn(username, password);
                    print(jwt["access"]);
                    print(jwt["refresh"]);
                    if(jwt != null) {
                      storage.write(key: "access_jwt", value: jwt["access"]);
                      storage.write(key: "refresh_jwt", value: jwt["refresh"]);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Profile()
                          )
                      );
                    } else {
                      displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
                    }
                  },
                  child: Text("Log In")
              ),
              TextButton(
                  onPressed: () async {
                    var username = _usernameController.text;
                    var password = _passwordController.text;
                    var email = _emailController.text;
                    await attemptSignUp(email,username, password);
                    },
                    child: Text("Sign Up")
              ),
            ],
          ),
        )
    );
  }
}