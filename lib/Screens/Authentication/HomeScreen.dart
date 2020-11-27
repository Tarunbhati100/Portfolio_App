import 'package:Portfolio/Screens/Authentication/AuthScreen.dart';
import 'package:Portfolio/Screens/EditScreen.dart';
import 'package:Portfolio/Screens/HomeContent.dart';
import 'package:Portfolio/Services/auth.dart';
import 'package:Portfolio/Services/codechef.dart';
import 'package:Portfolio/Services/codeforces.dart';
import 'package:Portfolio/Services/database.dart';
import 'package:Portfolio/Services/github.dart';
import 'package:Portfolio/Services/hackerrank.dart';
import 'package:Portfolio/modals/Codeforces.dart';
import 'package:Portfolio/modals/GitHub.dart';
import 'package:Portfolio/modals/User.dart';
import 'package:Portfolio/modals/codechef.dart';
import 'package:Portfolio/modals/hackerrank.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isloading = true;
  final _auth = AuthServices();
  final _database = DatabaseServices();
  User user;
  Codeforces codeforces;
  GitHub gitHub;
  Codechef codechef;
  HackerRank hackerrank;
  void initializeUser() async {
    user = await _database.getUser(_auth.getCurrentUser().uid);
    if (user.codeforces != null && user.codeforces != "")
      codeforces = await CodeforesServices(handle: user.codeforces).getInfo();
    if (user.gitHub != null || user.gitHub != "")
      gitHub = await GitHubServices(handle: user.gitHub).getInfo();
    if (user.codechef != null || user.codechef != "")
      codechef = await CodechefServices(handle: user.codechef).getInfo();
    if (user.hackerRank != null || user.hackerRank != "")
      hackerrank = await HackerRankServices(handle: user.hackerRank).getInfo();
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    initializeUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        leading: IconButton(
          iconSize: 50,
          icon: Icon(
            Icons.edit,
            color: Colors.amber[800],
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditScreen(
                      username: user.userName,
                      hackerrank: user.hackerRank,
                      github: user.gitHub,
                      achievements: user.achievements,
                      codeforces: user.codeforces,
                      codechef: user.codechef,
                      aboutMe: user.aboutme,
                      dpurl: user.dpUrl,
                    )));
          },
        ),
        title: Text("PORTFOLIO",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
            iconSize: 50,
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            onPressed: () {
              _auth.signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AuthScreen()));
            },
          )
        ],
      ),
      body: isloading
          ? LinearProgressIndicator(
              backgroundColor: Colors.yellow,
            )
          : HomeContent(
              user: user,
              codechef: codechef,
              codeforces: codeforces,
              gitHub: gitHub,
              hackerrank: hackerrank,
            ),
    );
  }
}
