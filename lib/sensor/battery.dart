import 'dart:async';

import 'package:battery/battery.dart';
import 'package:rxdart/rxdart.dart';

class BatteryBloc{
  Battery battery;
  BehaviorSubject<Map> batterySubject = BehaviorSubject<Map>();
  StreamSubscription streamSubscription;

  BatteryBloc(){
    battery = new Battery();
    getInitialData();
    startListening();
  }

  void startListening(){
    streamSubscription =
      battery.onBatteryStateChanged.listen((BatteryState event) async {
        Map map = new Map();
        if(event == BatteryState.full){
          map['charging'] = '완전히 충전됨';
        } else if (event == BatteryState.charging){
          map['charging'] = '충전중';
        } else if (event == BatteryState.discharging ){
          map['charging'] = '충전안됨';
        }
        map['level'] = await getBatteryLevel();
        batterySubject.add(map);
      });
  }

  void dispose() async {
    await batterySubject.drain();
    await batterySubject.close();
    streamSubscription.cancel();
  }

  Future<Map> getInitialData() async {
    int batteryLevel = await getBatteryLevel();
    Map map = new Map();
    map['charging'] = '확인중';
    map['level'] = await getBatteryLevel();
    batterySubject.add(map);
  }

  Future<int> getBatteryLevel() async {
    int batteryLevel = await battery.batteryLevel;
    return batteryLevel;
  }

  Stream<Map> get batteryStream => batterySubject.stream;
  int get batteryLevel {
    getBatteryLevel().then((value) => value);
  }
  Map get batteryValue => batterySubject.value;
}