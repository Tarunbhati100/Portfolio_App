import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final CollectionReference portfolioCollection =
      FirebaseFirestore.instance.collection('portfolio');

  Future<void> updateUserData(
      String id,
      String username,
      String codechef_handle,
      String codeforces_handle,
      String hackerRank_handle,
      String gitHub_handle) async {
    return await portfolioCollection.doc(id).set({
      'Username': username ?? "",
      'Codechef Handle': codechef_handle ?? "",
      'Codeforces Handle': codeforces_handle ?? "",
      'HackerRank Handle': hackerRank_handle ?? "",
      'GitHub Handle': gitHub_handle ?? "",
    });
  }

  List _snapshotList(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return doc.data()['Username'];
    }).toList();
  }

  Stream<List> get id {
    return portfolioCollection.snapshots().map(_snapshotList);
  }
}
