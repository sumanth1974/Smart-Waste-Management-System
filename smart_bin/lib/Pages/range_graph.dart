import 'dart:math';
//import 'package:chartstrail/graph.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:flutter_examples/model/model.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:smartbins/Pages/login.dart';
import 'package:smartbins/commons/common.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide LabelPlacement;
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
//import 'package:chartstrail/Range/page_co2.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:flutter/material.dart';
import 'dart:math';
//import 'package:chartstrail/graph.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RangeGraph extends StatefulWidget {
  final bin_id;
  final bname;
  RangeGraph({
    this.bin_id,
    this.bname,
  });
  @override
  _RangeGraphState createState() => _RangeGraphState();
}

class _RangeGraphState extends State<RangeGraph> {
  final DateTime min = DateTime(2020, 02, 01), max = DateTime(2020, 07, 15);
  RangeController rangeController;
  SfCartesianChart splineAreaChart, splineChart;
  List<Data> data =<Data>[];
  final _storage = FlutterSecureStorage();
  FirebaseAuth auth = FirebaseAuth.instance;
  void initState() {
    super.initState();
//    setState(() {
//      get_data();
//    });
//    print("--------------------------DATA-------------------------");
//    print(data);
//    print("----------------------------------------------------------------------");
    rangeController = RangeController(
      start: DateTime(2020,06, 01),
      end: DateTime(2020, 07, 01),
    );

  }
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> informationData =Firestore.instance.collection('bins').document(widget.bin_id).collection('bin_log').snapshots();

    final ThemeData themeData = Theme.of(context);
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

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
    body: new SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new SizedBox(height: 20,),
              DelayedDisplay(
                delay: Duration(seconds: 2),
                child: StreamBuilder(
                  stream: informationData,
                  builder: (BuildContext context,AsyncSnapshot snapshot){
                    Widget widget1;
                    if(snapshot.hasData){
                      List<Data> data=<Data>[];
                      for(int index=0;index<snapshot.data.documents.length;index++){
                        DocumentSnapshot documentSnapshot=snapshot.data.documents[index];
//                      print("----------------------------------------------------------------------");
//                      print(documentSnapshot.data['date'].toDate());
                        //if(documentSnapshot.data['date'].toDate()){
                        if (DateTime.parse(documentSnapshot.data['date'].toDate().toString()).hour==23) {
                          data.add(Data(documentSnapshot.data['date'].toDate(),
                              double.parse(documentSnapshot.data['day_waste'].toString())));
                          //}
                        }
                      }
                      splineChart = SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        title: ChartTitle(text: widget.bname.toString().toUpperCase()+" bin" + " history"),
                        tooltipBehavior: TooltipBehavior(
                            enable: true
                        ),
                        primaryXAxis: DateTimeAxis(
                            isVisible: true,
                            minimum: min,
                            maximum: max,
                            rangeController: rangeController),
                        primaryYAxis: NumericAxis(
                          labelPosition: ChartDataLabelPosition.inside,
                          labelAlignment: LabelAlignment.end,
                          majorTickLines: MajorTickLines(size: 0),
                          axisLine: AxisLine(color: Colors.transparent),
                        ),
                        series: <SplineSeries<Data, DateTime>>[
                          SplineSeries<Data, DateTime>(
                            enableTooltip: true,
                            animationDuration: 1000,
                            legendIconType: LegendIconType.circle,
                            dataSource: data,
//                          enableTooltip: true,
                            xValueMapper: (Data sales, _) => sales.time,
                            yValueMapper: (Data sales, _) => sales.percent,
//                            markerSettings: MarkerSettings(
//                                isVisible: true
//                            ),
//                            dataLabelSettings: DataLabelSettings(
//                              // Renders the data label
//                                isVisible: true
//                            )
                            name: 'Collected Waste',
//                          isVisibleInLegend: true,
//                          dataLabelSettings: DataLabelSettings(
//                              isVisible: false,
//                              useSeriesColor: true,
//                              labelAlignment: ChartDataLabelAlignment.top),

                          )
                        ],
                      );
                      splineAreaChart = SfCartesianChart(
                        tooltipBehavior: TooltipBehavior(
                          enable: true,shadowColor: Colors.transparent,
                        ),
                        margin: const EdgeInsets.all(0),
                        primaryXAxis: DateTimeAxis(isVisible: false, maximum: max),
                        primaryYAxis: NumericAxis(isVisible: false),
                        plotAreaBorderWidth: 0,
                        series: <SplineAreaSeries<Data, DateTime>>[
                          SplineAreaSeries<Data, DateTime>(
                            enableTooltip: true,
                            borderColor: const Color.fromRGBO(0, 193, 187, 1),
                            color: const Color.fromRGBO(163, 226, 224, 1),
                            borderDrawMode: BorderDrawMode.excludeBottom,
                            borderWidth: 1,
//                          animationDuration: 1000,
//                          legendIconType: LegendIconType.circle,
                            dataSource: data,
                            xValueMapper: (Data sales, _) => sales.time,
                            yValueMapper: (Data sales, _) => sales.percent,
//                            markerSettings: MarkerSettings(
//                                isVisible: true
//                            ),
                            name: 'Bin status',
//                          isVisibleInLegend: true,
//                          dataLabelSettings: DataLabelSettings(
//                            isVisible: false,
//                            useSeriesColor: true,
//                            labelAlignment: ChartDataLabelAlignment.top),
                          )
                        ],
                      );
                      widget1 = Center(
                        child: Container(
                            height: 500,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(0),
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                        padding: const EdgeInsets.fromLTRB(5, 20, 15, 25),
                                        child: splineChart
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(0),
                                    padding: const EdgeInsets.all(0),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(14, 0, 15, 15),
                                        child: SfRangeSelectorTheme(
                                          data: SfRangeSelectorThemeData(
                                            thumbColor: Colors.white,
                                            thumbStrokeColor:Colors.purpleAccent,
                                            thumbStrokeWidth: 2,
                                          ),
                                          child: SfRangeSelector(
                                            min: min,
                                            max: max,
                                            interval: 1,
                                            enableDeferredUpdate: true,
                                            deferredUpdateDelay: 500,
                                            labelPlacement: LabelPlacement.betweenTicks,
                                            dateIntervalType: DateIntervalType.months,
                                            controller: rangeController,
                                            showTicks: true,
                                            showLabels: true,
                                            dragMode: SliderDragMode.both,
                                            labelFormatterCallback:
                                                (dynamic actualLabel, String formattedText) {
                                              String label = DateFormat.MMM().format(actualLabel);
                                              label = label;
                                              return label;
                                            },
                                            onChanged: (SfRangeValues values) {},
                                            child: Container(
                                              child: splineAreaChart,
                                              height: 75,
                                              padding: const EdgeInsets.all(0),
                                              margin: const EdgeInsets.all(0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ),
                      );
                    }
                    return widget1;
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
//  get_data() async{
//
//    await Firestore.instance.collection('bins').document('bin1').collection('bin_log').getDocuments().then((querySnapshot) {
//      querySnapshot.documents.forEach((result) {
////        print("HELLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL");
////        print(result.data['date']);
////        print(result.data['percent']);
//        data.add(Data(result.data['date'].toDate(),result.data['percent'] ));
//
//      });});
//  }
  signOut() async {
    auth.signOut();
    await _storage.deleteAll();
    await _storage.write(key: "status", value: "Unauthenticated");
  }
}
class Data{
  final double percent;
  final DateTime time;
  Data(this.time,this.percent);
}
