import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:smartbins/Pages/account.dart';
import 'package:smartbins/Pages/drivers.dart';
import 'package:smartbins/Pages/home.dart';
import 'package:smartbins/Pages/login.dart';
import 'package:smartbins/commons/common.dart';
import 'package:smartbins/provider/user_provider.dart';

String uid;

class Gmap extends StatefulWidget {
  @override
  _GmapState createState() => _GmapState();
}

class _GmapState extends State<Gmap> {
  final _storage = FlutterSecureStorage();
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleMapController _controller;
  List<Marker> allMarkers = [];
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_uid().then((id) {
      setState(() {});
    });
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("images/pin.png");
    return byteData.buffer.asUint8List();
  }

  void updateLiveMarker(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("me"),
          position: latlng,
          rotation: newLocalData.latitude,
          draggable: false,
          flat: true,
          anchor: Offset(0.5, 1),
          icon: BitmapDescriptor.fromBytes(imageData));
      allMarkers.add(marker);
    });
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateLiveMarker(location, imageData);
      if (_controller != null) {
        _controller.animateCamera(CameraUpdate.newCameraPosition(
            new CameraPosition(
                bearing: 0.0,
                target: LatLng(location.latitude, location.longitude),
                tilt: 0,
                zoom: 13.5)));
        updateLiveMarker(location, imageData);
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  void reDisplay() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
        bearing: 0.0,
        target: LatLng(13.531291, 80.024774),
        tilt: 0,
        zoom: 12.5)));
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }
  Widget loadMarkers() {
    return StreamBuilder(
      stream: Firestore.instance.collection('bins').snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text('loading maps......');
        for (int i = 0; i < snapshot.data.documents.length; i++) {
  if (snapshot.data.documents[i]['status']=="Full"){
  allMarkers.add(new Marker(
  markerId: MarkerId(snapshot.data.documents[i]['name']),
  draggable: false,
  infoWindow: InfoWindow(
  title: snapshot.data.documents[i]['name'],
  snippet: snapshot.data.documents[i]['status']),
    icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed),
  position: new LatLng(
  snapshot.data.documents[i]['location'].latitude,
  snapshot.data.documents[i]['location'].longitude),
  ));
  }
  else{
  allMarkers.add(new Marker(
  markerId: MarkerId(snapshot.data.documents[i]['name']),
  draggable: false,
  infoWindow: InfoWindow(
  title: snapshot.data.documents[i]['name'],
  snippet: snapshot.data.documents[i]['status']),
    icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueGreen),
  position: new LatLng(
  snapshot.data.documents[i]['location'].latitude,
  snapshot.data.documents[i]['location'].longitude),
  ));

  }
  }
        return new GoogleMap(
          initialCameraPosition:
              CameraPosition(target: LatLng(13.531291, 80.024774), zoom: 11.0),
          markers: Set.from(allMarkers),
          onMapCreated: mapCreated,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //AppProvider appProvider = Provider.of<AppProvider>(context);
    final user = UserProvider();
    print("===================== P R I N T I N G ===============");
    print(uid);
    return Scaffold(
      appBar: new AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xFFF9BE7C),
          title: Text('SmartBin',style: TextStyle(color:Color(0xFF0D253F)),),
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
      body: Stack(
        children: [
          loadMarkers(),
          Positioned(
            bottom: 25,
            left: 8,
            child: FlatButton(
                child: Icon(Icons.replay, color: Colors.white),
                color: Colors.orange,
                onPressed: () {
                  reDisplay();
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.location_searching),
          backgroundColor: Colors.orange,
          onPressed: () {
            getCurrentLocation();
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
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
