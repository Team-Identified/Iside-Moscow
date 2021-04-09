import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:mobile_app/config.dart';
import 'package:mobile_app/components/Button.dart';
import 'package:mobile_app/components/AlreadyHaveAnAccount.dart';

void displayDialog(context, title, text) => showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(title: Text(title), content: Text(text)),
    );

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final VoidCallback onSignUpButtonPressed;
  final VoidCallback onSubmitButtonPressed;

  LoginPage(
      {@required this.onSignUpButtonPressed,
      @required this.onSubmitButtonPressed});

  Future<Map> attemptLogIn(String username, String password) async {
    var res = await http.post(Uri.http(SERVER_URL, '/auth/jwt/create/'),
        body: {"username": username, "password": password});
    int statusCode = res.statusCode;
    Map body = json.decode(res.body);
    return {"statuscode": statusCode, "body": body};
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
            text: "LOGIN",
            press: () async {
              String username = _usernameController.text;
              String password = _passwordController.text;
              Map res = await attemptLogIn(username, password);
              Map body = res["body"];
              int statusCode = res["statuscode"];
              String title = "Error";
              if (statusCode >= 400) {
                if (body.containsKey("username")) {
                  displayDialog(context, title, "Your username can't be blank");
                } else if (body.containsKey("password")) {
                  displayDialog(context, title, "Your password can't be blank");
                } else if (body.containsKey("detail")) {
                  displayDialog(context, title, body["detail"]);
                } else {
                  displayDialog(context, title, "Unknown error happened");
                }
              }
              if (statusCode == 200) {
                storage.write(key: "access_jwt", value: body["access"]);
                storage.write(key: "refresh_jwt", value: body["refresh"]);
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
