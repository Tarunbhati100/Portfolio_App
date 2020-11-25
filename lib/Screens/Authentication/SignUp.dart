import 'dart:io';
import 'package:Portfolio/Screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../Services/auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignUp extends StatefulWidget {
  final Function toggleCallback;
  final Function backCallback;
  SignUp({this.toggleCallback, this.backCallback});

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
  PickedFile image;
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
                    image = await ImagePicker().getImage(
                        source: ImageSource.gallery, imageQuality: 50);
                    setState(() {});
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.amber,
                        child: image == null
                            ? Icon(
                                Icons.image,
                                size: 100,
                                color: Colors.black,
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
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "UserName",
                          labelText: "UserName",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        validator: (val) {
                          if (val == "") {
                            return "Please provide a valid Username.";
                          }
                          return null;
                        },
                        onChanged: (val) {
                          username = val.toLowerCase();
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
                                      email: emailid,
                                      password: password,
                                      username: username,
                                      codechef_handle: codechef,
                                      codeforces_handle: codeforces,
                                      hackerRank_handle: hackerrank,
                                      gitHub_handle: github,
                                      dp: image != null
                                          ? File(image.path)
                                          : null,
                                      aboutme: aboutMe,
                                      achievements: achievements);
                              if (newUser != null) {
                                await _auth.signInWithEmailAndPassword(
                                    emailid, password);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              }
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
