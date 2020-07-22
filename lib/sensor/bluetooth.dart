
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:rxdart/rxdart.dart';


class BluetoothBloc{
  BleManager bleManager;
  var bleStateSubject = BehaviorSubject<String>();
  var bleScanSubject = BehaviorSubject<String>();
  var bleScanConnectSubject = BehaviorSubject<String>();

  var bluetoothSubject = BehaviorSubject<String>();
  var bluetoothConnecteSubject = BehaviorSubject<String>();

  BluetoothManager bluetoothManager = BluetoothManager.instance;

  bool _connected = false;
  BluetoothDevice _device;

  BluetoothBloc() {
    initBluetooth();
//    getDeviceList();
    initBleManager();
    startListening();
  }

  Future<void> initBluetooth() async {
    bool isConnected = await bluetoothManager.isConnected;
    bluetoothManager.state.listen((state) {
      switch (state) {
        case BluetoothManager.CONNECTED:
            _connected = true;
            break;
        case BluetoothManager.DISCONNECTED:
            _connected = false;
            break;
        default:
          break;
      }
      bluetoothSubject.add(_connected.toString());
    });
  }

  void getDeviceList(){
    bluetoothManager.startScan();
    bluetoothManager.scanResults.listen((event) {
      event.map((e){
        bluetoothConnecteSubject.add(e.connected.toString());
      });
    });
  }

  void initBleManager() async {
    bleManager = new BleManager();
    await bleManager.createClient();
  }

  void startListening() async {
    bleManager.observeBluetoothState().listen((BluetoothState btState) {
      bleStateSubject.add(btState.toString());
    });

    List<Peripheral> plist = await bleManager.knownPeripherals([]);

    bleManager.startPeripheralScan().listen((ScanResult scanResult) async {
      String name = scanResult.peripheral.name != null ? scanResult.peripheral.name : scanResult.advertisementData.localName;
      String result = '${name}\n'
                      'RSSI ${scanResult.rssi}0';
      bleScanSubject.add(result);
    });

  }

  void dispose() async {
    await bleStateSubject.drain();
    await bleScanSubject.drain();
    await bluetoothConnectStream.drain();
    await bleScanConnectSubject.close();
    await bleStateSubject.close();
    await bleScanSubject.close();
    await bleManager.destroyClient();
  }

  Stream<String> get bleStateStream => bleStateSubject.stream;
  Stream<String> get bleScanStream => bleScanSubject.stream;
  Stream<String> get bleConnectStream => bleScanConnectSubject.stream;


  Stream<String> get bluetoothStream => bluetoothSubject.stream;
  Stream<String> get bluetoothConnectStream => bluetoothConnecteSubject.stream;

  Map get bluetoothState{
    var data = {
      'on': bleStateSubject.value,
      "connectToDevice": bluetoothSubject.value
    };
    return data;
  }

}