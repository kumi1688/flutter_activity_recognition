
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class PedometerBloc {
  final _pedometerSubject = BehaviorSubject<int>();
  Pedometer _pedometer;
  int _pedometerInitialValue;

  void startListening() {
    _pedometer = new Pedometer();
    _pedometer.pedometerStream.listen(_onData,
        onError: _onError, onDone: _onDone, cancelOnError: true);
    _pedometerSubject.addStream(_pedometer.pedometerStream);
  }

//  void stopListening() {
//    _subscription.cancel();
//  }

  void _onData(int newValue) async {
    if(_pedometerInitialValue == -1){
      _pedometerInitialValue = newValue;
    }
  }

  void _onDone() => print("Finished pedometer tracking");
  void _onError(error) => print("Flutter Pedometer Error: $error");

  PedometerBloc () {
    _pedometerInitialValue = -1;
    startListening();
  }

  Stream<int> get pedometer => _pedometerSubject.stream;
  int get pedometerInitialValue => _pedometerInitialValue;
}

class HeadphoneBloc {
  final _headphoneSubject = BehaviorSubject<String>();
  Stream<String> _headphoneState;
  static const EventChannel _eventChannel = const EventChannel('com.example.flutter_activity_recognition/stream/headphone');

  void startListening(){
    _eventChannel.receiveBroadcastStream();
    _headphoneState = _eventChannel.receiveBroadcastStream();
  }

  Stream<String> get headphoneState => _headphoneState;
}
