import 'dart:async';

import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_activity_recognition/activity/activity.dart';
import 'package:flutter_activity_recognition/sensor/accelerometer.dart';
import 'package:flutter_activity_recognition/sensor/headphone.dart';
import 'package:flutter_activity_recognition/sensor/light.dart';
import 'package:flutter_activity_recognition/sensor/pedometer.dart';

class RestRecognitionPage extends StatefulWidget {
  @override
  RestRecognitionPageState createState() => RestRecognitionPageState();
}

class RestRecognitionPageState extends State<RestRecognitionPage> {
  var _pedometerBloc;
  var _accelerometerBloc;


  static const MethodChannel _methodChannel = MethodChannel('com.example.flutter_activity_recognition');
  static const EventChannel _eventChannel = EventChannel('com.example.flutter_activity_recognition/stream/light');
  Stream<int> _lightSensorStream;

  @override
  void initState(){
    super.initState();
    _pedometerBloc = new PedometerBloc();
    _accelerometerBloc = new AccelerometerBloc();

  }

  @override
  void dispose(){
    print('메인 해체');
    _pedometerBloc.dispose();
    _accelerometerBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          pedometerWidget(),
          buildWidget('accelerometer'),
          buildWidget('userAccelerometer'),
          buildWidget('gyroscope'),
        ],
      ),
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
}