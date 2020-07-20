
import 'package:rxdart/rxdart.dart';
import 'package:sensors/sensors.dart';

class AccelerometerBloc{
  List<String> _accelerometerValues;
  List<String> _userAccelerometerValues;
  List<String> _gyroscopeValues;

  final _accelerometerSubject = BehaviorSubject<List<String>>();
  final _userAccelerometerSubject = BehaviorSubject<List<String>>();
  final _gyroscopeSubject = BehaviorSubject<List<String>>();

  AccelerometerBloc(){
    startListening();
  }

  void dispose() async {
    await accelerometerEvents.listen((event) {}).cancel();
    await gyroscopeEvents.listen((event) {}).cancel();
    await userAccelerometerEvents.listen((event) { }).cancel();
  }

  void startListening(){
    accelerometerEvents.listen((AccelerometerEvent event) {
      _accelerometerValues = toListString(toListDouble(event));
      _accelerometerSubject.add(_accelerometerValues);
    });
    gyroscopeEvents.listen((event) {
      _gyroscopeValues = toListString(toListDouble(event));
      _gyroscopeSubject.add(_gyroscopeValues);
    });
    userAccelerometerEvents.listen((event) {
      _userAccelerometerValues = toListString(toListDouble(event));
      _userAccelerometerSubject.add(_userAccelerometerValues);
    });
  }

  List<double> toListDouble(event){
    List<double> accelerometerValues = <double>[event.x, event.y, event.z];
    return accelerometerValues;
  }

  List<String> toListString(List<double> list){
    List<String> accelerometerString = list?.map((double v) => v.toStringAsFixed(2))?.toList();
    return accelerometerString;
  }

  Stream<List<String>> get accelerometerValue => _accelerometerSubject.stream;
  Stream<List<String>> get gyroscopeValue => _gyroscopeSubject.stream;
  Stream<List<String>> get userAccelerometerValue => _userAccelerometerSubject.stream;
}