import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class TemperatureBloc {
  static const EventChannel eventChannel = EventChannel('com.example.flutter_activity_recognition/stream/temperature');
//  StreamSubscription streamSubscription;
  var temperatureSubject = BehaviorSubject<double>();
  Stream<double> stream;

  void startListening(){
    stream = eventChannel.receiveBroadcastStream().map((v) => v);
    temperatureSubject.addStream(stream);
//    streamSubscription = stream.listen((event) {print(event);});
  }

  void dispose() async {
    await temperatureSubject.drain();
    await temperatureSubject.close();
//    streamSubscription.cancel();
  }

  Stream<double> get temperatureStream => stream;

}