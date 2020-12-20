import 'package:Portfolio/modals/Badge.dart';
import 'package:Portfolio/modals/Codeforces.dart';
import 'package:Portfolio/modals/GitHub.dart';
import 'package:Portfolio/modals/codechef.dart';
import 'package:Portfolio/modals/hackerrank.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../modals/User.dart';

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
  bool isAboutMeCardopen = true;
  bool isAchiementCardopen = true;
  bool iscontactMeCardopen = true;
  bool isCodeforcesCardopen = true;
  bool isCodechefCardopen = true;
  bool isGitHubCardopen = true;
  bool isHackerRankCardopen = true;

  _toggleContact() {
    setState(() {
      iscontactMeCardopen = !iscontactMeCardopen;
    });
  }

  _toggleAboutMe() {
    setState(() {
      isAboutMeCardopen = !isAboutMeCardopen;
    });
  }

  _toggleAchievment() {
    setState(() {
      isAchiementCardopen = !isAchiementCardopen;
    });
  }

  _toggleCodeforces() {
    setState(() {
      isCodeforcesCardopen = !isCodeforcesCardopen;
    });
  }

  _toggleCodechef() {
    setState(() {
      isCodechefCardopen = !isCodechefCardopen;
    });
  }

  _toggleGitHub() {
    setState(() {
      isGitHubCardopen = !isGitHubCardopen;
    });
  }

  _toggleHackerRank() {
    setState(() {
      isHackerRankCardopen = !isHackerRankCardopen;
    });
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
              radius: MediaQuery.of(context).size.width * 0.65 / 2,
              backgroundColor: Colors.amber,
              child: ClipOval(
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  height: MediaQuery.of(context).size.width * 0.6,
                  width: MediaQuery.of(context).size.width * 0.6,
                  imageUrl: widget.user.dpUrl??"",
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
            Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 70,
                child: FittedBox(
                  child: Text(widget.user.userName.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline)),
                )),
            AboutMeCard(
              user: widget.user,
              isopen: isAboutMeCardopen,
              toggleCallback: _toggleAboutMe,
            ),
            AchievementCard(
              user: widget.user,
              isopen: isAchiementCardopen,
              toggleCallback: _toggleAchievment,
            ),
            widget.codeforces == null
                ? SizedBox()
                : CodeforcesCard(
                    codeforces: widget.codeforces,
                    isopen: isCodeforcesCardopen,
                    toggleCallback: _toggleCodeforces,
                  ),
            widget.gitHub == null
                ? SizedBox()
                : GitHubCard(
                    gitHub: widget.gitHub,
                    isopen: isGitHubCardopen,
                    toggleCallback: _toggleGitHub,
                  ),
            widget.codechef == null
                ? SizedBox()
                : CodechefCard(
                    codechef: widget.codechef,
                    starBuilder: buildStars,
                    isopen: isCodechefCardopen,
                    toggleCallback: _toggleCodechef,
                  ),
            widget.hackerrank == null
                ? SizedBox()
                : HackerRankCard(
                    hackerrank: widget.hackerrank,
                    badgeBuilder: badges,
                    isopen: isHackerRankCardopen,
                    toggleCallback: _toggleHackerRank,
                  ),
            widget.user.email == "" &&
                    widget.user.linkedIn == "" &&
                    widget.user.mobileNumber == ""
                ? SizedBox()
                : ContactMeCard(
                    user: widget.user,
                    isopen: iscontactMeCardopen,
                    toggleCallback: _toggleContact,
                  )
          ],
        ),
      ),
    );
  }
}

class AchievementCard extends StatelessWidget {
  const AchievementCard(
      {@required this.user,
      @required this.isopen,
      @required this.toggleCallback});
  final User user;
  final bool isopen;
  final Function toggleCallback;
  @override
  Widget build(BuildContext context) {
    return isopen
        ? ToggleCard(
            isopen: isopen,
            toggleCallback: toggleCallback,
            title: "Achievements",
            leadingicon: Icon(
              Icons.leaderboard,
              color: Colors.orange,
            ),
          )
        : Card(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ToggleCard(
                    isopen: isopen,
                    toggleCallback: toggleCallback,
                    title: "Achievements",
                    leadingicon: Icon(
                      Icons.leaderboard,
                      color: Colors.orange,
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  isopen
                      ? Container(
                          padding: EdgeInsets.all(10),
                          width: double.infinity,
                          child: Text(user.achievements,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)))
                      : SizedBox(),
                ],
              ),
            ),
          );
  }
}

class AboutMeCard extends StatelessWidget {
  const AboutMeCard(
      {@required this.user,
      @required this.isopen,
      @required this.toggleCallback});
  final User user;
  final bool isopen;
  final Function toggleCallback;

