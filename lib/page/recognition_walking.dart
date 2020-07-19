import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_activity_recognition/sensor/accelerometer.dart';
import 'package:flutter_activity_recognition/sensor/light.dart';
import 'package:flutter_activity_recognition/sensor/pedometer.dart';

class WalkingRecognitionPage extends StatefulWidget {
  @override
  _WalkingRecognitionPageState createState() => _WalkingRecognitionPageState();
}

class _WalkingRecognitionPageState extends State<WalkingRecognitionPage> {
  var _pedometerBloc;
  var _accelerometerBloc;
  var _lightBloc;
  static const MethodChannel _methodChannel = MethodChannel('com.example.flutter_activity_recognition');
  static const EventChannel _eventChannel = EventChannel('com.example.flutter_activity_recognition/stream');
  Stream<int> _lightSensorStream;

  @override
  void initState(){
    super.initState();
    _pedometerBloc = new PedometerBloc();
    _accelerometerBloc = new AccelerometerBloc();
    _lightBloc = new LightBloc();

    _eventChannel.receiveBroadcastStream();
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
            lightWidget2()
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

  Widget lightWidget2(){
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

  Widget lightWidget(){
    return StreamBuilder<int>(
      stream: _lightSensorStream,
      builder: (context, snapshot){
        if(snapshot.hasData){
          return Text('조도 ${snapshot.data}', style: TextStyle(fontSize: 30));
        } else {
          return Text('현재 데이터 가져올 수 없음', style: TextStyle(fontSize: 30));
        }
      }
    );
  }
}

