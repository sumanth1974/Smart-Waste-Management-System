import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

abstract class BaseAuth{
  Future<FirebaseUser> googleSignIn();
}

class Auth implements BaseAuth {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<FirebaseUser> googleSignIn() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleAccount.authentication;
    // TODO: implement googleSignIn
    final AuthCredential credential= GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    try{
      AuthResult authResult = await _firebaseAuth.signInWithCredential(credential);
      FirebaseUser user = authResult.user;
      return user;
    }catch(e){
      print(e.toString());
      return null;
    }
  }

}