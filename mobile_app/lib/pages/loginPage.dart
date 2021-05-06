import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:mw_insider/config.dart';
import 'package:mw_insider/components/middleButton.dart';
import 'package:mw_insider/components/alreadyHaveAnAccount.dart';
import 'package:mw_insider/components/authErrorMessage.dart';

void displayDialog(context, title, text) => showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(title: Text(title), content: Text(text)),
    );

class LoginPage extends StatefulWidget {
  final VoidCallback onSignUpButtonPressed;
  final VoidCallback onSubmitButtonPressed;


  LoginPage(
      {@required this.onSignUpButtonPressed,
      @required this.onSubmitButtonPressed});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          SizedBox(height: 5.0),
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20.0),
                border: InputBorder.none,
                hintText: 'Username'),
          ),
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
          MiddleButton(
            text: "LOGIN",
            press: () async {
              String username = _usernameController.text;
              String password = _passwordController.text;
              Map res = await attemptLogIn(username, password);
              Map body = res["body"];
              int statusCode = res["statuscode"];
              clearErrorMessages();
              if (statusCode >= 400) {
                bool errorRaised = false;
                if (body.containsKey("username")) {
                  errorRaised = true;
                  addErrorMessage("Username field may not be blank");
                }
                if (body.containsKey("password")) {
                  errorRaised = true;
                  addErrorMessage("Password field may not be blank");
                }
                if (body.containsKey("detail")) {
                  errorRaised = true;
                  addErrorMessage(body["detail"]);
                }
                if (!errorRaised) {
                  addErrorMessage("Unknown error happened");
                }
              }
              if (statusCode == 200) {
                storage.write(key: "access_jwt", value: body["access"]);
                storage.write(key: "refresh_jwt", value: body["refresh"]);
                widget.onSubmitButtonPressed();
              }
            },
          ),
          SizedBox(height: 5.0),
          AlreadyHaveAnAccount(
            press: () {
              widget.onSignUpButtonPressed();
            },
          ),
        ],
      ),
    );
  }
}
