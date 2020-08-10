//import 'package:flutter/material.dart';
//
//class Cart extends StatefulWidget {
//  @override
//  _CartState createState() => _CartState();
//}
//
//class _CartState extends State<Cart> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: new AppBar(
//          elevation: 0.0,
//          backgroundColor: Colors.red,
//          title: Text('Your Cart'),
//          actions: <Widget>[
//            new IconButton(
//                icon: Icon(
//                  Icons.search,
//                  color: Colors.white,
//                ),
//                onPressed: () {}),
//            new IconButton(
//                icon: Icon(
//                  Icons.shopping_cart,
//                  color: Colors.white,
//                ),
//                onPressed: () {})
//          ]),
//      bottomNavigationBar: new Container(
//        color: Colors.white,
//        child: Row(
//          children: <Widget>[
//            Expanded(child : ListTile(
//              title : new Text("Total:"),
//              subtitle: new Text("\$230"),
//            ),),
//            Expanded(
//              child: new MaterialButton(onPressed: (){},
//                  child: new Text("Check out",style:TextStyle(color:Colors.white),),
//              color:Colors.red,)
//            )
//          ],
//        )
//      ),
//    );
//  }
//}
