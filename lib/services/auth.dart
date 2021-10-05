
import 'package:chat_application/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  UserModel? _userFromFirebase(User? user){
    return user != null ? UserModel(userId: user.uid) : null;
  }

  Future signInWithGoogle() async{
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication= await googleSignInAccount!.authentication;
      final AuthCredential authCredential= GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken
      );
      return await _auth.signInWithCredential(authCredential);
    } on Exception catch (e) {
      // TODO
      Fluttertoast.showToast(msg: "$e", toastLength: Toast.LENGTH_LONG);
    }

  }

  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      var result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      var user = result.user;
      return _userFromFirebase(user);
    }catch(e){
      Fluttertoast.showToast(msg: e.toString());
      return null;
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async{
    try{
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password
      );
      var user = result.user;
      return _userFromFirebase(user);
    }catch(e){
      Fluttertoast.showToast(msg: e.toString(),backgroundColor: Colors.white, textColor: Colors.black);
      return null;
    }
  }

  Future resetPassword(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e);
    }
  }

  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e);
    }
  }
}