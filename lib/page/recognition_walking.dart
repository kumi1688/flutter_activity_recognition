import 'dart:async';

import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_activity_recognition/activity/activity.dart';
import 'package:flutter_activity_recognition/location/location.dart';
import 'package:flutter_activity_recognition/sensor/accelerometer.dart';
import 'package:flutter_activity_recognition/sensor/headphone.dart';
import 'package:flutter_activity_recognition/sensor/light.dart';
import 'package:flutter_activity_recognition/sensor/pedometer.dart';
import 'package:rxdart/rxdart.dart';

class WalkingRecognitionPage extends StatefulWidget {
  @override
  WalkingRecognitionPageState createState() => WalkingRecognitionPageState();
}

class WalkingRecognitionPageState extends State<WalkingRecognitionPage> {
  var _pedometerBloc;
  var _accelerometerBloc;
  var _locationBloc;

  @override
  void initState(){
    super.initState();
    _pedometerBloc = new PedometerBloc();
    _accelerometerBloc = new AccelerometerBloc();
    _locationBloc = new LocationBloc();
  }

  @override
  void dispose(){
    print('메인 해체');
    _pedometerBloc.dispose();
    _accelerometerBloc.dispose();
    _locationBloc.dispose();
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
          locationWidget(),
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

  Widget locationWidget(){
    return StreamBuilder<String>(
        stream: _locationBloc.locationStream,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Text('${snapshot.data}', style: TextStyle(fontSize: 20));
          } else {
            return Text('위치 데이터 가져올 수 없음', style: TextStyle(fontSize: 20));
          }
        }
    );
  }
}