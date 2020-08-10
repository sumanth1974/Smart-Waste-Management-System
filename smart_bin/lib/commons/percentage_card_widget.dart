import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:smartbins/Pages/bin_details.dart';
import 'package:smartbins/Pages/graphs.dart';
import 'package:smartbins/commons/common.dart';

class ActiveProjectsCard extends StatelessWidget {
  final Color cardColor;
  final double loadingPercent;
  final String title;
  final String subtitle;
  final id;
  final name;
  final position;
  final status;
  ActiveProjectsCard({
    this.cardColor,
    this.loadingPercent,
    this.title,
    this.subtitle,
    this.id,
    this.name,
    this.position,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 200,
        child: Card(
          color: Colors.redAccent,
          margin: EdgeInsets.all(
              10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(
                  10))),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircularPercentIndicator(
                    animation: true,
                    radius: 75.0,
                    percent: loadingPercent,
                    lineWidth: 5.0,
                    circularStrokeCap: CircularStrokeCap.round,
                    backgroundColor: Colors.white10,
                    progressColor: Colors.white,
                    center: Text(
                      '${(loadingPercent*100)}%',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10,
                    bottom: 5,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white54,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: (){
          changeScreen(context, BinDetails(bin_id: id,bin_name: name,position: position,bin_status: status,));
      },
    );
  }
}
