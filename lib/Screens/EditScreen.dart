import 'dart:io';
import 'package:Portfolio/Screens/Authentication/HomeScreen.dart';
import 'package:Portfolio/Services/database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Services/auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EditScreen extends StatefulWidget {
  String dpurl;
  String username;
  String codechef;
  String codeforces;
  String hackerrank;
  String github;
  String aboutMe;
  String achievements;
  PickedFile image;
  EditScreen({
    this.dpurl,
    this.github,
    this.hackerrank,
    this.codeforces,
    this.codechef,
    this.username,
    this.achievements,
    this.aboutMe,
  });
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _auth = AuthServices();
  final _database = DatabaseServices();

  final _formkey = GlobalKey<FormState>();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()));
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
                    widget.image = await ImagePicker().getImage(
                        source: ImageSource.gallery, imageQuality: 50);
                    setState(() {});
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.amber,
                        child: widget.image == null
                            ? CircleAvatar(
                                radius: 105,
                                backgroundColor: Colors.blueGrey,
                                child: ClipOval(
                                  child: widget.dpurl == null
                                      ? SizedBox()
                                      : CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          height: 200,
                                          width: 200,
                                          imageUrl: widget.dpurl,
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
                                    File(widget.image.path),
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
                          if (val == null || val.contains(" ")) {
                            return "Please provide a valid Username.";
                          }
                          return null;
                        },
                        onChanged: (val) {
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
                                  username: widget.username,
                                  codechef_handle: widget.codechef,
                                  codeforces_handle: widget.codeforces,
                                  hackerRank_handle: widget.hackerrank,
                                  gitHub_handle: widget.github,
                                  dp: widget.image != null
                                      ? File(widget.image.path)
                                      : null,
                                  aboutme: widget.aboutMe,
                                  achievements: widget.achievements,
                                  dpUrl: widget.dpurl);
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
