import 'package:Portfolio/Screens/SearchedDataScreen.dart';
import 'package:Portfolio/Services/database.dart';
import 'package:Portfolio/Services/adManager.dart';
import 'package:Portfolio/modals/User.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String username = "";
  List<Map<String, dynamic>> data = [];
  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady;

  void _loadInterstitialAd() {
    _interstitialAd.load();
  }

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

  void _onInterstitialAdEvent(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        _isInterstitialAdReady = true;
        break;
      case MobileAdEvent.failedToLoad:
        _isInterstitialAdReady = false;
        print('Failed to load an interstitial ad');
        break;
      case MobileAdEvent.closed:
        _loadInterstitialAd();
        break;
      default:
      // do nothing
    }
  }

  @override
  void initState() {
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.banner,
    );
    _loadBannerAd();
    _isInterstitialAdReady = false;
    _interstitialAd = InterstitialAd(
      adUnitId: AdManager.interstitialAdUnitId,
      listener: _onInterstitialAdEvent,
    );
    _loadInterstitialAd();

    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
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
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Search User",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Enter Username",
                        labelText: "Enter Username",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                              color: Colors.teal,
                              style: BorderStyle.solid,
                              width: 2),
                        ),
                      ),
                      onChanged: (text) async {
                        username = text.toLowerCase();
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.blue,
                    ),
                    onPressed: () async {
                      final alldata = await DatabaseServices().getdata;
                      if (username.isNotEmpty)
                        setState(() {
                          data = alldata.where((element) {
                            return element['Username']
                                .toString()
                                .contains(username);
                          }).toList();
                        });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                  children: List.generate(data.length, (index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                          leading: data[index]['dpurl'] != ""
                              ? ClipOval(
                                  child: Image.network(
                                    data[index]['dpurl'],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : Icon(
                                  Icons.account_circle,
                                  color: Colors.blueGrey,
                                  size: 50,
                                ),
                          title:
                              Text(data[index]['Username'], style: TextStyle()),
                          onTap: () {
                            if (_isInterstitialAdReady) {
                              _interstitialAd.show();
                            }
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                              return SearchedDataScreen(
                                user: User(
                                  codeforces: data[index]['Codeforces Handle'],
                                  gitHub: data[index]['GitHub Handle'],
                                  userName: data[index]['Username'],
                                  codechef: data[index]['Codechef Handle'],
                                  hackerRank: data[index]['HackerRank Handle'],
                                  dpUrl: data[index]['dpurl'],
                                  aboutme: data[index]['About Me'],
                                  achievements: data[index]['Achievements'],
                                ),
                              );
                            }));
                          }),
                      Divider(
                        thickness: 2,
                      ),
                    ],
                  ),
                );
              })),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ));
  }
}
