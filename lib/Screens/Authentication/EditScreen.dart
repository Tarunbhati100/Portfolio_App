import 'dart:io';
import 'package:Portfolio/Screens/HomeScreen.dart';
import 'package:Portfolio/Services/database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../Services/auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EditScreen extends StatefulWidget {
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _auth = AuthServices();
  final _database = DatabaseServices();
  void initialize() async {
    final user = await _database.getUser(_auth.getCurrentUser().uid);
    username = user.userName;
    aboutMe = user.aboutme;
    achievements = user.achievements;
    codechef = user.codechef;
    codeforces = user.codeforces;
    github = user.gitHub;
    hackerrank = user.hackerRank;
    dpurl = user.dpUrl;
    setState(() {});
  }

  final _formkey = GlobalKey<FormState>();
  bool isloading = false;
  String dpurl;
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
    initialize();
    return Scaffold(
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
                            ? CircleAvatar(
                                radius: 105,
                                backgroundColor: Colors.blueGrey,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    height: 200,
                                    width: 200,
                                    imageUrl: dpurl,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                radius: 105,
                                backgroundColor: Colors.blueGrey,
                                child: ClipOval(
                                  child: Image.file(
                                    File(image.path),
                                    fit: BoxFit.fill,
                                    width: 200,
                                    height: 200,
                                  ),
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
                        initialValue: aboutMe,
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
                        initialValue: achievements,
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
                        initialValue: username,
                        decoration: InputDecoration(
                          hintText: "UserName",
                          labelText: "UserName",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        validator: (val) {
                          if (val == null) {
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
                        initialValue: codechef,
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
                        initialValue: codeforces,
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
                        initialValue: hackerrank,
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
                        initialValue: github,
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
                              await _database.updateUserData(
                                  id: _auth.getCurrentUser().uid,
                                  username: username,
                                  codechef_handle: codechef,
                                  codeforces_handle: codeforces,
                                  hackerRank_handle: hackerrank,
                                  gitHub_handle: github,
                                  dp: File(image.path),
                                  aboutme: aboutMe,
                                  achievements: achievements);
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
