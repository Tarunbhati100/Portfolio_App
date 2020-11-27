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
  Widget build(BuildContext context) {
    return Container(
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
                  placeholder: (context, url) => CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
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
                              fontWeight: FontWeight.bold, fontSize: 20)),
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
            widget.codeforces == null
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
                                  widget.codeforces.handle,
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
                                          widget.codeforces.maxrank,
                                          style: TextStyle(
                                              color:
                                                  widget.codeforces.maxcolor),
                                        ),
                                      ),
                                      Text(
                                        widget.codeforces.maxrating.toString(),
                                        style: TextStyle(
                                            color: widget.codeforces.maxcolor),
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
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue)),
                                      FittedBox(
                                        child: Text(
                                          widget.codeforces.rank,
                                          style: TextStyle(
                                              color:
                                                  widget.codeforces.currcolor),
                                        ),
                                      ),
                                      Text(
                                        widget.codeforces.currrating.toString(),
                                        style: TextStyle(
                                            color: widget.codeforces.currcolor),
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
                              imageUrl: "https:" + widget.codeforces.imgurl,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onLongPress: () =>
                        launch("https://codeforces.com/profile/Tarun_bhati")),
            widget.gitHub == null
                ? SizedBox()
                : Card(
                    child: Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: Column(children: [
                            FittedBox(
                              child: Text(
                                widget.gitHub.handle,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              "Total Repositories : " +
                                  widget.gitHub.totalrepo.toString(),
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "GitHub",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              child: Text(
                                widget.gitHub.gitHubUrl,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                              onLongPress: () async {
                                await launch(widget.gitHub.gitHubUrl);
                              },
                            ),
                          ]),
                        ),
                        Flexible(
                          flex: 1,
                          child: CachedNetworkImage(
                            height: 150,
                            imageUrl: widget.gitHub.imgurl,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ],
                    ),
                  ),
            widget.codechef != null
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
                                    widget.codechef.handle,
                                    style: TextStyle(fontSize: 60),
                                  )),
                                ],
                              ),
                              FittedBox(
                                child: Row(
                                  children: buildStars(widget.codechef.stars,
                                          widget.codechef.color) ??
                                      [],
                                ),
                              ),
                              Text(
                                "Current Rating : " +
                                    widget.codechef.rating.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Max. Rating : " +
                                    widget.codechef.maxrating.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: CachedNetworkImage(
                            height: 150,
                            imageUrl: widget.codechef.imageurl,
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
            widget.hackerrank != null
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
                                    widget.hackerrank.handle,
                                    style: TextStyle(fontSize: 60),
                                  )),
                                ],
                              ),
                              Column(
                                children:
                                    badges(widget.hackerrank.badges) ?? [],
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: CachedNetworkImage(
                            height: 150,
                            imageUrl: widget.hackerrank.imageurl,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ],
                    )),
                    onLongPress: () => launch(
                        "https://www.hackerrank.com/" + widget.user.hackerRank),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
