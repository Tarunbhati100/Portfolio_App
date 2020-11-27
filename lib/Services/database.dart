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
    String codechef_handle,
    String codeforces_handle,
    String hackerRank_handle,
    String gitHub_handle,
    String aboutme,
    String achievements,
    String dpUrl,
  }) async {
    final dpurl = (dp != null) ? await StorageRepo().uploadFile(dp) : dpUrl;
    return await portfolioCollection.doc(id).set({
      'Username': username ?? "",
      'Codechef Handle': codechef_handle ?? "",
      'Codeforces Handle': codeforces_handle ?? "",
      'HackerRank Handle': hackerRank_handle ?? "",
      'GitHub Handle': gitHub_handle ?? "",
      'dpurl': dpurl ?? "",
      'About Me': aboutme ?? "",
      'Achievements': achievements ?? "",
    });
  }

  List<Map<String, dynamic>> _snapshotList(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return doc.data();
    }).toList();
  }

  Stream<List<Map<String, dynamic>>> get data {
    return portfolioCollection.snapshots().map(_snapshotList);
  }

  Future<List<Map<String, dynamic>>> get getdata async {
    final doc = await portfolioCollection.get();
    return doc.docs.map((e) => e.data()).toList();
  }

  Future<User> getUser(String uid) async {
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
    );
  }
  void deleteUserdata(String uid){
    portfolioCollection.doc(uid).delete();
    StorageRepo().deleteStorageData(uid);
  }
}
