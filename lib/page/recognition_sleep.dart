import 'dart:async';

import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_activity_recognition/activity/activity.dart';
import 'package:flutter_activity_recognition/sensor/accelerometer.dart';
import 'package:flutter_activity_recognition/sensor/battery.dart';
import 'package:flutter_activity_recognition/sensor/headphone.dart';
import 'package:flutter_activity_recognition/sensor/light.dart';
import 'package:flutter_activity_recognition/sensor/network.dart';
import 'package:flutter_activity_recognition/sensor/pedometer.dart';
import 'package:flutter_activity_recognition/sensor/temperature.dart';

class SleepRecognitionPage extends StatefulWidget {
  @override
  SleepRecognitionPageState createState() => SleepRecognitionPageState();
}

class SleepRecognitionPageState extends State<SleepRecognitionPage> {
  var _pedometerBloc;
  var _accelerometerBloc;
  var _lightBloc;
  var _batteryBloc;
  var _temperatureBloc;
  var _networkBloc;

  static const MethodChannel _methodChannel = MethodChannel('com.example.flutter_activity_recognition');
  static const EventChannel _eventChannel = EventChannel('com.example.flutter_activity_recognition/stream/temperature');

  Stream<double> temperatureStream;

  @override
  void initState(){
    super.initState();
    _pedometerBloc = new PedometerBloc();
    _accelerometerBloc = new AccelerometerBloc();
    _lightBloc = new LightBloc();
    _batteryBloc = new BatteryBloc();
    _networkBloc = new NetworkBloc();
    temperatureStream = _eventChannel.receiveBroadcastStream().map((v)=>v);
  }

  @override
  void dispose(){
    print('메인 해체');
    _pedometerBloc.dispose();
    _accelerometerBloc.dispose();
    _lightBloc.dispose();
    _batteryBloc.dispose();
    _temperatureBloc.dispose();
    _networkBloc.dispose();
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
          lightWidget(),
          batteryWidget(),
          temperatureWidget(),
          networkWidget(),
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
            return Text('가속도 데이터 가져올 수 없음', style: TextStyle(fontSize: 20));
          }
        }
    );
  }

  Widget temperatureWidget(){
    return StreamBuilder<double>(
      stream: temperatureStream,
      builder: (context, snapshot){
        if(snapshot.hasData){
          return Text('${snapshot.data}', style: TextStyle(fontSize: 20));
        } else {
          return Text('온도 데이터 가져올 수 없음', style: TextStyle(fontSize: 20));
        }
      },
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
            return Text('걸음 데이터 가져올 수 없음', style: TextStyle(fontSize: 20));
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
            return Text('조도 데이터 가져올 수 없음', style: TextStyle(fontSize: 20));
          }
        }
    );
  }

  Widget batteryWidget(){
    return StreamBuilder<Map>(
      stream: _batteryBloc.batteryStream,
      builder: (context, snapshot){
        if(snapshot.hasData){
          return Text('배터리 상태: ${snapshot.data['charging']} 잔량 ${snapshot.data['level']}', style: TextStyle(fontSize: 20));
        } else {
          return Text('배터리 데이터 가져올 수 없음', style: TextStyle(fontSize: 20));
        }
      }
    );
  }

  Widget networkWidget(){
    return StreamBuilder<String>(
        stream: _networkBloc.networkStream,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Text('${snapshot.data}', style: TextStyle(fontSize: 20));
          } else {
            return Text('네트워크 데이터 가져올 수 없음', style: TextStyle(fontSize: 20));
          }
        }
    );
  }
}