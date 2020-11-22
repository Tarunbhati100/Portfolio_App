import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final CollectionReference blogsCollection =
      FirebaseFirestore.instance.collection('portfolio');

  Future<void> updateUserData(
      String id,
      String codechef_handle,
      String codeforces_handle,
      String hackerRank_handle,
      String gitHub_handle) async {
    return await blogsCollection.doc(id).set({
      'Codechef Handle': codechef_handle??"",
      'Codeforces Handle': codeforces_handle??"",
      'HackerRank Handle': hackerRank_handle??"",
      'GitHub Handle': gitHub_handle??"",

    });
  }

}
