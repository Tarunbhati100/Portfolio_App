import 'dart:io';
import 'package:Portfolio/Services/storage.dart';
import 'package:Portfolio/modals/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final CollectionReference portfolioCollection =
      FirebaseFirestore.instance.collection('portfolio');

  Future<void> updateUserData({
    String id,
    String username,
    File dp,
    String codechefHandle,
    String codeforcesHandle,
    String hackerRankHandle,
    String gitHubHandle,
    String aboutme,
    String achievements,
    String dpUrl,
    String email,
    String mobileNumber,
    String linkedIn,
  }) async {
    try {
      final dpurl = (dp != null) ? await StorageRepo().uploadFile(dp) : dpUrl;
      return await portfolioCollection.doc(id).set({
        'Username': username ?? "",
        'Codechef Handle': codechefHandle ?? "",
        'Codeforces Handle': codeforcesHandle ?? "",
        'HackerRank Handle': hackerRankHandle ?? "",
        'GitHub Handle': gitHubHandle ?? "",
        'dpurl': dpurl ?? "",
        'About Me': aboutme ?? "",
        'Achievements': achievements ?? "",
        'linkedIn': linkedIn ?? "",
        'mobileNumber': mobileNumber ?? "",
        'email': email ?? "",
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<Map<String, dynamic>>> get getdata async {
    final doc = await portfolioCollection.get();
    return doc.docs.map((e) => e.data()).toList();
  }

  Future<User> getUser(String uid) async {
    try{
    final doc = await portfolioCollection.doc(uid).get();
    return User(
      codeforces: doc.data()['Codeforces Handle'],
      gitHub: doc.data()['GitHub Handle'],
      userName: doc.data()['Username'],
      codechef: doc.data()['Codechef Handle'],
      hackerRank: doc.data()['HackerRank Handle'],
      dpUrl: doc.data()['dpurl'],
      aboutme: doc.data()['About Me'],
      achievements: doc.data()['Achievements'],
      linkedIn: doc.data()['linkedIn'],
      mobileNumber: doc.data()['mobileNumber'],
      email: doc.data()['email'],
    );}catch(e){print(e);}
  }

  void deleteUserdata(String uid) {
    try {
      portfolioCollection.doc(uid).delete();
      StorageRepo().deleteStorageData(uid);
    } catch (e) {
      print(e);
    }
  }
}
