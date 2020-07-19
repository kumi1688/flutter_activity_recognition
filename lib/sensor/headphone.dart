
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class HeadphoneBloc {
  final _headphoneSubject = BehaviorSubject<String>();
  Stream<String> _headphoneState;
  static const EventChannel _eventChannel = const EventChannel('com.example.flutter_activity_recognition/stream/headphone');

  HeadphoneBloc(){
    startListening();
  }

  void startListening(){
    _eventChannel.receiveBroadcastStream();
    _headphoneState = _eventChannel.receiveBroadcastStream().map((var v){print(v); return v.toString();});
    print('안녕');
  }

  Stream<String> get headphoneState => _headphoneState;
}
