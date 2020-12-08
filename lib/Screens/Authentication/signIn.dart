import 'package:Portfolio/Screens/HomeScreen.dart';
import 'package:Portfolio/Services/auth.dart';
import 'package:Portfolio/Services/adManager.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'SignUp.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  BannerAd _bannerAd;
  bool _showPassword = false;
  final _auth = AuthServices();

  String emailid;

  String password;

  bool isloading = false;
  InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady;
  final _formkey = GlobalKey<FormState>();
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
    return ModalProgressHUD(
      inAsyncCall: isloading,
      child: Scaffold(
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
        body: Container(
          padding: EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Login to your account",
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
                Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Please Enter your email.";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Email",
                          labelText: "Email",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        onChanged: (val) {
                          emailid = val;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !_showPassword,
                        textInputAction: TextInputAction.none,
                        validator: (val) {
                          if (val.length < 6) {
                            return "Password must contain atleast 6 characters.";
                          }
                          return null;
                        },
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
                        onChanged: (val) {
                          password = val;
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
                          if(_formkey.currentState.validate()){
                          setState(() {
                            isloading = true;
                          });
                          try {
                            if (_isInterstitialAdReady) {
                              _interstitialAd.show();
                            }
                            final newUser = await _auth
                                .signInWithEmailAndPassword(emailid, password);
                            if (newUser != null) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            }
                          } catch (e) {
                            Flushbar(
                              icon:
                                  Icon(Icons.error_outline, color: Colors.red),
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
                          "Log In",
                          style: TextStyle(fontSize: 50),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Don't have an Account? | ",
                            textAlign: TextAlign.end,
                          ),
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => SignUp()));
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 150,
                  child: SvgPicture.asset("./assets/images/lighthouse.svg"),
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
