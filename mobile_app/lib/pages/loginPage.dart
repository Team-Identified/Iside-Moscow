import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:mobile_app/config.dart';
import 'package:mobile_app/components/Button.dart';
import 'package:mobile_app/components/AlreadyHaveAnAccount.dart';


void displayDialog(context, title, text) => showDialog(
  context: context,
  builder: (context) =>
      AlertDialog(
          title: Text(title),
          content: Text(text)
      ),
);

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final VoidCallback onSignUpButtonPressed;
  final VoidCallback onSubmitButtonPressed;

  LoginPage({@required this.onSignUpButtonPressed, @required this.onSubmitButtonPressed});

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 0.03),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20.0),
                  border: InputBorder.none,
                  hintText: 'Username'
              ),
            ),
            SizedBox(height: 0.03),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20.0),
                  border: InputBorder.none,
                  hintText: 'Password'
              ),
            ),
            Button(
              text: "LOGIN",
              press: () async {
                var username = _usernameController.text;
                var password = _passwordController.text;
                var jwt = await attemptLogIn(username, password);
                if(jwt != null) {
                  storage.write(key: "access_jwt", value: jwt["access"]);
                  storage.write(key: "refresh_jwt", value: jwt["refresh"]);
                  onSubmitButtonPressed();
                }
                },
            ),
            SizedBox(height: 0.03),
            AlreadyHaveAnAccount(
              press: () {
                onSignUpButtonPressed();
              },
            ),
          ],
        ),
    );
  }
}