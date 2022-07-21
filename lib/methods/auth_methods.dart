
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myams/constants.dart';
import '../models/user.dart' as model;
class AuthMethods{
  final FirebaseAuth _firebaseAuth=firebaseAuth;
  final FirebaseFirestore _fireStore=firebaseFirestore;

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
  //GetUserInfo
  Future<model.User> getUserInfo()async{
    User currentUser=_firebaseAuth.currentUser!;
    DocumentSnapshot documentSnapshot=await _fireStore.collection('users').doc(currentUser.uid).get();
    return model.User.getValuesFromSnap(documentSnapshot);
  }
  Future<String> signInWithGoogle() async{
    String res="Some error occurred";
    try
    {
      final GoogleSignInAccount? googleUser=await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth=await googleUser?.authentication;
      final credential =GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken
      );
      UserCredential userCredential=await _firebaseAuth.signInWithCredential(credential);
      User? user=userCredential.user;
      if(user!=null)
      {
        // if(userCredential.additionalUserInfo!.isNewUser)
        {
          model.User userModel=model.User(
            uid: user.uid,
            name: user.displayName!,
            email: user.email!,
            photoUrl: user.photoURL!,
            total: "",
            grade: "",
            presents: "",
            absents: "",
            leaves: "",
          );
          _fireStore.collection('users').doc(user.uid).set(userModel.toJson());
        }
        res="Success";
      }
    }
    on FirebaseAuthException catch(e)
    {
      print('google signin error occured');
      res=e.message.toString();
    }
    return res;
  }

  //SignupUser
  Future<String> signUpUser(
      {
        required String name,
        required String email,
        required String password,
      })
  async
  {
    String res="Some error occurred";
    try{
      //if the fields are not empty than registering the user
      if(email.isNotEmpty&& password.isNotEmpty)
      {
        UserCredential credential=await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
        model.User user=model.User(
          uid:credential.user!.uid,
          name:name.trim(),
          email:email.trim(),
          photoUrl:'',
          total:'32',
          grade: 'Not Available',
          presents: '0',
          absents: '0',
          leaves: '0',
        );
        await _fireStore.collection("users").doc(credential.user!.uid).set(user.toJson());
        res="Success";
      }
    }
    on FirebaseAuthException catch(err)
    {
      res=err.message.toString();
    }
    return res;
  }
  //loginUser
  Future<String> loginUser(
      {
        required String email,
        required String password,
        required BuildContext context
      })
  async
  {
    String res="Some error occurred";
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      res="Success";
    }
    on FirebaseAuthException catch(err)
    {
      res=err.message.toString();
    }
    return res;
  }

  Future<String> addPhotoToFirestore(
      {
        required String url,
      })
  async
  {
    String res="Some error occurred";
    try{
      //if the fields are not empty than registering the user
      if(url.isNotEmpty)
      {
        _fireStore.collection("users").doc(_firebaseAuth.currentUser?.uid).update(
            {
              'photoUrl':url,
            }
        );
        res="success";
      }
    }
    catch(err){
      res=err.toString();
    }
    return res;
  }
}