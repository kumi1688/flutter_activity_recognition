import 'dart:async';

import 'package:light/light.dart';
import 'package:rxdart/rxdart.dart';

class LightBloc{

  final _lightSubject = BehaviorSubject<int>();
  Light _light;

  LightBloc(){
    startListening();
  }

  void startListening(){
    _light = new Light();
    _light.lightSensorStream.listen(onData);
  }

  void onData(int value) async{
    _lightSubject.add(value);
  }
  Stream<int> get light => _lightSubject.stream;
}