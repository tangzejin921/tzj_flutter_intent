import 'package:flutter/material.dart';
import 'package:android_intent/AndroidIntent.dart';
import './permissionsView.dart';

void main() => runApp(new MyApp());


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var androidIntent = new AndroidIntent();
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () async {
                androidIntent.openSettings();
              }
            ),
            IconButton(
              icon: Icon(Icons.sms),
              onPressed: () async {
              },
            )
          ],
        ),
        body: Center(
          child: PermissionsGridView([
            PermissionsButton("android.permission.CAMERA")
          ]),
        )
      ),
    );
  }
}
