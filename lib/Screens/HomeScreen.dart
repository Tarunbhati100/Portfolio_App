import 'package:Portfolio/Screens/Authentication/AuthScreen.dart';
import 'package:Portfolio/Screens/EditScreen.dart';
import 'package:Portfolio/Screens/HomeContent.dart';
import 'package:Portfolio/Screens/SearchScreen.dart';
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
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isloading = true;
  final _auth = AuthServices();
  final _database = DatabaseServices();
  User user = User();
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("PORTFOLIO",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.amber[900],
                    ),
                    alignment: Alignment.topRight,
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Column(
                  children: [
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.50 / 2,
                      backgroundColor: Colors.amber,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: user.dpUrl??"",
                          placeholder: (context, url) =>
                              CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: 200,
                          ),
                        ),
                      ),
                    ),
                    Text(isloading?"":user.userName.toUpperCase(),
                        style: TextStyle(fontSize: 30)),
                    Divider(thickness: 1,),
                  ],
                ),
                ListTile(
                  leading: Icon(
                    Icons.edit,
                    color: Colors.amber[900],
                  ),
                  title: Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
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
                              email: user.email,
                              linkedIn: user.linkedIn,
                              mobilenumber: user.mobileNumber,
                            )));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.search_outlined,
                    color: Colors.blue[900],
                  ),
                  title: Text(
                    "Search User",
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SearchScreen()));
                  },
                ),
                ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.red[900],
                    ),
                    title: Text(
                      "Sign Out",
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () {
                      _auth.signOut();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => AuthScreen()));
                    }),
              ],
            ),
          ),
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
      ),
    );
  }
}
