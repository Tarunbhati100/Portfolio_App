import 'package:Portfolio/Screens/HomeContent.dart';
import 'package:Portfolio/Screens/SearchScreen.dart';
import 'package:Portfolio/Services/codechef.dart';
import 'package:Portfolio/Services/codeforces.dart';
import 'package:Portfolio/Services/github.dart';
import 'package:Portfolio/Services/hackerrank.dart';
import 'package:Portfolio/modals/Codeforces.dart';
import 'package:Portfolio/modals/GitHub.dart';
import 'package:Portfolio/modals/User.dart';
import 'package:Portfolio/modals/codechef.dart';
import 'package:Portfolio/modals/hackerrank.dart';
import 'package:flutter/material.dart';

class SearchedDataScreen extends StatefulWidget {
  final User user;
  SearchedDataScreen({this.user});
  @override
  _SearchedDataScreenState createState() => _SearchedDataScreenState();
}

class _SearchedDataScreenState extends State<SearchedDataScreen> {
  bool isloading = true;
  Codeforces codeforces;
  GitHub gitHub;
  Codechef codechef;
  HackerRank hackerrank;
  void initializeUser() async {
    if (widget.user.codeforces != null && widget.user.codeforces != "")
      codeforces =
          await CodeforesServices(handle: widget.user.codeforces).getInfo();
    if (widget.user.gitHub != null || widget.user.gitHub != "")
      gitHub = await GitHubServices(handle: widget.user.gitHub).getInfo();
    if (widget.user.codechef != null || widget.user.codechef != "")
      codechef = await CodechefServices(handle: widget.user.codechef).getInfo();
    if (widget.user.hackerRank != null || widget.user.hackerRank != "")
      hackerrank =
          await HackerRankServices(handle: widget.user.hackerRank).getInfo();
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return SearchScreen();
            }));
          },
        ),
        title: Text(
          "PORTFOLIO",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: isloading
          ? LinearProgressIndicator(
              backgroundColor: Colors.yellow,
            )
          : HomeContent(
              user: widget.user,
              codechef: codechef,
              codeforces: codeforces,
              gitHub: gitHub,
              hackerrank: hackerrank,
            ),
    );
  }
}
