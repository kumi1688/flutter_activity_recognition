import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_activity_recognition/sensor/accelerometer.dart';
import 'package:flutter_activity_recognition/sensor/pedometer.dart';
import 'package:sensors/sensors.dart';


class WalkingRecognitionPage extends StatefulWidget {
  @override
  _WalkingRecognitionPageState createState() => _WalkingRecognitionPageState();
}

class _WalkingRecognitionPageState extends State<WalkingRecognitionPage> {
  var pedometerBloc;
  var accelerometerBloc;

  @override
  void initState(){
    super.initState();
    pedometerBloc = new PedometerBloc();
    accelerometerBloc = new AccelerometerBloc();
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
            accelerometerWidget(),
            userAccelerometerWidget(),
            gyroscopeWidget()
          ],
        ),
      )
    );
  }

  Widget pedometerWidget(){
    return StreamBuilder<int>(
            stream: pedometerBloc.pedometer,
            initialData: 0,
            builder: (context, snapshot){
              if(snapshot.hasData){
                return Text('${snapshot.data - pedometerBloc.pedometerInitialValue}', style: TextStyle(fontSize: 20));
              } else {
                return Text('현재 데이터 가져올 수 없음', style: TextStyle(fontSize: 20));
              }
            }
        );
  }

  Widget accelerometerWidget(){
    return StreamBuilder<List<String>>(
        stream: accelerometerBloc.accelerometerValue,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Text('가속도 ${snapshot.data}', style: TextStyle(fontSize: 20));
          } else {
            return Text('현재 데이터 가져올 수 없음', style: TextStyle(fontSize: 20));
          }
        }
    );
  }

  Widget userAccelerometerWidget(){
    return StreamBuilder<List<String>>(
        stream: accelerometerBloc.userAccelerometerValue,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Text('가속도(중력x) ${snapshot.data}', style: TextStyle(fontSize: 20));
          } else {
            return Text('현재 데이터 가져올 수 없음', style: TextStyle(fontSize: 20));
          }
        }
    );
  }

  Widget gyroscopeWidget(){
    return StreamBuilder<List<String>>(
        stream: accelerometerBloc.gyroscopeValue,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Text('평형계 ${snapshot.data}', style: TextStyle(fontSize: 20));
          } else {
            return Text('현재 데이터 가져올 수 없음', style: TextStyle(fontSize: 20));
          }
        }
    );
  }


}

