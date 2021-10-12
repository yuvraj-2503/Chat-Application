
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async{
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication= await googleSignInAccount!.authentication;
      final AuthCredential authCredential= GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken
      );
      final UserCredential userCredential = await _auth.signInWithCredential(authCredential);
      _user = userCredential.user;
      return _user;
    }catch (e) {
      // TODO
      print(e);
    }

  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      _user = result.user;
      return _user;
    }catch(e){
      print(e);
    }
  }

  Future<User?> signUpWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password
      );
      _user = result.user;
      return _user;
    }catch(e){
      print(e);
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
      await _googleSignIn.signOut();
      await _auth.signOut();
    }catch(e){
      print(e);
    }
  }
}