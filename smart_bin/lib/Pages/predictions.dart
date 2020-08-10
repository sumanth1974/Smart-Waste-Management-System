import 'package:dropdown_formfield/dropdown_formfield.dart';
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
String prediction_result;
var waste_result;

class Forecast extends StatefulWidget {
  @override
  _ForecastState createState() => _ForecastState();
}

class _ForecastState extends State<Forecast> {
  final _storage = FlutterSecureStorage();
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  String _day;
  int _housestype;
  int _yeartype;
  int _daytype;
  TextEditingController _houses = TextEditingController();
//  TextEditingController _day = TextEditingController();
  TextEditingController _year = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _day='';
    get_uid().then((id) {
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
//    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Color(0xFFFFF9EC),
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xFFF9BE7C),
          title: Center(child: Text("Smart Bin",style: TextStyle(color:Color(0xFF0D253F)))),
          iconTheme: new IconThemeData(color: Color(0xFF0D253F)),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color:Color(0xFF0D253F) ),
//              onPressed: () => changeScreenReplacement(context, HomePage())),
              onPressed: () =>Navigator.of(context).pop()),
          actions: <Widget>[
            new IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Color(0xFF0D253F),
                ),
                onPressed: () {
//                  userid = " ";
                  signOut();
                  changeScreenReplacement(context, Login());
                })
          ]),
//      body: _buildListViewOfDevices(context),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Future Waste Prediction",
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
            Form(
              key: _formKey,
              child: ListView(children: <Widget>[
                SizedBox(
                  height: 40,
                ),
//                Padding(
//                  padding: const EdgeInsets.all(10.0),
//                  child: Container(
//                      alignment: Alignment.topCenter,
//                      child: Image.asset(
//                        "images/Forecasting.png",
//                        width:200,
//                      )),
//                ),

                Padding(
                  padding:
                  const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey.withOpacity(0.2),
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: TextFormField(
                        controller: _houses,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Number of houses",
                          icon: Icon(Icons.home),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "This field cannot be empty";
                          } else if (int.parse(value.toString())<0)
                            return "This field cannot be negative";
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey.withOpacity(0.2),
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: DropDownFormField(
                        titleText: 'Day Type',
                        hintText: 'Please choose one',
                        value: _day,
                        onSaved: (value) {
                          setState(() {
                            _day = value;
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            _day = value;
                          });
                        },
                        dataSource: [
                          {
                            "display": "WeekDay",
                            "value": "1",
                          },
                          {
                            "display": "Weekend",
                            "value": "2",
                          },
                        ],
                        textField: 'display',
                        valueField: 'value',
                      ),
                    ),),),
                Padding(
                  padding:
                  const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey.withOpacity(0.2),
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: TextFormField(
                        controller: _year,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter year after 2000",
                          icon: Icon(Icons.date_range),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "This field cannot be empty";
                          } else if(int.parse(value.toString())<2000){
                            return "The year should be greater than 2000";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),child: Material(
                  child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.red[700],
                      elevation: 0.0,
                      child: MaterialButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
//                          if (int.parse(_houses.text)<1000){_housestype=int.parse(_houses.text)+1000;}
                          _housestype=int.parse(_houses.text.toString());
                            _daytype=int.parse(_day);
                          _yeartype=int.parse(_year.text);
                          Firestore.instance.collection('trigger_new').document('prediction').updateData({"day":_daytype,"houses":_housestype,"year":_yeartype});

//                          Future.delayed(const Duration(seconds: 10));
//                          print(DateTime.now());
                            Future.delayed(Duration(seconds: 3), () {
//                              Firestore.instance
//                                  .collection('results')
//                                  .getDocuments()
//                                  .then((querySnapshot) {
//                                querySnapshot.documents.forEach((result) {
//                                  setState(() {
//                                    prediction_result=result.data['predicted'];
//                                  });
//                                  print(prediction_result);
//
//                                });
//                              });
//                              var userQuery = Firestore.instance.collection('results').where('model', isEqualTo: 'LinReg').limit(1);
//                              userQuery.getDocuments().then((data){
//                              if (data.documents.length > 0) {
//                                setState(() {
//                                  prediction_result=data.documents[0].data['predicted'];
//                                  print("=========================");
//                                  print(prediction_result);
////                                  firstName =
////                                  data.documents[0].data['firstName'];
////                                  lastName = data.documents[0].data['lastName'];
//                                });
//                              }
//                              });
                              Firestore.instance.collection('results_new').document('pred_results').get().then<dynamic>((DocumentSnapshot snapshot){
                                prediction_result=snapshot.data['predicted'].toString();
                                print(prediction_result);
                                waste_result=prediction_result.substring(1,prediction_result.length-1);
                                waste_result=double.parse(waste_result.toString());

//                                print(waste_result);
                              });
    Future.delayed(Duration(seconds: 1), ()
                              {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Prediction Results'),
                                      content: new Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: <Widget>[
                                          Text(
                                              "Predicted amount of Waste for the given inputs is " +
                                                  waste_result.toStringAsFixed(4).toString()+" kgs \n"),
                                          Text(
                                              "Predicted amount of Electricity generated from waste for the given inputs is " +
                                                  (waste_result*550).toStringAsFixed(4).toString()+" Wh"),

                                        ],
                                      ),
                                      actions: <Widget>[
                                        new FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          textColor: Theme
                                              .of(context)
                                              .primaryColor,
                                          child: const Text('Okay, got it!'),
                                        ),
                                      ],
                                    );
                                  },);
                              },);
                            });

                          }

                        },
                        minWidth: MediaQuery.of(context).size.width,
                        child: Text(
                          "Get Results",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),

                        ),
                      )),
                )),
              ]),
            ),
          ],
        ),
      ),
    );
  }
  get_uid() async {
    final current_user = await _storage.readAll();
    uid = current_user["uid"];
    Firestore.instance.collection('trigger_new').document('prediction').updateData({"day":1,"houses":6000,"year":2021});
  }

  signOut() async {
    auth.signOut();
    await _storage.deleteAll();
    await _storage.write(key: "status", value: "Unauthenticated");
  }
}

