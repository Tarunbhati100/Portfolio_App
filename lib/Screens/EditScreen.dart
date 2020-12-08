import 'dart:io';
import 'package:Portfolio/Screens/Authentication/AuthScreen.dart';
import 'package:Portfolio/Screens/Authentication/HomeScreen.dart';
import 'package:Portfolio/Services/database.dart';
import 'package:Portfolio/Services/adManager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../Services/auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EditScreen extends StatefulWidget {
  String dpurl;
  String currusername;
  String username;
  String codechef;
  String codeforces;
  String hackerrank;
  String github;
  String aboutMe;
  String achievements;
  File image;
  String email;
  String mobilenumber;
  String linkedIn;
  EditScreen({
    this.dpurl,
    this.github,
    this.hackerrank,
    this.codeforces,
    this.codechef,
    this.username,
    this.achievements,
    this.aboutMe,
    this.email,
    this.mobilenumber,
    this.linkedIn,
  }) {
    currusername = username;
  }
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _auth = AuthServices();
  final _database = DatabaseServices();

  final _formkey = GlobalKey<FormState>();
  bool isloading = false;
  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady;
  bool _usernameavailable = true;

  void _loadInterstitialAd() {
    _interstitialAd.load();
  }

  bool _checkUser(List<Map<String, dynamic>> data, String username) {
    for (var element in data) {
      if (element['Username'].toString() == username) {
        return false;
      }
    }
    return true;
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
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text("PORTFOLIO",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirm Deletion'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(
                                'Are you sure you want to delete your account?'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Yes'),
                          onPressed: () {
                            if (_isInterstitialAdReady) {
                              _interstitialAd.show();
                            }
                            _auth.deleteUser();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => AuthScreen()));
                          },
                        ),
                        TextButton(
                          child: Text('No'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            )
          ]),
      body: ModalProgressHUD(
        inAsyncCall: isloading,
        child: Container(
          padding: EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        "Edit Data",
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Edit Your Profile",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    final selectedImg = await ImagePicker().getImage(
                        source: ImageSource.gallery, imageQuality: 50);
                    widget.image = await ImageCropper.cropImage(
                        sourcePath: selectedImg.path,
                        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
                        androidUiSettings: AndroidUiSettings(
                            toolbarTitle: 'Cropper',
                            toolbarColor: Colors.deepOrange,
                            toolbarWidgetColor: Colors.white,
                            initAspectRatio: CropAspectRatioPreset.original,
                            lockAspectRatio: true),
                        iosUiSettings: IOSUiSettings(
                          minimumAspectRatio: 1.0,
                        ));
                    setState(() {});
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.amber,
                        child: widget.image == null
                            ? ClipOval(
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  height: 200,
                                  width: 200,
                                  imageUrl: widget.dpurl,
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
                              )
                            : ClipOval(
                                child: Image.file(
                                  File(widget.image.path),
                                  fit: BoxFit.fill,
                                  width: 200,
                                  height: 200,
                                ),
                              ),
                      ),
                      Positioned(
                        child: Icon(
                          Icons.edit,
                          size: 40,
                        ),
                        left: 160,
                        top: 160,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextFormField(
                        initialValue: widget.aboutMe,
                        maxLines: 8,
                        maxLength: 1000,
                        decoration: InputDecoration(
                          hintText: "About Yourself.",
                          labelText: "About Yourself",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(
                                color: Colors.teal,
                                style: BorderStyle.solid,
                                width: 2),
                          ),
                        ),
                        onChanged: (text) {
                          widget.aboutMe = text;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: widget.achievements,
                        maxLines: 8,
                        maxLength: 1000,
                        decoration: InputDecoration(
                          hintText:
                              "Your Acheivements. Please provide in points to make it look good",
                          labelText: "Your Achievements",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(
                                color: Colors.teal,
                                style: BorderStyle.solid,
                                width: 2),
                          ),
                        ),
                        onChanged: (text) {
                          widget.achievements = text;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: widget.username,
                        decoration: InputDecoration(
                          hintText: "UserName",
                          labelText: "UserName",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Please provide a valid Username.";
                          } else if (val.contains(" ")) {
                            return "Username should not contain spaces. ";
                          } else if (_usernameavailable == false &&
                              widget.currusername != val) {
                            return "Username Already Exist. Please Try another one.";
                          }
                          return null;
                        },
                        onChanged: (val) async {
                          final alldata = await DatabaseServices().getdata;
                          _usernameavailable = _checkUser(alldata, val);
                          widget.username = val.toLowerCase();
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: widget.codechef,
                        decoration: InputDecoration(
                          hintText: "Codechef Handle",
                          labelText: "Codechef Handle",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        validator: (val) {
                          if (val.contains(" ")) {
                            return "Please provide a valid Username.";
                          }
                          return null;
                        },
                        onChanged: (val) {
                          widget.codechef = val;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: widget.codeforces,
                        decoration: InputDecoration(
                          hintText: "Codeforces Handle",
                          labelText: "Codeforces Handle",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        validator: (val) {
                          if (val.contains(" ")) {
                            return "Please provide a valid Username.";
                          }
                          return null;
                        },
                        onChanged: (val) {
                          widget.codeforces = val;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: widget.hackerrank,
                        decoration: InputDecoration(
                          hintText: "HakerRank Handle",
                          labelText: "HackerRank Handle",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        validator: (val) {
                          if (val.contains(" ")) {
                            return "Please provide a valid Username.";
                          }
                          return null;
                        },
                        onChanged: (val) {
                          widget.hackerrank = val;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: widget.github,
                        decoration: InputDecoration(
                          hintText: "GitHub Handle",
                          labelText: "GitHub Handle",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        validator: (val) {
                          if (val.contains(" ")) {
                            return "Please provide a valid Username.";
                          }
                          return null;
                        },
                        onChanged: (val) {
                          widget.github = val;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: widget.email,
                        decoration: InputDecoration(
                          hintText: "Email Address",
                          labelText: "Email Address",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        validator: (val) {
                          if ((!val.contains("@") || !val.contains(".")) &&
                              val != "") {
                            return "Please provide a valid Email AAdress.";
                          }
                          return null;
                        },
                        onChanged: (val) {
                          widget.email = val;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: widget.linkedIn,
                        decoration: InputDecoration(
                          hintText: "LinkedIn Url",
                          labelText: "LinkedIn Url",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        onChanged: (val) {
                          widget.linkedIn = val;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: widget.mobilenumber,
                        decoration: InputDecoration(
                          hintText: "Moblie Number",
                          labelText: "Moblie Number",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        validator: (val) {
                          String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                          RegExp regExp = new RegExp(pattern);
                          if (!regExp.hasMatch(val) && val != "") {
                            return 'Please enter valid mobile number';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          widget.mobilenumber = val;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.yellow,
                        onPressed: () async {
                          setState(() {
                            isloading = true;
                          });
                          try {
                            if (_isInterstitialAdReady) {
                              _interstitialAd.show();
                            }
                            if (_formkey.currentState.validate()) {
                              await _database.updateUserData(
                                  id: _auth.getCurrentUser().uid,
                                  username: widget.username,
                                  codechef_handle: widget.codechef,
                                  codeforces_handle: widget.codeforces,
                                  hackerRank_handle: widget.hackerrank,
                                  gitHub_handle: widget.github,
                                  dp: widget.image,
                                  aboutme: widget.aboutMe,
                                  achievements: widget.achievements,
                                  dpUrl: widget.dpurl,
                                  email: widget.email,
                                  linkedIn: widget.linkedIn,
                                  mobileNumber: widget.mobilenumber);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            }
                          } catch (e) {
                            print(e);
                          } finally {
                            setState(() {
                              isloading = false;
                            });
                          }
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(fontSize: 50),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: AdSize.banner.height + 5.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
