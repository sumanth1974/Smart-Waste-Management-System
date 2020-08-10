import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smartbins/Pages/account.dart';
import 'package:smartbins/Pages/bins_page.dart';
import 'package:smartbins/Pages/drivers.dart';
import 'package:smartbins/Pages/graphs.dart';
import 'package:smartbins/Pages/maps.dart';
import 'package:smartbins/Pages/predictions.dart';
import 'package:smartbins/commons/common.dart';
import 'package:smartbins/commons/percentage_card_widget.dart';
import 'package:smartbins/commons/topcontainer.dart';

//My own imports
import 'package:smartbins/provider/user_provider.dart';

import 'login.dart';

String uid;
String user_name;
String user_email;
//var bin_name = [];
//var bin_details = {};
//var results={};
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _storage = FlutterSecureStorage();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_uid().then((id) {
      setState(() {});
    });
//    get_bin_names().then((id) {
//      setState(() {});
//    });
////    get_bin_details().then((id) {
////      setState(() {});
////    });
  }

  @override
  Widget build(BuildContext context) {
    final user = UserProvider();
//    print("===================== P R I N T I N G ===============");
//    print(uid);
//    get_bin_names();
//    get_bin_details();
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
      appBar: new AppBar(elevation: 0.0, backgroundColor: Color(0xFFF9BE7C),
//          title: Text('SmartBin'),
          iconTheme: new IconThemeData(color: Color(0xFF0D253F)),
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
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            // heafer
//            StreamBuilder<QuerySnapshot>(
//              stream: Firestore.instance
//                  .collection('users')
//                  .where('userId', isEqualTo: uid)
//                  .snapshots(),
//              builder: (context, snapshot) {
//                print(snapshot.data.documents[0]);
//                return _buildList3(context, snapshot.data.documents[0]);
//              },
//            ),
            UserAccountsDrawerHeader(
              accountName: Text(user_name.toString()),
              accountEmail: Text(user_email.toString()),
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
            ),

            //body
            InkWell(
              onTap: () {
                changeScreenReplacement(context, HomePage());
              },
              child: ListTile(
                title: Text(
                  'Home Page',
                ),
                leading: Icon(
                  Icons.home,
                  color: Colors.red,
                ),
              ),
            ),

            InkWell(
              onTap: () {
                changeScreen(context, Account());
              },
              child: ListTile(
                title: Text(
                  'My Account',
                ),
                leading: Icon(
                  Icons.person,
                  color: Colors.red,
                ),
              ),
            ),

            InkWell(
              onTap: () {
                changeScreen(context, Driver());
              },
              child: ListTile(
                title: Text(
                  'Drivers',
                ),
                leading: Icon(
                  Icons.details,
                  color: Colors.red,
                ),
              ),
            ),

            InkWell(
              onTap: () {
                changeScreen(context, Gmap());
              },
              child: ListTile(
                title: Text(
                  'Maps',
                ),
                leading: Icon(
                  Icons.map,
                  color: Colors.red,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                changeScreen(context, Forecast());
              },
              child: ListTile(
                title: Text(
                  'Future Wastage',
                ),
                leading: Icon(
                  Icons.forward,
                  color: Colors.red,
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                signOut();
                changeScreenReplacement(context, Login());
              },
              child: ListTile(
                title: Text('Log out'),
                leading: Icon(
                  Icons.transit_enterexit,
                  color: Colors.grey,
                ),
              ),
            ),

            InkWell(
              onTap: () {
                //changeScreenReplacement(context, DetailsUpload());
              },
              child: ListTile(
                title: Text('About'),
                leading: Icon(Icons.help),
              ),
            ),
          ],
        ),
      ),

      //body: new ListView(
      body: buildhomepage(context),
          //Padding widget

          //Horizontal list view begins here
          //HorizontalList(),

//          RaisedButton(
//            child: Text('View Record'),
//            onPressed: () {
//              getData();
//            },
//          ),

//          new Padding(padding: const EdgeInsets.all(20.0),
//            child:new Text('Recent Products'),),

//          Flexible(
//            child: new StreamBuilder(
//                stream:
//                    Firestore.instance.collection('bin_details').snapshots(),
//                builder: (context, snapshot) {
//                  if (!snapshot.hasData) return const Text('Loading...');
//                  return new GridView.builder(
//                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
//                        crossAxisCount: 2),
//                    itemCount: snapshot.data.documents.length,
//                    padding: const EdgeInsets.all(4.0),
//                    itemBuilder: (context, index) => _buildListItem1(
//                        context, snapshot.data.documents[index]),
//                  );
//                }),
//          ),
          //Grid View
//          Flexible(child: Products()),
//          Container(
//            height: 320.0,
//            child: Products(),
//          )

    );
  }

