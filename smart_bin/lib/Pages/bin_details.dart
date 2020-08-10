import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartbins/Pages/directions.dart';
import 'package:smartbins/Pages/graphs.dart';
import 'package:smartbins/Pages/range_graph.dart';
import 'package:smartbins/commons/common.dart';
import 'package:smartbins/commons/topcontainer.dart';

import 'login.dart';
import 'maps.dart';

//
//final String title;
final _storage = FlutterSecureStorage();
String userid;

class BinDetails extends StatefulWidget {
//  BinDetails({Key key, title}) : super(key: key);

  final bin_name;
  final position;
  final bin_id;
  final bin_status;
  
  BinDetails(
      {
        this.bin_id,
        this.position,
        this.bin_name,
        this.bin_status
      });

  @override
  _BinDetailsState createState() => _BinDetailsState();
}

class _BinDetailsState extends State<BinDetails> {
  final _storage = FlutterSecureStorage();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    final user = Provider.of<UserProvider>(context);
  var location=widget.position;
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
                    userid = " ";
                    signOut();
                    changeScreenReplacement(context, Login());
                  })
            ]),

//      body: _buildListViewOfBinDetailss(context),
        body: ListView(
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
                            "Bin Details",
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
            Padding(
              padding: EdgeInsets.only(top: 20,left: 10,right: 10,bottom: 10),
              child: Container(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'images/bin.png',
                    width: 100,
                  )),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(
                    0, 20, 0, 0)),

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
                        "Bin : ",
                        style: TextStyle(
                            fontSize: 16,fontWeight: FontWeight.bold,color:Colors.black),
                      ),
                      Text(
                        widget.bin_name.toString().toUpperCase(),
                        style: TextStyle(
                            fontSize: 16,color:Colors.black),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text("Bin Status : ",
                              style: TextStyle(
                                  fontSize: 16,fontWeight: FontWeight.bold,color:Colors.black)),
                          Text(widget.bin_status.toString().toUpperCase(),
                            style: TextStyle(
                                fontSize: 12,color:Colors.black87),),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("Bin location : ",
                              style: TextStyle(
                                  fontSize: 16,fontWeight: FontWeight.bold,color:Colors.black)),
                          Text("Lat: "+ location.latitude.toString() +", Long: " + location.longitude.toString(),
                            style: TextStyle(
                                fontSize: 12,color:Colors.black87),),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Row(
                children: <Widget>[
                  InkWell(
                    child: Card(
                      color: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 10,left: 10,
                            bottom: 10,right: 10),
                        child: Center(
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Get bin directions',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,fontSize: 16,color: Colors.white
                                ),
                              ),
                              Image.asset("images/maps1.png",width: 40,)
                            ],
                          ),
                        ),
                      ),
                    ),
                    onTap: (){
                      changeScreen(context,DirectionMaps(bin_name: widget.bin_name,bin_location: widget.position,));
                    },
                  ),
                  InkWell(
                    child: Card(
                      color: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 22,left: 30,
                            bottom: 22,right: 30),
                        child: Center(
                          child: Text(
                            'Get bin history',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,fontSize: 14,color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ),
                    onTap: (){
                      changeScreen(context,RangeGraph(bin_id: widget.bin_id,bname: widget.bin_name,));
                    },
                  ),
                ],
              ),
            )
          ],
        ),
    );
  }

  signOut() async {
    auth.signOut();
    await _storage.deleteAll();
    await _storage.write(key: "status", value: "Unauthenticated");
  }
  }

