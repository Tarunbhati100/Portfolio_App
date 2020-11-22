import 'package:Portfolio/Screens/Authentication/SignUp.dart';
import 'package:Portfolio/Screens/Authentication/signIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

bool isNew;

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  void toggleScreen() {
    setState(() {
      isNew = isNew == false ? true : false;
    });
  }

  void back() {
    setState(() {
      isNew = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isNew == null) {
      return Scaffold(
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
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
                  setState(() {
                    isNew = false;
                  });
                },
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 50),
                ),
              ),
              RaisedButton(
                color: Colors.yellow,
                onPressed: () {
                  setState(() {
                    isNew = true;
                  });
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
    } else {
      return isNew
          ? SignUp(
              toggleCallback: toggleScreen,
              backCallback: back,
            )
          : SignIn(
              toggleCallback: toggleScreen,
              backCallback: back,
            );
    }
  }
}