//  get_bin_names() async{
//    await Firestore.instance.collection("bins").getDocuments().then((querySnapshot) {
//      querySnapshot.documents.forEach((result) {
////        print(result.data);
//        if (bin_name.contains(result.data['name']) == false) {
//          bin_name.add(result.data['name']);
//          bin_details[result.data['name']]=[result.data['location'],result.data['percent'],result.data['status'],result.documentID];
//        }
//        print(bin_details);
//      });
//    });
//  }

  get_uid() async {
    final current_user = await _storage.readAll();
    uid = current_user["uid"];
//    print(
//        "1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111");
//    print(uid);
    Firestore.instance
        .collection('users')
        .where('userId', isEqualTo: uid)
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
//        print(result.data);
        user_name = result.data["name"];
        user_email = result.data["email"];
//        print("222222222222222222222222222222222222222");
      });
    });
  }

  signOut() async {
    auth.signOut();
    await _storage.deleteAll();
    await _storage.write(key: "status", value: "Unauthenticated");
  }
}

buildhomepage(BuildContext context){
//  List<ActiveProjectsCard> containers = new List<ActiveProjectsCard>();
//  for (var i=0;i<bin_name.length;i++) {
////    print(bin_name[i]);
//    var location=bin_details[bin_name[i]][0];
//    containers.add(
//      ActiveProjectsCard(
//        cardColor: Colors.red,
//        loadingPercent: double.parse(bin_details[bin_name[i]][1].toString())/100,
//        title: bin_name[i].toString().toUpperCase()+' Bin',
//        subtitle: "Lat: "+ location.latitude.toString() + ", Long: " +location.longitude.toString(),
//        id:bin_details[bin_name[i]][3],
//        name: bin_name[i],
//        status:bin_details[bin_name[i]][2],
//        position: bin_details[bin_name[i]][0],
//      ),
//    );
//  }
  return ListView(
    children: <Widget>[
      TopContainer(
        height: 120,
//            height: 44.5*SizeConfig.widthMultiplier,
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
                    CircleAvatar(
                      backgroundColor: Colors.blue,
//                          radius: 14*SizeConfig.widthMultiplier,
                      radius: 40,
                      backgroundImage: AssetImage(
                        "images/accnt1.png",
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
//                                  Container(
                        Text(
                          user_name.toString(),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 25,
                            color: Color(0xFF0D253F),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
//                                  ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.email,
//                                    color: Colors.green,
//                                    size: 30.0,
                            ),
                            Text(
                              user_email.toString(),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ]),
      ),
      Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Categories",
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
      Container(
//        height: 90 * SizeConfig.widthMultiplier,
        height: 400,
        child: Column(
          children: <Widget>[
        Row(
        children: <Widget>[
        InkWell(
        child: Container(
//                    height: 44.5*SizeConfig.widthMultiplier,
        height: 180,
          width: MediaQuery.of(context).size.width/2,
          child: Card(
            color: Colors.blue,
            margin: EdgeInsets.all(
               5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(
                    10))),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset("images/bin1.jpg",width: 40,),
                  Padding(
                    padding: EdgeInsets.only(
                    top: 10,
                      bottom: 5,
                    ),
                  ),
                  Text('Available'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                  ),
                  Text(
                    'Bins'.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onTap: () {
changeScreen(context, AvailableBins());
        },
      ),
          InkWell(
            child: Container(
//                    height: 44.5*SizeConfig.widthMultiplier,
              height: 180,
              width: MediaQuery.of(context).size.width/2,
              child: Card(
                color: Colors.redAccent,
                margin: EdgeInsets.all(
                    5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(
                        10))),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("images/driver1.png",width: 40,),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 5,
                        ),
                      ),
                      Text('Driver'.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Details'.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            onTap: () {
              changeScreen(context, Driver());
            },
          ),
],
        ),
            Row(
              children: <Widget>[
                InkWell(
                  child: Container(
//                    height: 44.5*SizeConfig.widthMultiplier,
                    height: 180,
                    width: MediaQuery.of(context).size.width/2,
                    child: Card(
                      color: Colors.green,
                      margin: EdgeInsets.all(
                          5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(
                              10))),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset("images/maps.png",width: 40,),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 10,
                                bottom: 5,
                              ),
                            ),
                            Text('Check bins'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'on maps'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    changeScreen(context, Gmap());
                  },
                ),
                InkWell(
                  child: Container(
//                    height: 44.5*SizeConfig.widthMultiplier,
                    height: 180,
                    width: MediaQuery.of(context).size.width/2,
                    child: Card(
                      color: Colors.orange,
                      margin: EdgeInsets.all(
                          5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(
                              10))),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset("images/accnt1.png",width: 40,),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 10,
                                bottom: 5,
                              ),
                            ),
                            Text('Account'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Details'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    changeScreen(context, Account());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
//      Text(
//        "Smart Bin Status",
//        style: TextStyle(
//            color: Color(0xFF0D253F),
//            fontSize: 20.0,
//            fontWeight: FontWeight.w700,
//            letterSpacing: 1.2),
////      ),
//      ...containers,
    ],
  );
}
//_buildListItem1(context, document) {
//  return Card(
//    child: Hero(
//      tag: Text(document['binstatus'].toString()),
//      child: Material(
//        child: GridTile(
//          child: Column(
//            children: <Widget>[
//              Image.asset(
//                "images/bin.png",
//                width: 100.0,
//                height: 80.0,
//              ),
//              Padding(
//                padding: const EdgeInsets.only(top: 8.0),
//                child: RichText(
//                  text: TextSpan(
//                    text: document['name'].toString(),
//                    style: TextStyle(
//                      fontWeight: FontWeight.bold,
//                      color: Colors.black,
//                    ),
//                    children: <TextSpan>[
//                      TextSpan(
//                          text: ' bin ',
//                          style: TextStyle(
//                              fontWeight: FontWeight.bold,
//                              color: Colors.black)),
//                    ],
//                  ),
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.only(top: 8.0),
//                child: RichText(
//                  text: TextSpan(
//                    text: 'Bin Status :  ',
//                    style: DefaultTextStyle.of(context).style,
//                    children: <TextSpan>[
//                      TextSpan(
//                          text: document['binstatus'].toString(),
//                          style: TextStyle(
//                              fontWeight: FontWeight.bold, color: Colors.red)),
//                    ],
//                  ),
//                ),
//              ),
//              RichText(
//                text: TextSpan(
//                  text: 'Lat : ',
//                  style: DefaultTextStyle.of(context).style,
//                  children: <TextSpan>[
//                    TextSpan(
//                        text: document['location'].latitude.toString() + ' N',
//                        style: TextStyle(
//                            fontWeight: FontWeight.bold, color: Colors.red)),
//                  ],
//                ),
//              ),
//              RichText(
//                text: TextSpan(
//                  text: 'Long : ',
//                  style: DefaultTextStyle.of(context).style,
//                  children: <TextSpan>[
//                    TextSpan(
//                        text: document['location'].longitude.toString() + ' E',
//                        style: TextStyle(
//                            fontWeight: FontWeight.bold, color: Colors.red)),
//                  ],
//                ),
//              )
//            ],
//          ),
//        ),
//      ),
//    ),
//  );
//}

// Ctrl + Alt + Shift + L = Reformat file
//_buildList3(context, document) {
//  return UserAccountsDrawerHeader(
//    accountName: Text(document["name"].toString()),
//    accountEmail: Text(document["email"].toString()),
//    currentAccountPicture: GestureDetector(
//      child: new CircleAvatar(
//        backgroundColor: Colors.white,
//        child: Icon(
//          Icons.person,
//          color: Colors.orange,
//        ),
//      ),
//    ),
//    decoration: new BoxDecoration(
//      color: Colors.orange,
//    ),
//  );
//}
