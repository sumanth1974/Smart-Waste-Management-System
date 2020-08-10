import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smartbins/commons/common.dart';
import 'package:smartbins/commons/percentage_card_widget.dart';
import 'package:smartbins/commons/topcontainer.dart';

import 'login.dart';

class AvailableBins extends StatefulWidget {
  @override
  _AvailableBinsState createState() => _AvailableBinsState();
}
var bin_name = [];
var bin_details = {};

class _AvailableBinsState extends State<AvailableBins> {
  final _storage = FlutterSecureStorage();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_bin_names().then((id) {
      setState(() {});
    });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFF9EC),
    appBar: AppBar(
    elevation: 0.0,
    backgroundColor: Color(0xFFF9BE7C),
//          title: Center(child: Text("Asset Tracker",style: TextStyle(color:Color(0xFF0D253F)),)),
    iconTheme: new IconThemeData(color: Color(0xFF0D253F)),
    leading: IconButton(
    icon: Icon(Icons.arrow_back, color: Color(0xFF0D253F)),
//              onPressed: () => changeScreenReplacement(context, HomePage())),
//          Navigator.of(context).pop()
    onPressed: () => Navigator.of(context).pop()),
    actions: <Widget>[
    new IconButton(
    icon: Icon(
    Icons.exit_to_app,
    color: Color(0xFF0D253F),
    ),
    onPressed: () {
    signOut();
    changeScreenReplacement(context, Login());
    })
    ]),

//      body: _buildListViewOfBinDetailss(context),
    body: buildhomepage(),
    );
  }
  get_bin_names() async{
    await Firestore.instance.collection("bins").getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
//        print(result.data);
        if (bin_name.contains(result.data['name']) == false) {
          bin_name.add(result.data['name']);
          bin_details[result.data['name']]=[result.data['location'],result.data['percent'],result.data['status'],result.documentID];
        }
        print(bin_details);
      });
    });
  }
  signOut() async {
    auth.signOut();
    await _storage.deleteAll();
    await _storage.write(key: "status", value: "Unauthenticated");
  }
}
buildhomepage(){
  List<ActiveProjectsCard> containers = new List<ActiveProjectsCard>();
  for (var i=0;i<bin_name.length;i++) {
//    print(bin_name[i]);
    var location=bin_details[bin_name[i]][0];
    containers.add(
      ActiveProjectsCard(
        cardColor: Colors.red,
        loadingPercent: double.parse(bin_details[bin_name[i]][1].toString())/100,
        title: bin_name[i].toString().toUpperCase()+' Bin',
        subtitle: "Lat: "+ location.latitude.toString() + ", Long: " +location.longitude.toString(),
        id:bin_details[bin_name[i]][3],
        name: bin_name[i],
        status:bin_details[bin_name[i]][2],
        position: bin_details[bin_name[i]][0],
      ),
    );
  }
  return ListView(
    children: <Widget>[
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
                      "Available bins",
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

//      Text(
//        "Smart Bin Status",
//        style: TextStyle(
//            color: Color(0xFF0D253F),
//            fontSize: 20.0,
//            fontWeight: FontWeight.w700,
//            letterSpacing: 1.2),
//      ),
      Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Smart Bin Status",
              style: TextStyle(
                  color: Color(0xFF0D253F),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
      ...containers,
    ],
  );
}