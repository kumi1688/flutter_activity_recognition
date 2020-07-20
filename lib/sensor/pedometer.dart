import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:pedometer/pedometer.dart';

class PedometerBloc  {
  final _pedometerSubject = BehaviorSubject<int>();
  Pedometer _pedometer;
  int _pedometerInitialValue;


  void startListening() async {
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

  void dispose() async{
    print('pedometer 해체중');
    await _pedometer.pedometerStream.listen((event) {}).cancel();

    _pedometer = null;
  }

  Stream<int> get pedometer => _pedometerSubject.stream;
  int get pedometerInitialValue => _pedometerInitialValue;
}