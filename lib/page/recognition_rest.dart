import 'dart:async';

import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_activity_recognition/activity/activity.dart';
import 'package:flutter_activity_recognition/location/location.dart';
import 'package:flutter_activity_recognition/sensor/accelerometer.dart';
import 'package:flutter_activity_recognition/sensor/battery.dart';
import 'package:flutter_activity_recognition/sensor/bluetooth.dart';
import 'package:flutter_activity_recognition/sensor/headphone.dart';
import 'package:flutter_activity_recognition/sensor/light.dart';
import 'package:flutter_activity_recognition/sensor/network.dart';
import 'package:flutter_activity_recognition/sensor/pedometer.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
  var _bluetoothBloc;
  var _activityBloc;
  Timer _timer;
  IO.Socket _socket;

  static const String SERVER_URL = 'http://15.164.226.165:3000/network';

  @override
  void initState(){
    super.initState();
    _pedometerBloc = new PedometerBloc();
    _accelerometerBloc = new AccelerometerBloc();
    _lightBloc = new LightBloc();
    _batteryBloc = new BatteryBloc();
    _networkBloc = new NetworkBloc();
    _locationBloc = new LocationBloc();
    _bluetoothBloc = new BluetoothBloc();
    initWebsocket();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      sendDataByWebsocket();
    });
  }

  @override
  void dispose(){
    _pedometerBloc.dispose();
    _accelerometerBloc.dispose();
    _lightBloc.dispose();
    _batteryBloc.dispose();
    _networkBloc.dispose();
    _locationBloc.dispose();
    _bluetoothBloc.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return ListView(
      children: <Widget>[
        ListTile(
            leading: Icon(Icons.bluetooth, size: 30,),
            title: Text('블루투스 전원', style: TextStyle(fontSize: 15)),
            trailing: bleStateWidget()
        ),
        ListTile(
            leading: Icon(Icons.bluetooth, size: 30,),
            title: Text('블루투스 연결', style: TextStyle(fontSize: 15)),
            trailing: bluetoothConnectWidget()
        ),
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

    switch(type){
      case 'accelerometer':
        stream = _accelerometerBloc.accelerometerStream;
        break;
      case 'gyroscope':
        stream = _accelerometerBloc.gyroscopeStream;
        break;
      case 'userAccelerometer':
        stream = _accelerometerBloc.userAccelerometerStream;
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

  Widget bleStateWidget(){
    return StreamBuilder<String>(
        stream: _bluetoothBloc.bleStateStream,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Text('${snapshot.data}', style: TextStyle(fontSize: 15));
          } else {
            return Text('현재 데이터 가져올 수 없음', style: TextStyle(fontSize: 15));
          }
        }
    );
  }

  Widget bleScanWidget(){
    return StreamBuilder<String>(
        stream: _bluetoothBloc.bleScanStream,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Text('${snapshot.data}', style: TextStyle(fontSize: 15));
          } else {
            return Text('현재 데이터 가져올 수 없음', style: TextStyle(fontSize: 15));
          }
        }
    );
  }

  Widget bluetoothConnectWidget(){
    return StreamBuilder<String>(
        stream: _bluetoothBloc.bluetoothStream,
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
        stream: _lightBloc.lightStream,
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
    return StreamBuilder<Map>(
        stream: _networkBloc.networkStream,
        builder: (context, snapshot){
          if(snapshot.hasData){
            String text = '${snapshot.data['state']}\n'
                '${snapshot.data['name'] ?? ''}\n'
                '${snapshot.data['bssid'] ?? ''}\n'
                '${snapshot.data['ip'] ?? ''}';
            return Text('${text}', style: TextStyle(fontSize: 15));
          } else {
            return Text('네트워크 데이터 가져올 수 없음', style: TextStyle(fontSize: 15));
          }
        }
    );
  }

  Widget locationWidget(){
    return StreamBuilder<Map>(
        stream: _locationBloc.locationStream,
        builder: (context, snapshot){
          if(snapshot.hasData){
            String text = '위도: ${snapshot.data['latitude']}\n'
                '경도: ${snapshot.data['longitude']}\n';

            return Text('${text}', style: TextStyle(fontSize: 15));
          } else {
            return Text('위치 데이터 가져올 수 없음', style: TextStyle(fontSize: 15));
          }
        }
    );
  }

  void sendData() async{
    var data = {
      "time": new DateTime.now().toString()
    };
    http.post(SERVER_URL, body: data);
  }

  void initWebsocket() async{
    _socket = IO.io(SERVER_URL, <String, dynamic>{
      'transports': ['websocket']
    });
    _socket.on('connect', (_){
      print('connect');
    });
  }

  void sendDataByWebsocket() async{
    int pedometerValue = _pedometerBloc.pedometerValue ;
    int initialValue = _pedometerBloc.pedometerInitialValue;
    int pedometerResult = pedometerValue != null ? pedometerValue - initialValue : null;
    var data = {
      "network": {
        "state": _networkBloc.networkValue['state'] ?? '',
        "name": _networkBloc.networkValue['name'] ?? '',
        "bssid": _networkBloc.networkValue['bssid'] ?? '',
        "ip": _networkBloc.networkValue['ip'] ?? '',
      },
      "pedometer": pedometerResult,
      "accelerometer": _accelerometerBloc.accelerometerValue,
      "gyroscope": _accelerometerBloc.gyroscopeValue,
      "userAccelerometer": _accelerometerBloc.userAccelerometerValue,
      "light": _lightBloc.lightValue,
      "battery": {
        "charging": _batteryBloc.batteryValue['charging'] ?? '',
        "level": _batteryBloc.batteryValue['level'] ?? ''
      },
      "location": {
        'longitude': _locationBloc.locationValue['longitude'] ?? '',
        'latitude' : _locationBloc.locationValue['latitude'] ?? '',
        "altitude" : _locationBloc.locationValue['altitude'] ?? '',
      },
      "bluetooth": {
        "on": _bluetoothBloc.bluetoothState['on'] ?? '',
        "connectToDevice": _bluetoothBloc.bluetoothState['connectToDevice'] ?? ''
      },
      "activity": {
        "probableActivity": {
          "type": _activityBloc?.userActivityValue?.type ?? '',
          "confidence": _activityBloc?.userActivityValue?.cofidence ?? '',
        },
        "userSelected": "rest"
      },
      "time": new DateTime.now().toString()
    };
    _socket.emit('data', data);
  }
}