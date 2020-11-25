import 'package:Portfolio/Screens/HomeScreen.dart';
import 'package:Portfolio/Services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignIn extends StatefulWidget {
  final Function toggleCallback;
  final Function backCallback;

  SignIn({this.toggleCallback, this.backCallback});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _showPassword = false;
  final _auth = AuthServices();

  String emailid;

  String password;

  bool isloading = false;

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
            onPressed: widget.backCallback,
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
                    setState(() {
                      isloading = true;
                    });
                    try {
                      final newUser = await _auth.signInWithEmailAndPassword(
                          emailid, password);
                      if (newUser != null) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
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
                        onPressed: widget.toggleCallback,
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ))
                  ],
                ),
                Container(
                  height: 150,
                  child: SvgPicture.asset("./assets/lighthouse.svg"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
