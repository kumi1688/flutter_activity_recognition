import 'dart:async';

import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_activity_recognition/activity/activity.dart';
import 'package:flutter_activity_recognition/page/recognition_rest.dart';
import 'package:flutter_activity_recognition/page/recognition_running.dart';
import 'package:flutter_activity_recognition/page/recognition_sleep.dart';
import 'package:flutter_activity_recognition/page/recognition_vehicle.dart';
import 'package:flutter_activity_recognition/page/recognition_walking.dart';

class DashBoardPage extends StatefulWidget {
  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  ActivityBloc _activityBloc;

  static const String WALKING = '/walking';

  _showNextPage(BuildContext context, String destination) => Navigator.pushNamed(context, destination);

  @override
  void initState(){
      super.initState();
      _activityBloc = new ActivityBloc();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      child: Scaffold(
        appBar: AppBar(
          title: activityWidget(),
          bottom: TabBar(
            
            tabs: <Widget>[
            Tab(icon: Icon(Icons.directions_walk), text: "걷기", key: Key("walk"),) ,
            Tab(icon: Icon(Icons.directions_run), text: "뛰기", key: Key("run")),
            Tab(icon: Icon(Icons.free_breakfast), text: "휴식", key: Key("rest")),
            Tab(icon: Icon(Icons.hotel), text: "수면", key: Key("sleep")),
            Tab(icon: Icon(Icons.directions_bus), text: "탈것", key: Key("vehicle"),),
          ],)),
        body: TabBarView(
              children: <Widget>[
                WalkingRecognitionPage(),
                RunningRecognitionPage(),
                RestRecognitionPage(),
                SleepRecognitionPage(),
                VehicleRecognitionPage(),
              ],),
      ),
      length: 5,
    );
  }

  Widget activityWidget(){
    return StreamBuilder(
        stream: _activityBloc.userActivityStream,
        builder: (context, snapshot){
          if(snapshot.hasData){
            Activity act = snapshot.data;
            return Text('${act.confidence}% ${act.type}', style: TextStyle(fontSize: 20));
          }
          else{
            return Text('현재 활동 감지 되지 않음', style: TextStyle(fontSize: 20));
          }
        }
    );
  }

  Activity get userActivityValue => _activityBloc.userActivityValue;
}