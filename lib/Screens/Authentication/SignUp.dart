import 'package:Portfolio/Screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import '../../Services/auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignUp extends StatefulWidget {
  Function toggleCallback;
  Function backCallback;
  SignUp({this.toggleCallback, this.backCallback});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = AuthServices();
  final _formkey = GlobalKey<FormState>();
  bool isloading = false;
  String emailid;
  String password;
  String username;
  String codechef;
  String codeforces;
  String hackerrank;
  String github;
  String _error;
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
          onPressed: widget.backCallback,
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isloading,
        child: Container(
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
                Form(
                  key: _formkey,
                  child: Column(
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
                          emailid = email;
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
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          labelText: "Password",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
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
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          labelText: "Confirm Password",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
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
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "UserName",
                          labelText: "UserName",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        onChanged: (val) {
                          username = val;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Codechef Handle",
                          labelText: "Codechef Handle",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        onChanged: (val) {
                          codechef = val;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Codeforces Handle",
                          labelText: "Codeforces Handle",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        onChanged: (val) {
                          codeforces = val;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "HakerRank Handle",
                          labelText: "HackerRank Handle",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        onChanged: (val) {
                          hackerrank = val;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "GitHub Handle",
                          labelText: "GitHub Handle",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        onChanged: (val) {
                          github = val;
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
                            if (_formkey.currentState.validate()) {
                              final newUser =
                                  await _auth.registerWithEmailAndPassword(
                                      emailid,
                                      password,
                                      username,
                                      codechef,
                                      codeforces,
                                      hackerrank,
                                      github);
                              if (newUser != null) {
                                await _auth.signInWithEmailAndPassword(
                                    emailid, password);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              }
                            }
                          } catch (e) {
                            _error = e.code;
                          } finally {
                            setState(() {
                              isloading = false;
                            });
                            if (_error != null) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text(_error),
                              ));
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
                        onPressed: widget.toggleCallback,
                        child: Text(
                          "Log In",
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
