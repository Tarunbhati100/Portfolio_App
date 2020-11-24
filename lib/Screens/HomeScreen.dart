import 'package:Portfolio/Screens/Authentication/AuthScreen.dart';
import 'package:Portfolio/Screens/Authentication/EditScreen.dart';
import 'package:Portfolio/Services/auth.dart';
import 'package:Portfolio/Services/database.dart';
import 'package:Portfolio/Services/github.dart';
import 'package:Portfolio/modals/Codeforces.dart';
import 'package:Portfolio/modals/GitHub.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Services/codeforces.dart';
import '../modals/User.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = AuthServices();

  final _database = DatabaseServices();

  Codeforces codeforces;
  User user;
  GitHub gitHub;
  bool isloading = true;

  Response codechefresponse;
  Response hackerrankresponse;
  void initializeUser() async {
    user = await _database.getUser(_auth.getCurrentUser().uid);
    if (user.codeforces != null && user.codeforces != "")
      codeforces = await CodeforesServices(handle: user.codeforces).getInfo();
    if (user.gitHub != null && user.gitHub != "")
      gitHub = await GitHubServices(handle: user.gitHub).getInfo();
    if (user.codechef != null && user.codechef != "")
      codechefresponse =
          await get("https://www.codechef.com/users/" + user.codechef);
    if (user.hackerRank != null && user.hackerRank != "")
      hackerrankresponse =
          await get("https://www.hackerrank.com/" + user.hackerRank);

    setState(() {
      isloading = false;
    });
  }

  bool check(Response data) {
    if (data != null) {
      if (data.statusCode == 200) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    initializeUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        brightness: Brightness.light,
        leading: IconButton(
          iconSize: 50,
          icon: Icon(
            Icons.edit,
            color: Colors.yellow,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => EditScreen()));
          },
        ),
        title: Text(
          "PORTFOLIO",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
          ),
        ],
      ),
      body: isloading
          ? LinearProgressIndicator(
              backgroundColor: Colors.yellow,
            )
          : Container(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 105,
                      backgroundColor: Colors.blueGrey,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          height: 200,
                          width: 200,
                          imageUrl: user.dpUrl,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: FittedBox(
                          child: Text(user.userName.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline)),
                        )),
                    Card(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.notes,
                                color: Colors.orange,
                              ),
                              Text(
                                "AboutMe",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 2,
                          ),
                          Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              child: Text(user.aboutme,
                                  style: TextStyle(fontSize: 15))),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.leaderboard,
                                color: Colors.orange,
                              ),
                              Text("Achievements",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ],
                          ),
                          Divider(
                            thickness: 2,
                          ),
                          Container(
                              padding: EdgeInsets.all(10),
                              width: double.infinity,
                              child: Text(user.achievements,
                                  style: TextStyle(fontSize: 15))),
                        ],
                      ),
                    ),
                    codeforces == null
                        ? SizedBox()
                        : InkWell(
                            child: Card(
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Column(children: [
                                      FittedBox(
                                        child: Text(
                                          codeforces.handle,
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                'Max. Rank',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red),
                                              ),
                                              FittedBox(
                                                child: Text(
                                                  codeforces.maxrank,
                                                  style: TextStyle(
                                                      color:
                                                          codeforces.maxcolor),
                                                ),
                                              ),
                                              Text(
                                                codeforces.maxrating.toString(),
                                                style: TextStyle(
                                                    color: codeforces.maxcolor),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            color: Colors.black,
                                            width: 2,
                                            height: 100,
                                          ),
                                          Column(
                                            children: [
                                              Text('Current Rank',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue)),
                                              FittedBox(
                                                child: Text(
                                                  codeforces.rank,
                                                  style: TextStyle(
                                                      color:
                                                          codeforces.currcolor),
                                                ),
                                              ),
                                              Text(
                                                codeforces.currrating
                                                    .toString(),
                                                style: TextStyle(
                                                    color:
                                                        codeforces.currcolor),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      FittedBox(
                                        child: Text(
                                          "CodeForces",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ]),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: CachedNetworkImage(
                                      height: 200,
                                      imageUrl: "https:" + codeforces.imgurl,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onLongPress: () => launch(
                                "https://codeforces.com/profile/Tarun_bhati")),
                    gitHub == null
                        ? SizedBox()
                        : Card(
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Column(children: [
                                    FittedBox(
                                      child: Text(
                                        gitHub.handle,
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      "Total Repositories : " +
                                          gitHub.totalrepo.toString(),
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "GitHub",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    InkWell(
                                      child: Text(
                                        gitHub.gitHubUrl,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                      ),
                                      onLongPress: () async {
                                        if (await canLaunch(gitHub.gitHubUrl)) {
                                          await launch(gitHub.gitHubUrl);
                                        } else {
                                          throw 'Could not launch $gitHub.gitHubUrl';
                                        }
                                      },
                                    ),
                                  ]),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: CachedNetworkImage(
                                    height: 150,
                                    imageUrl: gitHub.imgurl,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    check(codechefresponse)
                        ? InkWell(
                            child: Card(
                                child: Column(
                              children: [
                                Image.asset("./assets/codechef.png"),
                                Text(
                                  "CodeChef Link : https://www.codechef.com/users/" +
                                      user.codechef,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )),
                            onLongPress: () => launch(
                                "https://www.codechef.com/users/" +
                                    user.codechef),
                          )
                        : SizedBox(),
                    check(hackerrankresponse)
                        ? InkWell(
                            child: Card(
                              child: Column(
                                children: [
                                  Image.asset("./assets/hackerrank.png"),
                                  Text(
                                    "HackerRank Link : https://www.hackerrank.com/" +
                                        user.hackerRank,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onLongPress: () => launch(
                                "https://www.hackerrank.com/" +
                                    user.hackerRank),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
    );
  }
}
