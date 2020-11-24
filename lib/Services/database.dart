import 'package:Portfolio/modals/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final CollectionReference portfolioCollection =
      FirebaseFirestore.instance.collection('portfolio');

  Future<void> updateUserData({
    String id,
    String username,
    String dpurl,
    String codechef_handle,
    String codeforces_handle,
    String hackerRank_handle,
    String gitHub_handle,
    String aboutme,
    String achievements,
  }) async {
    return await portfolioCollection.doc(id).set({
      'Username': username ?? "",
      'Codechef Handle': codechef_handle ?? "",
      'Codeforces Handle': codeforces_handle ?? "",
      'HackerRank Handle': hackerRank_handle ?? "",
      'GitHub Handle': gitHub_handle ?? "",
      'dpurl': dpurl,
      'About Me': aboutme,
      'Achievements': achievements,
    });
  }

  List _snapshotList(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return doc.data()['Username'];
    }).toList();
  }

  Stream<List> get data {
    return portfolioCollection.snapshots().map(_snapshotList);
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
}
