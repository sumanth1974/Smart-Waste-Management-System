import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smartbins/Pages/drivers.dart';
import 'package:smartbins/Pages/home.dart';
import 'package:smartbins/Pages/login.dart';
import 'package:smartbins/Pages/maps.dart';
import 'package:smartbins/commons/common.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smartbins/commons/topcontainer.dart';

//My own imports
import 'package:smartbins/provider/user_provider.dart';

String uid;

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final _storage = FlutterSecureStorage();
  FirebaseAuth auth = FirebaseAuth.instance;

//  File _image;
//  String _uploadedFileURL;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_uid().then((id) {
      setState(() {});
    });
  }

//  Future chooseFile() async {
//    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
//      setState(() {
//        _image = image;
//      });
//    });
//  }
//  Future uploadFile() async {
//    final user = UserProvider();
//
//    StorageReference storageReference = FirebaseStorage.instance
//        .ref()
//        .child('users').child(uid).child("image");
//    StorageUploadTask uploadTask = storageReference.putFile(_image);
//    await uploadTask.onComplete;
//    print('File Uploaded');
//    storageReference.getDownloadURL().then((fileURL) {
//      setState(() {
//        _uploadedFileURL = fileURL;
//      });
//    });
//  }
  @override
  Widget build(BuildContext context) {
    //AppProvider appProvider = Provider.of<AppProvider>(context);
    final user = UserProvider();
    print("===================== P R I N T I N G ===============");
    print(uid);
//    var imageUrl=FirebaseStorage.instance.ref().child('users').child(uid).child("image").getDownloadURL();
    Widget image_carousel = new Container(
      height: 200.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('images/main3.jpg'),
          AssetImage('images/main1.jpg'),
          AssetImage('images/main2.jpg'),
          AssetImage('images/main4.jpg'),
        ],
        autoplay: true,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        indicatorBgPadding: 8.0,
        dotBgColor: Colors.transparent,
        //dotColor :Colors.red,
      ),
    );
    return Scaffold(
      backgroundColor: Color(0xFFFFF9EC),
      appBar: new AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xFFF9BE7C),
//          title: Text('SmartBin'),
          iconTheme: new IconThemeData(color: Color(0xFF0D253F)),
          leading: IconButton(
              icon: Icon(Icons.arrow_back,),
//            onPressed: () => changeScreenReplacement(context, HomePage())),
//          Navigator.of(context).pop()
              onPressed: () => Navigator.of(context).pop()),
          actions: <Widget>[
            new IconButton(
                icon: Icon(
                  Icons.exit_to_app,
//                  color: Colors.white,
                ),
                onPressed: () {
//                  FirebaseAuth.instance.signOut().then((value){
//                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
//                  });

                  signOut();
                  changeScreenReplacement(context, Login());
                })
          ]),
      //body: new ListView(
      body: new Column(
        children: <Widget>[
          //Image carousel begins here
          //image_carousel,
          //Padding widget
          TopContainer(
            height: 60,
            child: Column(
//                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0, vertical: 0.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          "Account Details",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 25,
                            color: Color(0xFF0D253F),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
//          Center(
//            child: new Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: new Text('Your Account Details',
//                  style: TextStyle(
//                      fontWeight: FontWeight.bold,
//                      color: Colors.red,
//                      fontSize: 18.0)),
//            ),
//          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Image.asset(
                'images/accnt.png',
                // imageUrl.toString(),
                height: 150.0,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('users')
                .where('userId', isEqualTo: uid)
                .snapshots(),
            builder: (context, snapshot) {
              print(snapshot.data.documents[0]);
              return _buildList(context, snapshot.data.documents[0]);
            },
          ),
//          _image == null
//              ? RaisedButton(
//            child: Text('Choose File'),
//            onPressed: chooseFile,
//            color: Colors.cyan,
//          )
//              : Container(),
//          _image != null
//              ? RaisedButton(
//            child: Text('Upload File'),
//            onPressed: uploadFile,
//            color: Colors.cyan,
//          )
//              : Container(),
        ],
      ),
    );
  }

  get_uid() async {
    final current_user = await _storage.readAll();
    uid = current_user["uid"];
  }

  signOut() async {
    auth.signOut();
    await _storage.deleteAll();
    await _storage.write(key: "status", value: "Unauthenticated");
  }
}

_buildList(context, document) {
//  Firestore.instance.collection('driver_details').document('1').updateData({"status":'Alloted'});
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(5)),
          margin: new EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10),
          child: Container(
//            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            decoration: BoxDecoration(color: Color(0xFFFFE4C7)),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10),
              title: Row(
                children: <Widget>[
                  Text(
                    "Name :",
                    style: TextStyle(
                        fontSize: 16,fontWeight: FontWeight.bold,color:Colors.black),
                  ),
                  Text(
                    document["name"].toString(),
                    style: TextStyle(
                        fontSize: 16,color:Colors.black),
                  ),
                ],
              ),
              subtitle: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("Email : ",
                          style: TextStyle(
                              fontSize: 16,fontWeight: FontWeight.bold,color:Colors.black)),
                      Text(document["email"].toString(),
                        style: TextStyle(
                            fontSize: 16,color:Colors.black87),),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("Mobile : ",
                          style: TextStyle(
                              fontSize: 16,fontWeight: FontWeight.bold,color:Colors.black)),
                      Text(document["mobile"].toString(),
                        style: TextStyle(
                            fontSize: 16,color:Colors.black87),),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

_buildList3(context, document) {
  return UserAccountsDrawerHeader(
    accountName: Text(document["name"].toString()),
    accountEmail: Text(document["email"].toString()),
    currentAccountPicture: GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.person,
          color: Colors.orange,
        ),
      ),
    ),
    decoration: new BoxDecoration(
      color: Colors.orange,
    ),
  );
}
