import 'dart:async';

import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_activity_recognition/activity/activity.dart';
import 'package:flutter_activity_recognition/location/location.dart';
import 'package:flutter_activity_recognition/sensor/accelerometer.dart';
import 'package:flutter_activity_recognition/sensor/battery.dart';
import 'package:flutter_activity_recognition/sensor/headphone.dart';
import 'package:flutter_activity_recognition/sensor/light.dart';
import 'package:flutter_activity_recognition/sensor/network.dart';
import 'package:flutter_activity_recognition/sensor/pedometer.dart';

class RestRecognitionPage extends StatefulWidget {
  @override
  RestRecognitionPageState createState() => RestRecognitionPageState();
}

class RestRecognitionPageState extends State<RestRecognitionPage> {
  var _pedometerBloc;
  var _accelerometerBloc;
  var _lightBloc;
  var _batteryBloc;
  var _locationBloc;
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
    _locationBloc = new LocationBloc();
    temperatureStream = _eventChannel.receiveBroadcastStream().map((v)=>v);
  }

  @override
  void dispose(){
    print('메인 해체');
    _pedometerBloc.dispose();
    _accelerometerBloc.dispose();
    _lightBloc.dispose();
    _batteryBloc.dispose();
    _networkBloc.dispose();
    _locationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.directions_walk, size: 30,),
          title: Text('걸음', style: TextStyle(fontSize: 15)),
          trailing: pedometerWidget(),
        ),
        ListTile(
          leading: Icon(Icons.arrow_forward, size: 30,),
          title: Text('가속도', style: TextStyle(fontSize: 15)),
          trailing: buildWidget('accelerometer'),
        ),
        ListTile(
          leading: Icon(Icons.arrow_forward, size: 30,),
          title: Text('가속도(중력x)', style: TextStyle(fontSize: 15)),
          trailing: buildWidget('userAccelerometer'),
        ),
        ListTile(
          leading: Icon(Icons.arrow_forward, size: 30,),
          title: Text('자이로스코프', style: TextStyle(fontSize: 15)),
          trailing: buildWidget('gyroscope'),
        ),
        ListTile(
          leading: Icon(Icons.location_on, size: 30,),
          title: Text('위치', style: TextStyle(fontSize: 15)),
          trailing: locationWidget(),
        ),
        ListTile(
            leading: Icon(Icons.lightbulb_outline, size: 30,),
            title: Text('조도', style: TextStyle(fontSize: 15)),
            trailing: lightWidget()
        ),
        ListTile(
            leading: Icon(Icons.battery_full, size: 30,),
            title: Text('배터리', style: TextStyle(fontSize: 15)),
            trailing: batteryWidget()
        ),
        ListTile(
          leading: Icon(Icons.wifi, size: 30),
          title: networkWidget(),
        ),
      ],
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
            return Text('${snapshot.data}', style: TextStyle(fontSize: 15));
          } else {
            return Text('현재 데이터 가져올 수 없음', style: TextStyle(fontSize: 15));
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
            return Text('${snapshot.data - _pedometerBloc.pedometerInitialValue}', style: TextStyle(fontSize: 15));
          } else {
            return Text('현재 데이터 가져올 수 없음', style: TextStyle(fontSize: 15));
          }
        }
    );
  }

  Widget lightWidget(){
    return StreamBuilder<int>(
        stream: _lightBloc.light,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Text('${snapshot.data}', style: TextStyle(fontSize: 15));
          } else {
            return Text('조도 데이터 가져올 수 없음', style: TextStyle(fontSize: 15));
          }
        }
    );
  }

  Widget batteryWidget(){
    return StreamBuilder<Map>(
        stream: _batteryBloc.batteryStream,
        builder: (context, snapshot){
          if(snapshot.hasData){
            String result = '${snapshot.data['charging']} 잔량 ${snapshot.data['level']}%';
            return Text(result, style: TextStyle(fontSize: 15));
          } else {
            return Text('배터리 데이터 가져올 수 없음', style: TextStyle(fontSize: 15));
          }
        }
    );
  }

  Widget networkWidget(){
    return StreamBuilder<String>(
        stream: _networkBloc.networkStream,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Text('${snapshot.data}', style: TextStyle(fontSize: 15));
          } else {
            return Text('네트워크 데이터 가져올 수 없음', style: TextStyle(fontSize: 15));
          }
        }
    );
  }

  Widget locationWidget(){
    return StreamBuilder<String>(
        stream: _locationBloc.locationStream,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Text('${snapshot.data}', style: TextStyle(fontSize: 15));
          } else {
            return Text('위치 데이터 가져올 수 없음', style: TextStyle(fontSize: 15));
          }
        }
    );
  }
}