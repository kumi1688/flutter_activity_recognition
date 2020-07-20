import 'package:flutter/material.dart';
import 'package:flutter_activity_recognition/page/recognition_running.dart';
import 'package:flutter_activity_recognition/page/recognition_walking.dart';

class DashBoardPage extends StatefulWidget {
  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  static const String WALKING = '/walking';

  _showNextPage(BuildContext context, String destination) => Navigator.pushNamed(context, destination);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      child: Scaffold(
        appBar: AppBar(
          title: Text('상태 측정하기'),
          bottom: TabBar(tabs: <Widget>[
            Tab(icon: Icon(Icons.directions_walk), text: "걷기", key: Key("walk"),),
            Tab(icon: Icon(Icons.directions_run), text: "뛰기", key: Key("run")),
            Tab(icon: Icon(Icons.free_breakfast), text: "휴식", key: Key("rest")),
            Tab(icon: Icon(Icons.hotel), text: "수면", key: Key("sleep")),
            Tab(icon: Icon(Icons.directions_bus), text: "탈것", key: Key("vehicle"),),
          ],)),
        body: TabBarView(
              children: <Widget>[
                WalkingRecognitionPage(),
                RunningRecognitionPage(),
                RaisedButton(onPressed: ()=>_showNextPage(context, WALKING), child: Text('걷기 상태 측정하기')),
                RaisedButton(onPressed: ()=>_showNextPage(context, WALKING), child: Text('걷기 상태 측정하기')),
                RaisedButton(onPressed: ()=>_showNextPage(context, WALKING), child: Text('걷기 상태 측정하기')),
              ],),


      ),
      length: 5,
    );
  }



}
