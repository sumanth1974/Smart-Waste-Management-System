//import 'package:cloud_firestore/cloud_firestore.dart';
//
//class Product{
//  static const String Bin_status="binstatus";
//  static const String Location="location";
//
//  String _binstatus;
//  String _location;
//
//  String get binstatus => _binstatus;
//  String get location => _location;
//
//  Product.fromSnapshot(DocumentSnapshot snapshot){
//    Map data = snapshot.data;
//    print("----------------------IN PRODUCT----------------------");
//    print(snapshot.data);
//    _binstatus = data[Bin_status];
//    _location = data[Location];
//
//  }
//}