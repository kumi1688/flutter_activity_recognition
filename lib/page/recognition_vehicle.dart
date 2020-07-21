import 'dart:async';

import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_activity_recognition/activity/activity.dart';
import 'package:flutter_activity_recognition/sensor/accelerometer.dart';
import 'package:flutter_activity_recognition/sensor/headphone.dart';
import 'package:flutter_activity_recognition/sensor/light.dart';
import 'package:flutter_activity_recognition/sensor/pedometer.dart';

class VehicleRecognitionPage extends StatefulWidget {
  @override
  VehicleRecognitionPageState createState() => VehicleRecognitionPageState();
}

class VehicleRecognitionPageState extends State<VehicleRecognitionPage> {
  var _pedometerBloc;
  var _accelerometerBloc;
  var _lightBloc;
  var _headphoneBloc;
  var _activityBloc;
  static const MethodChannel _methodChannel = MethodChannel('com.example.flutter_activity_recognition');
  static const EventChannel _eventChannel = EventChannel('com.example.flutter_activity_recognition/stream/light');
  Stream<int> _lightSensorStream;

  @override
  void initState(){
    super.initState();
    _pedometerBloc = new PedometerBloc();
    _accelerometerBloc = new AccelerometerBloc();
    _lightBloc = new LightBloc();
    _headphoneBloc = new HeadphoneBloc();
    _activityBloc = new ActivityBloc();
    _lightSensorStream = _eventChannel.receiveBroadcastStream().map((lux) => lux);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('걷기 측정하기')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              pedometerWidget(),
              buildWidget('accelerometer'),
              buildWidget('userAccelerometer'),
              buildWidget('gyroscope'),
              lightWidget(),
              activityWidget(),
            ],
          ),
        )
    );
  }

  Widget buildWidget(String type){
    var stream;
    String text;

    switch(type){
      case 'accelerometer':
        stream = _accelerometerBloc.accelerometerValue;
        text= '가속도';
        break;
      case 'gyroscope':
        stream = _accelerometerBloc.gyroscopeValue;
        text='자이로스코프';
        break;
      case 'userAccelerometer':
        stream = _accelerometerBloc.userAccelerometerValue;
        text='가속도(중력x)';
        break;
    }

    return StreamBuilder<List<String>>(
        stream: stream,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Text('${text}: ${snapshot.data}', style: TextStyle(fontSize: 20));
          } else {
            return Text('현재 데이터 가져올 수 없음', style: TextStyle(fontSize: 20));
          }
        }
    );
  }

  Widget pedometerWidget(){
    return StreamBuilder<int>(
        stream: _pedometerBloc.pedometer,
        initialData: 0,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Text('걸음수: ${snapshot.data - _pedometerBloc.pedometerInitialValue}', style: TextStyle(fontSize: 20));
          } else {
            return Text('현재 데이터 가져올 수 없음', style: TextStyle(fontSize: 20));
          }
        }
    );
  }

  Widget lightWidget(){
    return StreamBuilder<int>(
      stream: _lightBloc.light,
      builder: (context, snapshot){
        if(snapshot.hasData){
          return Text('조도: ${snapshot.data}', style: TextStyle(fontSize: 20));
        } else {
          return Text('현재 데이터 가져올 수 없음', style: TextStyle(fontSize: 20));
        }
      },
    );
  }

  Widget activityWidget(){
    return StreamBuilder(
        stream: ActivityRecognition.activityUpdates(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            Activity act = snapshot.data;
            print(act);
            return Text('${act.confidence} ${act.type}', style: TextStyle(fontSize: 20));
          }
          else{
            return Text('현재 활동 감지 되지 않음', style: TextStyle(fontSize: 20));
          }
        }
    );
  }
}