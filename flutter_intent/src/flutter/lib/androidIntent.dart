import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class AndroidIntent {
  static const String ACTIVITY = "com.tzj.flutter.FlutterMainActivity";
  static const String ACTION_RUN = "android.intent.action.RUN";

  static const int FLAG_ACTIVITY_NO_HISTORY = 0x40000000;
  static const int FLAG_ACTIVITY_SINGLE_TOP = 0x20000000;
  static const int FLAG_ACTIVITY_NEW_TASK = 0x10000000;
  static const int FLAG_ACTIVITY_MULTIPLE_TASK = 0x08000000;
  static const int FLAG_ACTIVITY_CLEAR_TOP = 0x04000000;
  static const int FLAG_ACTIVITY_FORWARD_RESULT = 0x02000000;
  static const int FLAG_ACTIVITY_PREVIOUS_IS_TOP = 0x01000000;
  static const int FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS = 0x00800000;
  static const int FLAG_ACTIVITY_BROUGHT_TO_FRONT = 0x00400000;
  static const int FLAG_ACTIVITY_RESET_TASK_IF_NEEDED = 0x00200000;
  static const int FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY = 0x00100000;
  static const int FLAG_ACTIVITY_CLEAR_WHEN_TASK_RESET = 0x00080000;
  static const int FLAG_ACTIVITY_NEW_DOCUMENT = FLAG_ACTIVITY_CLEAR_WHEN_TASK_RESET;
  static const int FLAG_ACTIVITY_NO_USER_ACTION = 0x00040000;
  static const int FLAG_ACTIVITY_REORDER_TO_FRONT = 0X00020000;
  static const int FLAG_ACTIVITY_NO_ANIMATION = 0X00010000;
  static const int FLAG_ACTIVITY_CLEAR_TASK = 0X00008000;
  static const int FLAG_ACTIVITY_TASK_ON_HOME = 0X00004000;
  static const int FLAG_ACTIVITY_RETAIN_IN_RECENTS = 0x00002000;
  static const int FLAG_ACTIVITY_LAUNCH_ADJACENT = 0x00001000;

  static const String CATEGORY_DEFAULT = "android.intent.category.DEFAULT";
  static const String CATEGORY_BROWSABLE = "android.intent.category.BROWSABLE";
  static const String CATEGORY_VOICE = "android.intent.category.VOICE";
  static const String CATEGORY_ALTERNATIVE = "android.intent.category.ALTERNATIVE";
  static const String CATEGORY_SELECTED_ALTERNATIVE = "android.intent.category.SELECTED_ALTERNATIVE";
  static const String CATEGORY_TAB = "android.intent.category.TAB";
  static const String CATEGORY_LAUNCHER = "android.intent.category.LAUNCHER";
  static const String CATEGORY_LEANBACK_LAUNCHER = "android.intent.category.LEANBACK_LAUNCHER";
  static const String CATEGORY_INFO = "android.intent.category.INFO";
  static const String CATEGORY_HOME = "android.intent.category.HOME";
  static const String CATEGORY_PREFERENCE = "android.intent.category.PREFERENCE";
  static const String CATEGORY_DEVELOPMENT_PREFERENCE = "android.intent.category.DEVELOPMENT_PREFERENCE";
  static const String CATEGORY_EMBED = "android.intent.category.EMBED";
  static const String CATEGORY_APP_MARKET = "android.intent.category.APP_MARKET";
  static const String CATEGORY_SAMPLE_CODE = "android.intent.category.SAMPLE_CODE";
  static const String CATEGORY_OPENABLE = "android.intent.category.OPENABLE";
  static const String CATEGORY_TYPED_OPENABLE  = "android.intent.category.TYPED_OPENABLE";
  static const String CATEGORY_FRAMEWORK_INSTRUMENTATION_TEST = "android.intent.category.FRAMEWORK_INSTRUMENTATION_TEST";
  static const String CATEGORY_CAR_DOCK = "android.intent.category.CAR_DOCK";
  static const String CATEGORY_DESK_DOCK = "android.intent.category.DESK_DOCK";
  static const String CATEGORY_LE_DESK_DOCK = "android.intent.category.LE_DESK_DOCK";
  static const String CATEGORY_HE_DESK_DOCK = "android.intent.category.HE_DESK_DOCK";
  static const String CATEGORY_CAR_MODE = "android.intent.category.CAR_MODE";
  static const String CATEGORY_VR_HOME = "android.intent.category.VR_HOME";
  static const String CATEGORY_APP_BROWSER = "android.intent.category.APP_BROWSER";
  static const String CATEGORY_APP_CALCULATOR = "android.intent.category.APP_CALCULATOR";
  static const String CATEGORY_APP_CALENDAR = "android.intent.category.APP_CALENDAR";
  static const String CATEGORY_APP_CONTACTS = "android.intent.category.APP_CONTACTS";
  static const String CATEGORY_APP_EMAIL = "android.intent.category.APP_EMAIL";
  static const String CATEGORY_APP_GALLERY = "android.intent.category.APP_GALLERY";
  static const String CATEGORY_APP_MAPS = "android.intent.category.APP_MAPS";
  static const String CATEGORY_APP_MESSAGING = "android.intent.category.APP_MESSAGING";
  static const String CATEGORY_APP_MUSIC = "android.intent.category.APP_MUSIC";

  final String action;
  List<String> categorys = <String>[];
  final String data;
  final Map<String, dynamic> arguments;
  final String package;
  final MethodChannel _channel;
  final String component;
  int flags = 0;
  String type;

  AndroidIntent({
    this.action,
    this.data,
    this.arguments,
    this.package,
    this.component
  })  :_channel = const MethodChannel("AndroidIntentPlugin");

  void addFlags(int addflags){
    flags = flags|addflags;
  }
  void addCategory(String category){
    categorys.add(category);
  }
  void setType(String type){
    this.type = type;
  }

  /**
   * 启动
   */
  Future<Map<dynamic, dynamic>> launch() async {
    final Map<String, dynamic> args = <String, dynamic>{'action': action};
    if (categorys.length>0) {
      args['categorys'] = categorys;
    }
    if (data != null) {
      args['data'] = data;
    }
    if (arguments != null) {
      args['arguments'] = arguments;
    }
    if (package != null) {
      args['package'] = package;
    }
    if (component != null) {
      args['component'] = component;
    }
    if (type != null) {
      args['type'] = type;
    }
    if(flags != 0){
      args['flags'] = flags;
    }
    return await _channel.invokeMethod('launch', args);
  }

  /**
   * 打开设置界面
   */
  void openSettings() async{
    await _channel.invokeMethod("openSettings");
  }

  /**
   * 检查权限
   */
  Future<bool> checkPermission(String permission) async{
    return await _channel.invokeMethod("checkPermission",permission);
  }

  /**
   * 请求权限
   */
  Future<List<dynamic>> requestPermissions(List<String> permissions) async{
    return   await _channel.invokeMethod("requestPermissions",permissions);
  }
}
