import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/components/authErrorMessage.dart';
import 'dart:convert' show json;
import 'package:mobile_app/config.dart';
import 'package:mobile_app/pages/loginPage.dart';
import 'package:mobile_app/components/Button.dart';
import 'package:mobile_app/components/AlreadyHaveAnAccount.dart';

import 'loginPage.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback onLogInButtonPressed;
  SignUpPage({@required this.onLogInButtonPressed});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  List<Widget> errorMessages = [];

  void addErrorMessage(String text){
    setState(() {
      errorMessages.add(AuthErrorMessage(text: text));
      errorMessages.add(SizedBox(height: 5.0));
    });
  }

  void clearErrorMessages(){
    setState(() {
      errorMessages = [];
    });
  }

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
          Container(
            child: Column(
              children: errorMessages,
            ),
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
              clearErrorMessages();
              if (statusCode == 201) {
                widget.onLogInButtonPressed();
              }
              else if(statusCode>=400) {
                if (email.length == 0 || username.length == 0 || password.length == 0) {
                  addErrorMessage("Please fill in all input fields");
                }
                if (body.containsKey("email")) {
                  String text = body["email"][0];
                  if (text != "This field may not be blank.")
                    addErrorMessage(text);
                }
                if (body.containsKey("username")) {
                  String text = body["username"][0];
                  if (text != "This field may not be blank.")
                    addErrorMessage(text);
                }
                if (body.containsKey("password")) {
                  String text = body["password"][0];
                  if (text != "This field may not be blank.")
                    addErrorMessage(text);
                }
              }
            },
          ),
          SizedBox(height: 5.0),
          AlreadyHaveAnAccount(
            login: false,
            press: () {
              widget.onLogInButtonPressed();
            },
          ),
        ],
      ),
    );
  }
}
