import 'dart:async';

import 'package:light/light.dart';
import 'package:rxdart/rxdart.dart';

class LightBloc{

  final _lightSubject = BehaviorSubject<int>();
  Light _light;

  LightBloc(){
    startListening();
  }

  void dispose() async {
    await _lightSubject.drain();
    await _lightSubject.close();
  }

  void startListening(){
    _light = new Light();
    _light.lightSensorStream.listen(onData);
  }

  void onData(int value) async{
    _lightSubject.add(value);
  }

  Stream<int> get lightStream => _lightSubject.stream;
  int get lightValue => _lightSubject.value;
}