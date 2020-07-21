import 'dart:async';

import 'package:geolocation/geolocation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pedometer/pedometer.dart';

class LocationBloc  {
  final locationSubject = BehaviorSubject<String>();
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
          locationSubject.add(result);
      }
    });
  }

  void dispose() async {
    await streamSubscription.cancel();
  }

  Stream<String> get locationStream => locationSubject.stream;
}