import 'package:Portfolio/Screens/Authentication/AuthScreen.dart';
import 'package:Portfolio/Screens/EditScreen.dart';
import 'package:Portfolio/Services/auth.dart';
import 'package:Portfolio/Services/codechef.dart';
import 'package:Portfolio/Services/database.dart';
import 'package:Portfolio/Services/github.dart';
import 'package:Portfolio/Services/hackerrank.dart';
import 'package:Portfolio/modals/Badge.dart';
import 'package:Portfolio/modals/Codeforces.dart';
import 'package:Portfolio/modals/GitHub.dart';
import 'package:Portfolio/modals/codechef.dart';
import 'package:Portfolio/modals/hackerrank.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Services/codeforces.dart';
import '../modals/User.dart';

class HomeScreen extends StatefulWidget {
  User user;
  HomeScreen({this.user});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = AuthServices();

  final _database = DatabaseServices();

  Codeforces codeforces;
  GitHub gitHub;
  bool isloading = true;
  Codechef codechef;
  HackerRank hackerrank;
  firebase.User _currUser;
  void initializeUser() async {
    _currUser = _auth.getCurrentUser();
    if (widget.user == null)
      widget.user = await _database.getUser(_currUser.uid);
    if (widget.user.codeforces != null && widget.user.codeforces != "")
      codeforces =
          await CodeforesServices(handle: widget.user.codeforces).getInfo();
    if (widget.user.gitHub != null && widget.user.gitHub != "")
      gitHub = await GitHubServices(handle: widget.user.gitHub).getInfo();
    if (widget.user.codechef != null && widget.user.codechef != "")
      codechef = await CodechefServices(handle: widget.user.codechef).getInfo();
    if (widget.user.hackerRank != null && widget.user.hackerRank != "")
      hackerrank =
          await HackerRankServices(handle: widget.user.hackerRank).getInfo();

    setState(() {
      isloading = false;
    });
  }

  List<Widget> buildStars(int count, Color color) {
    List<Icon> stars = [];
    for (int i = 0; i < count; i++) {
      stars.add(Icon(
        Icons.star_border,
        color: color,
        size: 30,
      ));
    }
    return stars;
  }

  List<Widget> badges(List<Badge> data) {
    List<Widget> badges = [];
    for (var i in data) {
      badges.add(Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
                child: Text(
              "${i.name} : ${i.star}",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            Icon(
              Icons.star,
              color: Colors.amber,
            )
          ],
        ),
      ));
    }
    return badges;
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
        leading: _currUser != null
            ? IconButton(
                iconSize: 50,
                icon: Icon(
                  Icons.edit,
                  color: Colors.yellow,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditScreen(
                            username: widget.user.userName,
                            hackerrank: widget.user.hackerRank,
                            github: widget.user.gitHub,
                            achievements: widget.user.achievements,
                            codeforces: widget.user.codeforces,
                            codechef: widget.user.codechef,
                            aboutMe: widget.user.aboutme,
                            dpurl: widget.user.dpUrl,
                          )));
                },
              )
            : IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        title: Text(
          "PORTFOLIO",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          _currUser != null
              ? IconButton(
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
              : SizedBox()
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
                      radius: 103,
                      backgroundColor: Colors.teal,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          height: 200,
                          width: 200,
                          imageUrl: widget.user.dpUrl,
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
                          child: Text(widget.user.userName.toUpperCase(),
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
                              child: Text(widget.user.aboutme,
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
                              child: Text(widget.user.achievements,
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
                    codechef != null
                        ? InkWell(
                            child: Card(
                                child: Row(
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            "Codechef Handle : ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          FittedBox(
                                              child: Text(
                                            codechef.handle,
                                            style: TextStyle(fontSize: 60),
                                          )),
                                        ],
                                      ),
                                      FittedBox(
                                        child: Row(
                                          children: buildStars(codechef.stars,
                                                  codechef.color) ??
                                              [],
                                        ),
                                      ),
                                      Text(
                                        "Current Rating : " +
                                            codechef.rating.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Max. Rating : " +
                                            codechef.maxrating.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: CachedNetworkImage(
                                    height: 150,
                                    imageUrl: codechef.imageurl,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ],
                            )),
                            onLongPress: () => launch(
                                "https://www.codechef.com/users/" +
                                    widget.user.codechef),
                          )
                        : SizedBox(),
                    hackerrank != null
                        ? InkWell(
                            child: Card(
                                child: Row(
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            "HackerRank Handle : ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          FittedBox(
                                              child: Text(
                                            hackerrank.handle,
                                            style: TextStyle(fontSize: 60),
                                          )),
                                        ],
                                      ),
                                      Column(
                                        children:
                                            badges(hackerrank.badges) ?? [],
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: CachedNetworkImage(
                                    height: 150,
                                    imageUrl: hackerrank.imageurl,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ],
                            )),
                            onLongPress: () => launch(
                                "https://www.hackerrank.com/" +
                                    widget.user.hackerRank),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
    );
  }
}
