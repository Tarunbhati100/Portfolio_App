import 'dart:io';
import 'package:Portfolio/Screens/HomeScreen.dart';
import 'package:Portfolio/Services/adManager.dart';
import 'package:Portfolio/Services/database.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../Services/auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'signIn.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = AuthServices();
  final _formkey = GlobalKey<FormState>();
  bool isloading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  String emailid;
  String password;
  String username;
  String codechef;
  String codeforces;
  String hackerrank;
  String github;
  String aboutMe;
  String achievements;
  File image;
  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  bool _usernameavailable = true;
  bool _isInterstitialAdReady;
  String email;
  String mobilenumber;
  String linkedIn;
  void _loadInterstitialAd() {
    _interstitialAd.load();
  }

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

  bool _checkUser(List<Map<String, dynamic>> data, String username) {
    for (var element in data) {
      if (element['Username'].toString() == username) {
        return false;
      }
    }
    return true;
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
      ),
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
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Create an account. It's free",
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
                    image = await ImageCropper.cropImage(
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
                        child: image == null
                            ? Icon(
                                Icons.account_circle,
                                color: Colors.white,
                                size: 200,
                              )
                            : ClipOval(
                                child: Image.file(
                                  File(image.path),
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
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Email",
                          labelText: "Email",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        onChanged: (email) {
                          emailid = email.toLowerCase();
                        },
                        validator: (val) {
                          if (val == null || val == "") {
                            return "Please Provide Valid email";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.none,
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                          hintText: "Password",
                          labelText: "Password",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          suffixIcon: IconButton(
                            icon: _showPassword
                                ? Icon(Icons.remove_red_eye)
                                : Icon(Icons.remove_red_eye_outlined),
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                          ),
                        ),
                        onChanged: (pass) {
                          password = pass;
                        },
                        validator: (val) {
                          if (val.length < 6) {
                            return "Password must contain atleast 6 characters.";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !_showConfirmPassword,
                        textInputAction: TextInputAction.none,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          labelText: "Confirm Password",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          suffixIcon: IconButton(
                            icon: _showConfirmPassword
                                ? Icon(Icons.remove_red_eye)
                                : Icon(Icons.remove_red_eye_outlined),
                            onPressed: () {
                              setState(() {
                                _showConfirmPassword = !_showConfirmPassword;
                              });
                            },
                          ),
                        ),
                        onChanged: null,
                        validator: (val) {
                          if (val != password) {
                            return "Passwords don't match";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
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
                          aboutMe = text;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
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
                          achievements = text;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
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
                          } else if (_usernameavailable == false) {
                            return "Username Already Exist. Please Try another one.";
                          }
                          return null;
                        },
                        onChanged: (val) async {
                          final alldata = await DatabaseServices().getdata;
                          _usernameavailable = _checkUser(alldata, val);
                          username = val.toLowerCase();
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
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
                          codechef = val;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
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
                          codeforces = val;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
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
                          hackerrank = val;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
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
                          github = val;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
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
                            return "Please provide a valid Email Address.";
                          }
                          return null;
                        },
                        onChanged: (val) {
                          email = val;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "LinkedIn Url",
                          labelText: "LinkedIn Url",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        onChanged: (val) {
                          linkedIn = val;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
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
                          mobilenumber = val;
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
                          if (_formkey.currentState.validate()) {
                            setState(() {
                              isloading = true;
                            });
                            try {
                              if (_isInterstitialAdReady) {
                                _interstitialAd.show();
                              }
                              final newUser =
                                  await _auth.registerWithEmailAndPassword(
                                emailid: emailid,
                                password: password,
                                username: username,
                                codechefHandle: codechef,
                                codeforcesHandle: codeforces,
                                hackerRankHandle: hackerrank,
                                gitHubHandle: github,
                                dp: image,
                                aboutme: aboutMe,
                                achievements: achievements,
                                email: email,
                                linkedIn: linkedIn,
                                mobileNumber: mobilenumber,
                              );
                              if (newUser != null) {
                                await _auth.signInWithEmailAndPassword(
                                    emailid, password);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              }
                            } catch (e) {
                              Flushbar(
                                icon: Icon(Icons.error_outline,
                                    color: Colors.red),
                                flushbarPosition: FlushbarPosition.TOP,
                                message: e.message,
                                duration: Duration(seconds: 3),
                              ).show(context);
                            } finally {
                              setState(() {
                                isloading = false;
                              });
                            }
                          }
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 50),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Already have an Account? | ",
                      textAlign: TextAlign.end,
                    ),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => SignIn()));
                        },
                        child: Text(
                          "Log In",
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: AdSize.banner.height + 10.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
