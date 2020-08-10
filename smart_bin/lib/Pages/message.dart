import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


class MensajeToken extends StatefulWidget {
  @override
  _MensajeTokenState createState() => _MensajeTokenState();
}
class _MensajeTokenState extends State<MensajeToken> {

  String _homeScreenText = "Waiting for token...";
  String _messageText = "Waiting for message...";

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print("onResume: $message");
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "Mi token es: $token";//envia el token a la pantalla
      });
      print(_homeScreenText);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Material(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: Text(_homeScreenText),
                ),
              ),
              Row(children: <Widget>[
                Expanded(
                  child: Text(_messageText),
                ),
              ])
            ],
          ),
        ));
  }
}
void main() {
  runApp(
    MaterialApp(
      home: MensajeToken(),
    ),
  );
}