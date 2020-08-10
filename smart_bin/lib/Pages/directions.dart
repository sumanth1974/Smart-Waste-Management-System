import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:location/location.dart';
import 'package:smartbins/Pages/login.dart';
import 'package:smartbins/commons/common.dart';


class DirectionMaps extends StatefulWidget {
  final bin_name;
  final bin_location;
  DirectionMaps({
    this.bin_name,
    this.bin_location,
  });

  @override
  _DirectionMapsState createState() => _DirectionMapsState();
}

class _DirectionMapsState extends State<DirectionMaps> {
  final _storage = FlutterSecureStorage();
  FirebaseAuth auth = FirebaseAuth.instance;
  String _platformVersion = 'Unknown';
  Location _locationTracker = Location();
  MapboxNavigation _directions;
  bool _arrived = false;
  double _distanceRemaining, _durationRemaining;

  //name: "ifmr", latitude: 13.5481, longitude: 80.0002

  @override
  void initState() {
    super.initState();
    initPlatformState();
    setState(() {
      navigationFromLiveLoc();
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _directions = MapboxNavigation(onRouteProgress: (arrived) async {
      _distanceRemaining = await _directions.distanceRemaining;
      _durationRemaining = await _directions.durationRemaining;

      setState(() {
        _arrived = arrived;
      });
      if (arrived)
      {
        await Future.delayed(Duration(seconds: 3));
        await _directions.finishNavigation();
      }
    });

    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await _directions.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void navigationFromLiveLoc() async {
    try {
      var location = await _locationTracker.getLocation();
      final _origin = WayPoint(name: "my live location", latitude: location.latitude, longitude: location.longitude);
      final _destination = WayPoint(name: widget.bin_name.toString() + "bin", latitude: widget.bin_location.latitude, longitude: widget.bin_location.longitude);
      await _directions.startNavigation(
          origin: _origin,
          destination: _destination,
          mode: MapBoxNavigationMode.drivingWithTraffic,
          simulateRoute: false , units: VoiceUnits.metric);


    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }

  }

  @override
  Widget build(BuildContext context) {
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
//        body: Container(),
    body: Center(
          child: Column(children: <Widget>[
            SizedBox(
              height: 200,
            ),
//            Text('Routing from your live location to ${widget.bin_name.toString()} bin'),
            Center(
              child: Text(
                'Routing from your live location to ${widget.bin_name.toString()} bin',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
              ),
            ),
            SizedBox(
              height: 60,
            ),
//            SizedBox(
//              height: 60,
//            ),
          ]),
        ),
    );
//    return MaterialApp(
//      home: Scaffold(
//        appBar: AppBar(
//          title: const Text('navigation'),
//        ),
//        body: Center(
//          child: Column(children: <Widget>[
//            SizedBox(
//              height: 30,
//            ),
//            Text('Running on: $_platformVersion\n'),
//            SizedBox(
//              height: 60,
//            ),
//            RaisedButton(
//              child: Text("Start Navigation"),
//              onPressed: () async {
//                navigationFromLiveLoc();
//              },
//            ),
//            SizedBox(
//              height: 60,
//            ),
//          ]),
//        ),
//      ),
//    );
  }

  signOut() async {
    auth.signOut();
    await _storage.deleteAll();
    await _storage.write(key: "status", value: "Unauthenticated");
  }
}