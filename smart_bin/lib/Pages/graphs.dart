import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:smartbins/Pages/login.dart';
import 'package:smartbins/commons/common.dart';
import 'package:smartbins/provider/user_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
//own imports
import 'home.dart';
import 'account.dart';

var uid;
var temp_results;
var bin_name=[];
var results={};
List<TemperatureData> temperatureData =<TemperatureData>[];
class BinGraphs extends StatefulWidget {
  final bin_id;
  final bname;
  BinGraphs({
    this.bin_id,
    this.bname,
  });
  @override
  _BinGraphsState createState() => _BinGraphsState();
}

class _BinGraphsState extends State<BinGraphs> {
  final _storage = FlutterSecureStorage();
  FirebaseAuth auth = FirebaseAuth.instance;
  var bname;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    get_bin_names().then((id) {
//      setState(() {});
//    });
//  }
  }
  @override
  Widget build(BuildContext context) {
    final user = UserProvider();
    bname=widget.bname;
    final Stream<QuerySnapshot> surroundigsData =Firestore.instance.collection('bins').document(widget.bin_id).collection('bin_log').snapshots();
    print(surroundigsData);
//    get_bin_names();
//    get_bin_details();
//    get_bin_details();
//    print(" n a m e s ------------------------");
//    print(bin_name);
//    print(results);
//    print(" n a m e s ------------------------");
    return Scaffold(
        appBar: new AppBar(
            elevation: 0.0,
            backgroundColor: Color(0xFFF9BE7C),
            title: Text('SmartBin',style: TextStyle(color: Color(0xFF0D253F)),),
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
//                    color: Colors.white,
                  ),
                  onPressed: () {
//                  FirebaseAuth.instance.signOut().then((value){
//                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
//                  });
                  signOut();
                    changeScreenReplacement(context, Login());
                  })
            ]),
        body: StreamBuilder(
            stream: surroundigsData,
            builder: (BuildContext context,AsyncSnapshot snapshot){
              Widget widget;
              if(snapshot.hasData){
                List<TemperatureData> temperatureData =<TemperatureData>[];
                for(int index = 0;index<snapshot.data.documents.length;index++){
                  DocumentSnapshot documentSnapshot=snapshot.data.documents[index];
//                  print(documentSnapshot.data['time'].toDate());
//                  temperatureData.add(TemperatureData.fromMap(documentSnapshot.data));
                  print(documentSnapshot.data['date'].toDate());
                  temperatureData.add(TemperatureData(documentSnapshot.data['date'].toDate(),documentSnapshot.data['percent']));
                }
//                print(temperatureData);

                widget =Container(
                  child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                          labelRotation: 90
                      ),
                      title: ChartTitle(text: bname.toString()+" bin" + " History"),
                      // Enable tooltip
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <SplineSeries<TemperatureData,dynamic>>[
                        SplineSeries<TemperatureData,dynamic>(
                            dataSource: temperatureData,
                            xValueMapper: (TemperatureData data, _)=>data.time,
                            yValueMapper: (TemperatureData data, _)=>data.temp),
                      ]
                  ),
                );
              }
              return widget;
            }
        )
    );
  }

  signOut() async {
    auth.signOut();
    await _storage.deleteAll();
    await _storage.write(key: "status", value: "Unauthenticated");
  }
}

class TemperatureData {
  final int temp;
  final DateTime time;
  TemperatureData(this.time,this.temp);
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
          color: Colors.indigo,
        ),
      ),
    ),
    decoration: new BoxDecoration(
      color: Colors.indigo,
    ),
  );
}
