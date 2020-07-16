import 'package:flutter/material.dart';

class DashBoardPage extends StatefulWidget {
  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  static const String WALKING = '/walking';

  _showNextPage(BuildContext context, String destination) => Navigator.pushNamed(context, destination);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('메인화면')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(onPressed: ()=>_showNextPage(context, WALKING), child: Text('걷기 상태 측정하기')),
            RaisedButton(onPressed: ()=>{}, child: Text('뛰기 상태 측정하기')),
          ],),
      )
    );
  }



}
