import 'package:Portfolio/Services/auth.dart';
import 'package:Portfolio/Services/adManager.dart';
import 'package:Portfolio/wrapper.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: StreamProvider<firebase.User>.value(
            value: AuthServices().user,
            child: SafeArea(
              child: Wrapper(),
            )));
  }
}