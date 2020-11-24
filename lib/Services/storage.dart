import 'dart:io';

import 'package:Portfolio/Services/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageRepo {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final _auth = AuthServices();
  Future<String> uploadFile(File file) async {
    var user = _auth.getCurrentUser();
    var storageRef = storage.ref().child("user/profile/${user.uid}");
    await storageRef.putFile(file);
    final  downloadableLink = await storageRef.getDownloadURL();
    return downloadableLink;
  }
  
}
