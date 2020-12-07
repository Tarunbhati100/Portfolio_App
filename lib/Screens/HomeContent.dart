import 'package:Portfolio/modals/Badge.dart';
import 'package:Portfolio/modals/Codeforces.dart';
import 'package:Portfolio/modals/GitHub.dart';
import 'package:Portfolio/modals/codechef.dart';
import 'package:Portfolio/modals/hackerrank.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../modals/User.dart';

class HomeContent extends StatefulWidget {
  final User user;
  final Codeforces codeforces;
  final GitHub gitHub;
  final Codechef codechef;
  final HackerRank hackerrank;

  HomeContent(
      {this.user,
      this.hackerrank,
      this.gitHub,
      this.codechef,
      this.codeforces});
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
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
    if (data.length > 0)
      for (var i in data) {
        badges.add(Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FittedBox(
                  child: Text(
                "${i.name} : ${i.star}",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 103,
              backgroundColor: Colors.amber,
              child: ClipOval(
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  height: 200,
                  width: 200,
                  imageUrl: widget.user.dpUrl,
                  placeholder: (context, url) => CircularProgressIndicator(
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
            SizedBox(
              height: 10,
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 50,
                child: FittedBox(
                  child: Text(widget.user.userName.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          decoration: TextDecoration.underline)),
                )),
            Card(
              color: Colors.black,
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
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
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
                          style: TextStyle(fontSize: 15, color: Colors.white))),
                ],
              ),
            ),
            Card(
              color: Colors.black,
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
                              fontSize: 20,
                              color: Colors.white)),
                    ],
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      child: Text(widget.user.achievements,
                          style: TextStyle(fontSize: 15, color: Colors.white))),
                ],
              ),
            ),
            widget.codeforces == null
                ? SizedBox()
                : CodeforcesCard(
                    codeforces: widget.codeforces,
                  ),
            widget.gitHub == null
                ? SizedBox()
                : GitHubCard(gitHub: widget.gitHub),
            widget.codechef == null
                ? SizedBox()
                : CodechefCard(
                    codechef: widget.codechef,
                    starBuilder: buildStars,
                  ),
            widget.hackerrank == null
                ? SizedBox()
                : HackerRankCard(
                    hackerrank: widget.hackerrank,
                    badgeBuilder: badges,
                  ),
            widget.user.gmail == "" ||
                    widget.user.linkedIn == "" ||
                    widget.user.mobileNumber == ""
                ? SizedBox()
                : ContactMeCard(
                    user: widget.user,
                  )
          ],
        ),
      ),
    );
  }
}

class ContactMeCard extends StatelessWidget {
  const ContactMeCard({@required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.account_circle,
                color: Colors.orange,
              ),
              Text("ContactMe",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white)),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: IconButton(
                        icon: Icon(
                          Icons.mail,
                          color: Colors.orange,
                        ),
                        onPressed: () async {
                          if (await canLaunch("mailto:${user.gmail}")) {
                            await launch("mailto:${user.gmail}");
                          } else {
                            print('Could not launch ${user.gmail}');
                          }
                        }),
                  ),
                  Flexible(
                    flex: 1,
                    child: IconButton(
                        icon: Icon(Icons.call, color: Colors.green),
                        onPressed: () async {
                          if (await canLaunch(user.linkedIn)) {
                            await launch("tel:${user.mobileNumber}");
                          } else {
                            print('Could not launch ${user.mobileNumber}');
                          }
                        }),
                  ),
                  Flexible(
                    flex: 1,
                    child: IconButton(
                        icon: Image.asset("./assets/linkedin.png"),
                        onPressed: () async {
                          if (await canLaunch(user.linkedIn)) {
                            await launch(user.linkedIn);
                          } else {
                            print('Could not launch ${user.linkedIn}');
                          }
                        }),
                  ),
                ],
              )
            ],
          ),
          Divider(
            thickness: 2,
          ),
        ],
      ),
    );
  }
}

class HackerRankCard extends StatelessWidget {
  const HackerRankCard({
    @required this.hackerrank,
    @required this.badgeBuilder,
  });

  final HackerRank hackerrank;
  final Function badgeBuilder;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                color: Colors.white),
                          ),
                          FittedBox(
                              child: Text(
                            hackerrank.handle,
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                decoration: TextDecoration.underline),
                          )),
                        ],
                      ),
                      Column(
                        children: badgeBuilder(hackerrank.badges) ?? [],
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: CachedNetworkImage(
                    height: 150,
                    imageUrl: hackerrank.imageurl,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(
                      Icons.account_box,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                ),
              ],
            ),
          )),
      onLongPress: () =>
          launch("https://www.hackerrank.com/" + hackerrank.handle),
    );
  }
}

class CodechefCard extends StatelessWidget {
  const CodechefCard({@required this.codechef, @required this.starBuilder});

  final Codechef codechef;
  final Function starBuilder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Text(
                            "Codechef Handle : ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white),
                          ),
                          FittedBox(
                            child: Text(
                              codechef.handle,
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      FittedBox(
                        child: Row(
                          children:
                              starBuilder(codechef.stars, codechef.color) ?? [],
                        ),
                      ),
                      Text(
                        "Current Rating : " + codechef.rating.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      Text(
                        "Max. Rating : " + codechef.maxrating.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      )
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: CachedNetworkImage(
                    height: 150,
                    imageUrl: codechef.imageurl,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ],
            ),
          )),
      onLongPress: () =>
          launch("https://www.codechef.com/users/" + codechef.handle),
    );
  }
}

class GitHubCard extends StatelessWidget {
  const GitHubCard({
    @required this.gitHub,
  });

  final GitHub gitHub;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              flex: 2,
              child: Column(children: [
                FittedBox(
                  child: Text(
                    gitHub.handle,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Text(
                  "Total Repositories : " + gitHub.totalrepo.toString(),
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
                Text(
                  "GitHub",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                InkWell(
                  child: FittedBox(
                    child: Text(
                      gitHub.gitHubUrl,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                  onLongPress: () async {
                    await launch(gitHub.gitHubUrl);
                  },
                ),
              ]),
            ),
            Flexible(
              flex: 1,
              child: CachedNetworkImage(
                height: 150,
                imageUrl: gitHub.imgurl,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CodeforcesCard extends StatelessWidget {
  const CodeforcesCard({
    @required this.codeforces,
  });

  final Codeforces codeforces;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Card(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Column(children: [
                      FittedBox(
                        child: Text(
                          codeforces.handle,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Column(
                              children: [
                                FittedBox(
                                  child: Text(
                                    'Max. Rank',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ),
                                Text(
                                  codeforces.maxrank,
                                  style: TextStyle(color: codeforces.maxcolor),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  codeforces.maxrating.toString(),
                                  style: TextStyle(color: codeforces.maxcolor),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.black,
                            width: 2,
                            height: 100,
                          ),
                          Flexible(
                            flex: 1,
                            child: Column(
                              children: [
                                FittedBox(
                                  child: Text('Current Rank',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue)),
                                ),
                                Text(
                                  codeforces.rank,
                                  style: TextStyle(color: codeforces.currcolor),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  codeforces.currrating.toString(),
                                  style: TextStyle(color: codeforces.currcolor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      FittedBox(
                        child: Text(
                          "CodeForces",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ]),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: CachedNetworkImage(
                    height: 200,
                    imageUrl: "https:" + codeforces.imgurl,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ],
            ),
          ),
        ),
        onLongPress: () =>
            launch("https://codeforces.com/profile/Tarun_bhati"));
  }
}