  @override
  Widget build(BuildContext context) {
    return isopen
        ? ToggleCard(
            isopen: isopen,
            toggleCallback: toggleCallback,
            title: "About Me",
            leadingicon: Icon(
              Icons.notes,
              color: Colors.orange,
            ),
          )
        : Card(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ToggleCard(
                    isopen: isopen,
                    toggleCallback: toggleCallback,
                    title: "About Me",
                    leadingicon: Icon(
                      Icons.notes,
                      color: Colors.orange,
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  isopen
                      ? Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          child: Text(user.aboutme,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)))
                      : SizedBox(),
                ],
              ),
            ),
          );
  }
}

class ContactMeCard extends StatelessWidget {
  ContactMeCard(
      {@required this.user,
      @required this.isopen,
      @required this.toggleCallback});
  final User user;
  bool isopen;
  Function toggleCallback;

  @override
  Widget build(BuildContext context) {
    return isopen
        ? ToggleCard(
            isopen: isopen,
            toggleCallback: toggleCallback,
            title: "Contact Me",
            leadingicon: Icon(
              Icons.call,
              color: Colors.orange,
            ),
          )
        : Card(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.call,
                              color: Colors.orange,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Contact Me",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white)),
                          ],
                        ),
                        Icon(
                          isopen ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    onTap: toggleCallback,
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      user.mobileNumber == ""
                          ? SizedBox()
                          : Column(
                              children: [
                                IconButton(
                                    iconSize:
                                        MediaQuery.of(context).size.width *
                                            0.15,
                                    icon: Icon(
                                      Icons.call_outlined,
                                      color: Colors.green,
                                    ),
                                    onPressed: () async {
                                      if (await canLaunch(
                                          "tel:user.mobileNumber")) {
                                        await launch(
                                            "tel:${user.mobileNumber}");
                                      } else {
                                        print(
                                            'Could not launch ${user.mobileNumber}');
                                      }
                                    }),
                                Text(
                                  "Call",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                      user.email == ""
                          ? SizedBox()
                          : Column(
                              children: [
                                IconButton(
                                    iconSize:
                                        MediaQuery.of(context).size.width *
                                            0.15,
                                    icon: Icon(
                                      Icons.mail_outline,
                                      color: Colors.deepOrange[900],
                                    ),
                                    onPressed: () async {
                                      if (await canLaunch(
                                          "mailto:${user.email}")) {
                                        await launch("mailto:${user.email}");
                                      } else {
                                        print('Could not launch ${user.email}');
                                      }
                                    }),
                                Text(
                                  "Mail",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                      user.linkedIn == ""
                          ? SizedBox()
                          : Column(
                              children: [
                                IconButton(
                                    iconSize:
                                        MediaQuery.of(context).size.width * 0.2,
                                    icon: Image.asset(
                                        "./assets/images/linkedin.png"),
                                    onPressed: () async {
                                      if (await canLaunch(user.linkedIn)) {
                                        await launch(user.linkedIn);
                                      } else {
                                        print(
                                            'Could not launch ${user.linkedIn}');
                                      }
                                    }),
                                Text(
                                  "LinkedIn",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                    ],
                  ),
                  Divider(
                    thickness: 2,
                  ),
                ],
              ),
            ),
          );
  }
}

class HackerRankCard extends StatelessWidget {
  const HackerRankCard(
      {@required this.hackerrank,
      @required this.badgeBuilder,
      @required this.isopen,
      @required this.toggleCallback});

  final bool isopen;
  final Function toggleCallback;

  final HackerRank hackerrank;
  final Function badgeBuilder;
  @override
  Widget build(BuildContext context) {
    return isopen
        ? ToggleCard(
            isopen: isopen,
            toggleCallback: toggleCallback,
            title: "HackerRank",
            leadingicon: Icon(
              Icons.account_circle,
              color: Colors.orange,
            ),
          )
        : InkWell(
            child: Card(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ToggleCard(
                        isopen: isopen,
                        toggleCallback: toggleCallback,
                        title: "HackerRank",
                        leadingicon: Icon(
                          Icons.account_circle,
                          color: Colors.orange,
                        ),
                      ),
                      Divider(color: Colors.white),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                Column(
                                  children:
                                      badgeBuilder(hackerrank.badges) ?? [],
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: CachedNetworkImage(
                              height: 150,
                              imageUrl: hackerrank.imageurl,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.amber,
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.account_box,
                                color: Colors.white,
                                size: 100,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            onLongPress: () =>
                launch("https://www.hackerrank.com/" + hackerrank.handle),
          );
  }
}

class ToggleCard extends StatelessWidget {
  const ToggleCard({
    @required this.isopen,
    @required this.toggleCallback,
    @required this.leadingicon,
    @required this.title,
  });

  final bool isopen;
  final Function toggleCallback;
  final Icon leadingicon;
  final String title;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        color: Colors.black,
        child: Padding(
          padding: EdgeInsets.all(isopen ? 8.0 : 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  leadingicon,
                  SizedBox(
                    width: 5,
                  ),
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white)),
                ],
              ),
              Icon(
                isopen ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      onTap: toggleCallback,
    );
  }
}

class CodechefCard extends StatelessWidget {
  const CodechefCard(
      {@required this.codechef,
      @required this.starBuilder,
      @required this.isopen,
      @required this.toggleCallback});

  final bool isopen;
  final Function toggleCallback;

  final Codechef codechef;
  final Function starBuilder;

  @override
  Widget build(BuildContext context) {
    return isopen
        ? ToggleCard(
            isopen: isopen,
            toggleCallback: toggleCallback,
            title: "CodeChef",
            leadingicon: Icon(
              Icons.account_circle,
              color: Colors.orange,
            ),
          )
        : InkWell(
            child: Card(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ToggleCard(
                        isopen: isopen,
                        toggleCallback: toggleCallback,
                        title: "CodeChef",
                        leadingicon: Icon(
                          Icons.account_circle,
                          color: Colors.orange,
                        ),
                      ),
                      Divider(color: Colors.white),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ),
                                  ],
                                ),
                                FittedBox(
                                  child: Row(
                                    children: starBuilder(
                                            codechef.stars, codechef.color) ??
                                        [],
                                  ),
                                ),
                                Text(
                                  "Current Rating : " +
                                      codechef.rating.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                                Text(
                                  "Max. Rating : " +
                                      codechef.maxrating.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                )
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: CachedNetworkImage(
                              height: 150,
                              imageUrl: codechef.imageurl,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.amber,
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.account_box,
                                color: Colors.white,
                                size: 100,
                              ),
                            ),
                          ),
                        ],
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
  const GitHubCard(
      {@required this.gitHub,
      @required this.isopen,
      @required this.toggleCallback});

  final bool isopen;
  final Function toggleCallback;
  final GitHub gitHub;

  @override
  Widget build(BuildContext context) {
    return isopen
        ? ToggleCard(
            isopen: isopen,
            toggleCallback: toggleCallback,
            title: "GitHub",
            leadingicon: Icon(
              Icons.account_circle,
              color: Colors.orange,
            ),
          )
        : Card(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ToggleCard(
                    isopen: isopen,
                    toggleCallback: toggleCallback,
                    title: "GitHub",
                    leadingicon: Icon(
                      Icons.account_circle,
                      color: Colors.orange,
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
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
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              InkWell(
                                child: FittedBox(
                                  child: Text(
                                    gitHub.gitHubUrl,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
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
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.amber,
                            ),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.account_box,
                            color: Colors.white,
                            size: 100,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}

class CodeforcesCard extends StatelessWidget {
  const CodeforcesCard(
      {@required this.codeforces,
      @required this.isopen,
      @required this.toggleCallback});

  final Codeforces codeforces;
  final bool isopen;
  final Function toggleCallback;
  @override
  Widget build(BuildContext context) {
    return isopen
        ? ToggleCard(
            isopen: isopen,
            toggleCallback: toggleCallback,
            title: "CodeForces",
            leadingicon: Icon(
              Icons.account_circle,
              color: Colors.orange,
            ),
          )
        : InkWell(
            child: Card(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  children: [
                    ToggleCard(
                      isopen: isopen,
                      toggleCallback: toggleCallback,
                      title: "CodeForces",
                      leadingicon: Icon(
                        Icons.account_circle,
                        color: Colors.orange,
                      ),
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FittedBox(
                                    child: Text(
                                      codeforces.handle,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              FittedBox(
                                                child: Text(
                                                  'Max. Rank',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red),
                                                ),
                                              ),
                                              Text(
                                                codeforces.maxrank,
                                                style: TextStyle(
                                                    color: codeforces.maxcolor),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                codeforces.maxrating.toString(),
                                                style: TextStyle(
                                                    color: codeforces.maxcolor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        VerticalDivider(
                                          color: Colors.white,
                                          thickness: 2,
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              FittedBox(
                                                child: Text('Current Rank',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue)),
                                              ),
                                              Text(
                                                codeforces.rank,
                                                style: TextStyle(
                                                    color:
                                                        codeforces.currcolor),
                                                textAlign: TextAlign.center,
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
                                        ),
                                      ],
                                    ),
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
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.amber,
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.account_box,
                              color: Colors.white,
                              size: 100,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            onLongPress: () =>
                launch("https://codeforces.com/profile/Tarun_bhati"));
  }
}
