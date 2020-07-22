import 'dart:async';

import 'package:geolocation/geolocation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pedometer/pedometer.dart';

class LocationBloc  {
  final locationSubject = BehaviorSubject<Map>();
  StreamSubscription<LocationResult> streamSubscription;

  LocationBloc(){
    startListening();
  }

  void startListening() async {

    streamSubscription = Geolocation.locationUpdates(
      accuracy: LocationAccuracy.best,
      displacementFilter: 5,
      inBackground: true
    ).listen((event) {
      if(event.isSuccessful){
          String result = '경도: ${event.location.longitude}\n'
                          '위도: ${event.location.latitude} \n';
//                          '고도: ${event.location.altitude} \n';
        Map map = {
          'longitude': event.location.longitude,
          'latitude' : event.location.latitude,
          "altitude" : event.location.altitude
        };
          locationSubject.add(map);
      }
    });
  }

  void dispose() async {
    await streamSubscription.cancel();
  }

  Stream<Map> get locationStream => locationSubject.stream;
  Map get locationValue => locationSubject.value;
}