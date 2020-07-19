import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class ActivityBloc{
  static const MethodChannel _methodChannel = const MethodChannel('com.example.flutter_activity_recognition');
  var _activitySubject = BehaviorSubject<String>();
  Timer timer;

  ActivityBloc(){
    timer = new Timer.periodic(new Duration(seconds: 1), (timer){
      getActivityState();
    });
  }

  Future<void> getActivityState() async {
    final Map result = await _methodChannel.invokeMethod('getActivityState');
    _activitySubject.add(changeToString(result));
  }

  String changeToString(Map map){
    String string = '${map['confidence']} ${map['type']}';
    return string;
  }

  Stream<String> get userActivity => _activitySubject.stream;
}