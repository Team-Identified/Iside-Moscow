import 'package:flutter/material.dart';
import 'package:mw_insider/components/Button.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:mw_insider/config.dart';
import 'package:mw_insider/services/backendCommunicationService.dart';
import 'package:mw_insider/services/backgroundService.dart';


class ProfilePage extends StatefulWidget {
  final VoidCallback onLogOutPressed;

  ProfilePage({@required this.onLogOutPressed});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  String name, email, rank, dateJoined, id;
  int points;


  Future<String> getProfile() async {
    if (!mounted) {
      return "WIDGET NOT MOUNTED"; // Just do nothing if the widget is disposed.
    }

    Map resGetUrl = await serverRequest("get", "auth/users/me", null);
    id = resGetUrl["id"].toString();
    Map res = await serverRequest("get", "accounts/profile/" + id, null);
    Map data = res["user"];
    name = data["username"];
    email = data["email"];
    rank = res["rank"];
    points = res["points"];
    dateJoined = DateFormat('EEEE d MMMM H:mm')
        .format(DateTime.parse(data["date_joined"]));
    return "data loaded";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getProfile(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        if (snapshot.hasData){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 85,
                        backgroundImage: NetworkImage(animeGirlsUrl),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Welcome back, $name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )
                      ),
                      Card(
                        color: Colors.white70,
                        margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                        child: ListTile(
                          leading: Icon(
                            Icons.cake,
                            color: Colors.deepPurple[900],
                          ),
                          title: Text(
                            dateJoined,
                            style:
                            TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ),
                      Card(
                        color: Colors.white70,
                        margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
                        child: ListTile(
                          leading: Icon(
                            Icons.email,
                            color: Colors.deepPurple[900],
                          ),
                          title: Text(
                            email,
                            style:
                            TextStyle(
                                fontSize: 17,
                                color: Colors.black
                            ),
                          ),
                        )
                      ),
                      Card(
                        color: Colors.white70,
                        margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
                        child: ListTile(
                          leading: Icon(
                            Icons.star,
                            color: Colors.deepPurple[900],
                          ),
                          title: Text(
                          "Rank: $rank, Points: $points",
                          style:
                          TextStyle(
                              fontSize: 22,
                              color: Colors.black
                          ),
                          ),
                        )
                      ),
                      Button(
                        text: "LOG OUT",
                        press: () async {
                          await storage.delete(key: "access_jwt");
                          await storage.delete(key: "refresh_jwt");
                          widget.onLogOutPressed();
                        },
                      ),
                      Button(
                          text: "Режим прогулки",
                          press: () {switchBackgroundService();},
                      )
                    ],
                  ),
                ),
              ),
            ),
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
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                          ),
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
