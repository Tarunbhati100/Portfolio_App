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
    String email,
    String password,
    String username,
    String codechef_handle,
    String codeforces_handle,
    String hackerRank_handle,
    String gitHub_handle,
    String aboutme,
    String achievements,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _database.updateUserData(
          id: result.user.uid,
          username: username,
          codechef_handle: codechef_handle,
          codeforces_handle: codeforces_handle,
          hackerRank_handle: hackerRank_handle,
          gitHub_handle: gitHub_handle,
          dp: dp,
          aboutme: aboutme,
          achievements: achievements);
      return result;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result;
    } catch (error) {
      print(error.toString());
      return null;
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
    final user = _auth.currentUser;
    _database.deleteUserdata(user.uid);
    user.delete();
  }
}
