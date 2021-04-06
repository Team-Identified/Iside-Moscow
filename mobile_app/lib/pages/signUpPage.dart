import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json, base64, ascii;
import 'package:mobile_app/config.dart';
import 'package:mobile_app/pages/loginPage.dart';
import 'package:mobile_app/components/Button.dart';
import 'package:mobile_app/components/AlreadyHaveAnAccount.dart';


class SignUpPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final VoidCallback onLogInButtonPressed;

  SignUpPage({@required this.onLogInButtonPressed});

  Future<int> attemptSignUp(String email, String username, String password) async {
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
                hintText: 'E-mail'
            ),
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
            text: "SIGN UP",
            press: () async {
              String email = _emailController.text;
              String username = _usernameController.text;
              String password = _passwordController.text;
              int res = await attemptSignUp(email, username, password);
              if(res != 201){
                displayDialog(context, "Error", "An unknown error occurred.");
              }
              else{
                onLogInButtonPressed();
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