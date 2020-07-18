import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_activity_recognition/sensor/pedometer.dart';

class WalkingRecognitionPage extends StatefulWidget {
  @override
  _WalkingRecognitionPageState createState() => _WalkingRecognitionPageState();
}

final pedometerBloc = new PedometerBloc();

class _WalkingRecognitionPageState extends State<WalkingRecognitionPage> {
  @override
  void initState(){
    super.initState();
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

          ],
        ),
      )
    );
  }

  Widget pedometerWidget(){
    return Center(
        child: StreamBuilder<int>(
            stream: pedometerBloc.pedometer,
            initialData: 0,
            builder: (context, snapshot){
              if(snapshot.hasData){
                return Text('${snapshot.data - pedometerBloc.pedometerInitialValue}', style: TextStyle(fontSize: 30));
              } else {
                return Text('현재 데이터 가져올 수 없음', style: TextStyle(fontSize: 30));
              }
            }
        )
    );
  }
}

