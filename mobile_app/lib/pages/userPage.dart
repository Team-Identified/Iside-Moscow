import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mw_insider/components/loadingCircle.dart';
import 'package:mw_insider/pages/loginPage.dart';
import 'package:mw_insider/pages/profilePage.dart';
import 'package:mw_insider/pages/signUpPage.dart';
import 'package:mw_insider/services/authorizationService.dart';


class UserPage extends StatefulWidget {
  final VoidCallback afterLogIn;

  UserPage({@required this.afterLogIn});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Widget currentPage;
  String currentPageName;

  Future<String> setPageName() async {
    if (currentPageName != null){
      return currentPageName;
    }

    bool logged = await isLoggedIn();
    if (logged){
      return "profile";
    }
    else{
      return "login";
    }
  }

  Future<String> setPage() async{
    VoidCallback onSubmit = () {
      setState(() {
        currentPageName = 'profile';
      });
    };
    if (widget.afterLogIn != null){
      onSubmit = () {
        widget.afterLogIn();
      };
    }

    currentPageName = await setPageName();
    if (currentPageName == 'login') {
      currentPage = LoginPage(
        onSignUpButtonPressed: () {
          setState(() {
            currentPageName = 'sign up';
          });
        },
        onSubmitButtonPressed: () {
          onSubmit();
        },
      );
    }
    else if (currentPageName == 'profile'){
      currentPage = ProfilePage(
        onLogOutPressed: () {
          setState(() {
            currentPageName = 'login';
          });
        },
      );
    }
    else if (currentPageName == 'sign up'){
      currentPage = SignUpPage(
          onLogInButtonPressed: () {
            setState(() {
              currentPageName = 'login';
            });
          }
      );
    }
    return "Done";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: setPage(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: currentPage,
            );
          }
          else{
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingCircle(),
                      SizedBox(height: 20.0),
                      Text("Loading", style: TextStyle(fontSize: 20.0),),
                    ]
                  )
                ),
              )
            );
          }
        }
    );
  }
}
