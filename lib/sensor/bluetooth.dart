
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:rxdart/rxdart.dart';


class BluetoothBloc{
  BleManager bleManager;
  var bluetoothStateSubject = BehaviorSubject<String>();
  var bluetoothScanSubject = BehaviorSubject<String>();
  var bluetoothScanConnectSubject = BehaviorSubject<String>();
  var bluetoothSecondSubject = BehaviorSubject<String>();
  var bluetoothSecondConnectedSubject = BehaviorSubject<String>();

  BluetoothManager bluetoothManager = BluetoothManager.instance;

  bool _connected = false;
  BluetoothDevice _device;
  String tips = 'no device connect';

  BluetoothBloc() {
    initBluetooth();
    getDeviceList();
    initBleManager();
    startListening();
  }

  Future<void> initBluetooth() async {
    bool isConnected = await bluetoothManager.isConnected;
    bluetoothManager.state.listen((state) {
      print('cur device status: $state');

      switch (state) {
        case BluetoothManager.CONNECTED:
            _connected = true;
            tips = 'connect success';
            break;
        case BluetoothManager.DISCONNECTED:
            _connected = false;
            tips = 'disconnect success';
            break;
        default:
          break;
      }
      bluetoothSecondSubject.add(_connected.toString());
    });

    if (isConnected) {
        _connected = true;
    }
    bluetoothSecondSubject.add(_connected.toString());
  }

  void getDeviceList(){
    bluetoothManager.startScan();
    bluetoothManager.scanResults.listen((event) {
      bluetoothScanConnectSubject.add(event.toString());
    });
  }

  void initBleManager() async {
    bleManager = new BleManager();
    await bleManager.createClient();
  }

  void startListening() async {
    bleManager.enableRadio(); //ANDROID-ONLY turns on BT. NOTE: doesn't check permissions
    BluetoothState currentState = await bleManager.bluetoothState();

    bleManager.observeBluetoothState().listen((BluetoothState btState) {
      bluetoothStateSubject.add(btState.toString());
      print(btState);
    });

    List<Peripheral> plist = await bleManager.knownPeripherals([]);

    bleManager.startPeripheralScan().listen((ScanResult scanResult) async {
      //Scan one peripheral and stop scanning
      String name = scanResult.peripheral.name != null ? scanResult.peripheral.name : scanResult.advertisementData.localName;
      String result = "${name}, RSSI ${scanResult.rssi}";
      bluetoothScanSubject.add(result);

      Peripheral peripheral = scanResult.peripheral;
      peripheral.observeConnectionState(emitCurrentValue: true, completeOnDisconnect: true)
          .listen((PeripheralConnectionState connectionState) {
            String connectResult = "${scanResult.peripheral.identifier} $connectionState";

      });
      List<Peripheral> plist = await bleManager.knownPeripherals([]);


      await peripheral.connect();
      bool connected = await peripheral.isConnected();


      await peripheral.discoverAllServicesAndCharacteristics();
      List<Service> services = await peripheral.services(); //getting

    });

  }

  void dispose() async {
    await bluetoothStateSubject.drain();
    await bluetoothScanSubject.drain();
    await bluetoothConnectStream.drain();
    await bluetoothScanConnectSubject.close();
    await bluetoothStateSubject.close();
    await bluetoothScanSubject.close();
    await bleManager.destroyClient();
  }

  Stream<String> get bluetoothStateStream => bluetoothStateSubject.stream;
  Stream<String> get bluetoothScanStream => bluetoothScanSubject.stream;
  Stream<String> get bluetoothConnectStream => bluetoothScanConnectSubject.stream;
  Stream<String> get bluetoothSecondStream => bluetoothSecondSubject.stream;

}