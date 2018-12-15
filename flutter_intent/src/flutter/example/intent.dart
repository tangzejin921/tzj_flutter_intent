import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(new IntentApp());
}


//打开
void _open(BuildContext context) {
  var intent = AndroidIntent(
    component: AndroidIntent.ACTIVITY,
    action: AndroidIntent.ACTION_RUN,
    arguments: {
      "route":"secondPage",
    },
  )
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

class IntentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter intent Demo',
      theme: new ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: new _EntryHome(title: 'Flutter intent Demo'),
      routes: <String, WidgetBuilder> {
        'secondPage': (BuildContext context) => new _SecondPage(""),
      },
    );
  }
}

class _EntryHome extends StatefulWidget {
  _EntryHome({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<_EntryHome> createState() => new _EntryHomeState();
}

class _EntryHomeState extends State<_EntryHome> {

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
            new FlatButton(
              child: new Text("Navigator"),
              onPressed: (){
                Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (_)=>new _FirsePage()
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class _FirsePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            centerTitle: true,
            title: new Text('FirsePage'),
          ),
          body: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new FlatButton(
                  child: new Text("点击打开 activity"),
                  onPressed: ()=>_open(context),
                ),
              ],
            ),
          ),
        )
    );
  }
}

class _SecondPage extends StatelessWidget {
  String text;
  _SecondPage(String text){
    this.text = text;
  }


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            centerTitle: true,
            title: new Text('SecondPage'),
          ),
          body: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new FlatButton(
                  child: new Text("this is SecondPage\n${text}"),
                ),
              ],
            ),
          ),
        )
    );
  }
}
