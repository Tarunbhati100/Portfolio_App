import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _database = DatabaseServices();
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  User getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        return user;
      }
    } catch (e) {
      print(e);
    }
  }

  Future registerWithEmailAndPassword({
    File dp,
    String emailid,
    String password,
    String username,
    String codechefHandle,
    String codeforcesHandle,
    String hackerRankHandle,
    String gitHubHandle,
    String aboutme,
    String achievements,
    String email,
    String mobileNumber,
    String linkedIn,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: emailid, password: password);
      await _database.updateUserData(
        id: result.user.uid,
        username: username,
        codechefHandle: codechefHandle,
        codeforcesHandle: codeforcesHandle,
        hackerRankHandle: hackerRankHandle,
        gitHubHandle: gitHubHandle,
        dp: dp,
        aboutme: aboutme,
        achievements: achievements,
        linkedIn: linkedIn,
        mobileNumber: mobileNumber,
        email: email,
      );
      return result;
    } catch (error) {
      throw error;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result;
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  void deleteUser() {
    try {
      final user = _auth.currentUser;
      _database.deleteUserdata(user.uid);
      user.delete();
    } catch (e) {
      print(e);
    }
  }
}
