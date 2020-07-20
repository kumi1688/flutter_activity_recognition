import 'dart:async';

import 'package:battery/battery.dart';
import 'package:rxdart/rxdart.dart';

class BatteryBloc{
  Battery battery;
  BehaviorSubject<Map> batterySubject = BehaviorSubject<Map>();
  StreamSubscription streamSubscription;

  BatteryBloc(){
    battery = new Battery();
    startListening();
  }

  void startListening(){
    streamSubscription =
      battery.onBatteryStateChanged.listen((BatteryState event) async {
        Map map = new Map();
        if(event == BatteryState.full){
          map['charging'] = 'full';
        } else if (event == BatteryState.charging){
          map['charging'] = 'charging';
        } else if (event == BatteryState.discharging ){
          map['charging'] = 'discharging';
        }
        map['level'] = await getBatteryLevel();
        batterySubject.add(map);
      });
  }

  void dispose() async {
    streamSubscription.cancel();
    await batterySubject.drain();
    await batterySubject.close();
  }

  Future<int> getBatteryLevel() async {
    int batteryLevel = await battery.batteryLevel;
    return batteryLevel;
  }

  Stream<Map> get batteryStream => batterySubject.stream;
  int get batteryLevel {
    getBatteryLevel().then((value) => value);
  }
}