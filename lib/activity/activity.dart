import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';

class ActivityBloc{
  static const MethodChannel _methodChannel = const MethodChannel('com.example.flutter_activity_recognition');
  var _activitySubject = BehaviorSubject<Activity>();
  ActivityRecognition _activityRecognition;

  ActivityBloc(){
    _activitySubject.addStream(ActivityRecognition.activityUpdates().asBroadcastStream());
  }

  void dispose() async {
    print('닫힘');
    await _activitySubject.drain();
    await _activitySubject.close();
  }

  Future<void> getActivityState() async {
    final Map result = await _methodChannel.invokeMethod('getActivityState');
//    _activitySubject.add(changeToString(result));
  }

  String changeToString(Map map){
    String string = '${map['confidence']} ${map['type']}';
    return string;
  }

  Stream<Activity> get userActivity => _activitySubject.stream;
}