import 'package:flutter/material.dart';
import 'package:flutter_activity_recognition/page/recognition_running.dart';
import 'package:flutter_activity_recognition/page/recognition_walking.dart';
import 'page/dashboard.dart';

void main() {
  runApp(RootPage());
}

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  static const String DASH_BOARD = '/';
  static const String WALKING = '/walking';
  static const String RUNNING = '/running';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: DASH_BOARD,
        routes: {
          DASH_BOARD: (context) => DashBoardPage(),
          WALKING: (context) => WalkingRecognitionPage(),
          RUNNING: (context) => RunningRecognitionPage(),
        }
    );
  }
}
