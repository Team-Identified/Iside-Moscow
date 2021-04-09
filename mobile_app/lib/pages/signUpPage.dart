import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json, base64, ascii;
import 'package:mobile_app/config.dart';
import 'package:mobile_app/pages/loginPage.dart';
import 'package:mobile_app/components/Button.dart';
import 'package:mobile_app/components/AlreadyHaveAnAccount.dart';

import 'loginPage.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final VoidCallback onLogInButtonPressed;

  SignUpPage({@required this.onLogInButtonPressed});

  Future<Map> attemptSignUp(
      String email, String username, String password) async {
    var res = await http.post(Uri.http(SERVER_URL, '/auth/users/'),
        body: {"email": email, "username": username, "password": password});
    return {"body": json.decode(res.body), "statuscode": res.statusCode};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "SIGN UP",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.03),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20.0),
                border: InputBorder.none,
                hintText: 'E-mail'),
          ),
          SizedBox(height: 0.03),
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20.0),
                border: InputBorder.none,
                hintText: 'Username'),
          ),
          SizedBox(height: 0.03),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20.0),
                border: InputBorder.none,
                hintText: 'Password'),
          ),
          Button(
            text: "SIGN UP",
            press: () async {
              String email = _emailController.text;
              String username = _usernameController.text;
              String password = _passwordController.text;
              Map res = await attemptSignUp(email, username, password);
              int statusCode = res["statuscode"];
              Map body = res["body"];
              String title = "Error";
              if (statusCode == 201) {
                onLogInButtonPressed();
              }
              else if(statusCode>=400) {
                if (email.length == 0 || username.length == 0 || password.length == 0) {
                    displayDialog(context, title, "Please fill in every field given");
                }
                else if (body.containsKey("email")) {
                  displayDialog(context, title, body["email"][0]);
                }
                else if (body.containsKey("username")) {
                  displayDialog(context, title, body["username"][0]);
                }
                else if (body.containsKey("password")) {
                  displayDialog(context, title, body["password"][0]);
                }
              }
            },
          ),
          SizedBox(height: 0.03),
          AlreadyHaveAnAccount(
            login: false,
            press: () {
              onLogInButtonPressed();
            },
          ),
        ],
      ),
    );
  }
}
