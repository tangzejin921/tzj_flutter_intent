import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:android_intent/androidIntent.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: '打开android 界面'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              '点击打开 com.example.flutterpluginexample.MainActivity',
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: (){_open(context);},
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }

  //打开
  void _open(BuildContext context) {
    var intent = AndroidIntent(action:"android.intent.action.RUN",
      component: "com.tzj.flutter.FlutterMainActivity",)
//        ..addCategory(AndroidIntent.CATEGORY_DEFAULT)
//        ..addCategory(AndroidIntent.CATEGORY_APP_BROWSER)
//        ..addFlags(AndroidIntent.FLAG_ACTIVITY_CLEAR_WHEN_TASK_RESET)
          ;
    intent.launch()
    .then((v){
      _showDialog(context,"返回:"+v.toString());
    }).catchError((error){
      _showDialog(context,error.toString()+"");
    });
  }

  void _showDialog(BuildContext context, String text) {
    showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: const Text("activity 返回"),
          content: new Text(text),
          actions: <Widget>[
            new FlatButton(
              child: const Text('关闭'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    ).then<void>((value) {

    });
  }

}
