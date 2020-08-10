import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smartbins/db/users.dart';
//enum Status{Uninitialized,Authenticated,Authenticating,Unauthenticated}

//class UserProvider with ChangeNotifier{
class UserProvider {
  FirebaseAuth _auth;

//  FirebaseUser _user;
//  Status _status= Status.Uninitialized;
//  Status get status=> _status;
//  FirebaseUser get user=> _user;
  UserServices _userServices = UserServices();
  final _storage = FlutterSecureStorage();

  Future<bool> signIn(String email, String password) async {
    _auth = FirebaseAuth.instance;
    try {
//      _status= Status.Authenticating;
//      notifyListeners();
      await _storage.deleteAll();
      await _storage.write(key: "status", value: "Authenticated");
      await _storage.write(key: "email", value: email);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser current_user = await _auth.currentUser();
      print("====================================");
      print(current_user.uid);
      await _storage.write(key: "uid", value: current_user.uid);
      return true;
    } catch (e) {
//      _status = Status.Unauthenticated;
//      notifyListeners();
      await _storage.deleteAll();
      await _storage.write(key: "status", value: "Unauthenticated");
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUp(String name, String email,String mobile, String password) async {
    _auth = FirebaseAuth.instance;
    FirebaseUser user;
    try {
//      _status= Status.Authenticating;
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) {
        Map<String, dynamic> values = {
          "name": name,
          "email": email,
          "mobile": mobile,
          "userId": user.user.uid
        };
        print(values);
          _userServices.createUser(values);
      });
      await _storage.deleteAll();
      await _storage.write(key: "status", value: "Unauthenticated");
      return true;
    } catch (e) {
//      _status = Status.Unauthenticated;
//      notifyListeners();
      await _storage.deleteAll();
      await _storage.write(key: "status", value: "Unauthenticated");
      print(e.toString());
      return false;
    }
  }
}
