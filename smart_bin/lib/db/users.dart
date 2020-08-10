import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

//class UserServices{
//  FirebaseDatabase _database = FirebaseDatabase.instance;
//  String ref="users";
//  createUser(Map value){
//    String id=value["userId"];
//    _database.reference().child(ref).push().set(
//    //    _database.reference().child("$ref/$id").set(
//      value
//    ).catchError((e)=>{print(e.toString())});
//  }
//}
class UserServices{
  Firestore _firestore = Firestore.instance;
  String collection="users";
  createUser(Map value){
    String id=value["userId"];
    _firestore.collection(collection).document(value["userId"]).setData(value);
  }
}