
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods{
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage=FirebaseStorage.instance;
  Future<String> uploadImageToStorage(String childName, Uint8List file) async {

    //if the fields are not empty than adding the images
    Reference ref = _firebaseStorage.ref().child(childName).child(_firebaseAuth.currentUser!.uid);
    //uploadTask info
    UploadTask uploadTask = ref.putData(file);
    //Taking the snapshot to fetch url of the image
    TaskSnapshot taskSnapshot = await uploadTask.snapshot;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    print("upload success");
    return downloadUrl;

  }
}