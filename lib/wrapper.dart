import 'package:Portfolio/Screens/Authentication/AuthScreen.dart';
import 'package:Portfolio/Screens/Authentication/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  
  final user = Provider.of<firebase.User>(context);
  // print(user);
    if(user == null){
      return AuthScreen();
    }else{
       return HomeScreen();
    }
  }
}