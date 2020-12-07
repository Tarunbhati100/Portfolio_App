import 'package:Portfolio/Screens/Authentication/SignUp.dart';
import 'package:Portfolio/Screens/Authentication/signIn.dart';
import 'package:Portfolio/Screens/SearchScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        actions: [
          Center(
              child: FlatButton(
                  child: Text(
                    "Search User",
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SearchScreen()));
                  }))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Portfolio",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 80,
              ),
            ),
            Text(
              "An app where you can keep all your acheivements together",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: SvgPicture.asset("./assets/profile.svg"),
            ),
            RaisedButton(
              color: Colors.white,
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => SignIn()));
              },
              child: Text(
                "Login",
                style: TextStyle(fontSize: 50),
              ),
            ),
            RaisedButton(
              color: Colors.yellow,
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => SignUp()));
              },
              child: Text(
                "Sign Up",
                style: TextStyle(fontSize: 50),
              ),
            )
          ],
        ),
      ),
    );
  }
}
