import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_app1/fast/constants/constant.dart';
import 'package:flutter_app1/third/jpush/JpushModule.dart';
import 'package:flutter_app1/fast/utils/MethodChannelUtils.dart';
import 'package:flutter_app1/fast/custom_widgets/myscrollview.dart';
import 'package:jpush_flutter/jpush_flutter.dart';


class JPushPage extends StatefulWidget {

  @override
  _JPushPageState createState() => new _JPushPageState();

  JPushPage();
}

class _JPushPageState extends State<JPushPage> {
  static const _methodChannel1 = const MethodChannel(MethodChannelUtils.channelJpush);
  String debugLable = 'Unknown';
  final JPush jpush = new JPush();
  String userid= "123456789";
  String appkey = APPApiKey.Jpush_app_key;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }
  void initJpush(){
    JpushNotification jpush = new JpushNotification();
    jpush.initJpush();
    jpush.setJpushAlias(userid);
    List<String> tags = new List();
    tags.add("doctor");
    tags.add("nurse");
    Map<dynamic,dynamic> mapTags = jpush.getJpushAllTags();
    if(mapTags == null){
      jpush.setJpushTags(tags);
    }else{
      List<String> listTags = mapTags["tags"];
      if(listTags == null){
        jpush.setJpushTags(tags);
      }else{
        jpush.addJpushTags(tags);
      }
    }
    _methodChannel1.invokeListMethod("startJpushSetting");
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;


    // Platform messages may fail, so we use a try/catch PlatformException.
    jpush.getRegistrationID().then((rid) {
      setState(() {
        debugLable = "flutter getRegistrationID: $rid";
      });
    });

    jpush.setup(
      appKey: appkey,
      channel: "theChannel",
      production: false,
      debug: true,
    );
    jpush.applyPushAuthority(new NotificationSettingsIOS(
        sound: true,
        alert: true,
        badge: true));

    try {

      jpush.addEventHandler(
        onReceiveNotification: (Map<String, dynamic> message) async {
          print("flutter onReceiveNotification: $message");
          setState(() {
            debugLable = "flutter onReceiveNotification: $message";
          });
        },
        onOpenNotification: (Map<String, dynamic> message) async {
          print("flutter onOpenNotification: $message");
          setState(() {
            debugLable = "flutter onOpenNotification: $message";
          });
        },
        onReceiveMessage: (Map<String, dynamic> message) async {
          print("flutter onReceiveMessage: $message");
          setState(() {
            debugLable = "flutter onReceiveMessage: $message";
          });
        },
      );

    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      debugLable = platformVersion;
    });
  }



// 编写视图
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
            child: new ListViewDemo(
                children:[
                  new Text(
                      'result: $debugLable\n',
                    style: TextStyle(
                      color: Colors.red,
                      //fontWeight: FontWeight.w500,
                      //fontStyle: FontStyle.italic,
                      //textBaseline: TextBaseline.alphabetic,
                      fontSize: 16,
                      letterSpacing: 2,
                      wordSpacing: 10,
                      //height: 1.2,
//        foreground: pf,
                    ),
                  ),
                  new FlatButton(
                      child: new Text('sendLocalNotification\n'),
                      onPressed: () {
                        // 三秒后出发本地推送
                        var fireDate = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch + 3000);
                        var localNotification = LocalNotification(
                            id: 234,
                            title: 'fadsfa',
                            buildId: 1,
                            content: 'fdas',
                            fireTime: fireDate,
                            subtitle: 'fasf',
                            badge: 5,
                            extras: {"fa": "0"}
                        );
                        jpush.sendLocalNotification(localNotification).then((res) {
                          setState(() {
                            debugLable = res;
                          });
                        });

                      }),
                  new FlatButton(
                      child: new Text('getLaunchAppNotification\n'),
                      onPressed: () {

                        jpush.getLaunchAppNotification().then((map) {
                          setState(() {
                            debugLable = "getLaunchAppNotification success: $map";
                          });
                        })
                            .catchError((error) {
                          setState(() {
                            debugLable = "getLaunchAppNotification error: $error";
                          });
                        });

                      }),
                  new FlatButton(
                      child: new Text('applyPushAuthority\n'),
                      onPressed: () {
                        jpush.applyPushAuthority(NotificationSettingsIOS(badge: true, alert: true, sound: true));
                      }),
                  new FlatButton(
                      child: new Text('setTags\n'),
                      onPressed: () {
                        jpush.setTags(["lala","haha"]).then((map) {
                          var tags = map['tags'];
                          setState(() {
                            debugLable = "set tags success: $map $tags";
                          });
                        })
                            .catchError((error) {
                          setState(() {
                            debugLable = "set tags error: $error";
                          });
                        }) ;
                      }),
                  new FlatButton(
                      child: new Text('cleanTags\n'),
                      onPressed: () {
                        jpush.cleanTags().then((map) {
                          var tags = map['tags'];
                          setState(() {
                            debugLable = "cleanTags success: $map $tags";
                          });
                        })
                            .catchError((error) {
                          setState(() {
                            debugLable = "cleanTags error: $error";
                          });
                        }) ;
                      }),
                  new FlatButton(
                      child: new Text('addTags\n'),
                      onPressed: () {

                        jpush.addTags(["lala","haha"]).then((map) {
                          var tags = map['tags'];
                          setState(() {
                            debugLable = "addTags success: $map $tags";
                          });
                        })
                            .catchError((error) {
                          setState(() {
                            debugLable = "addTags error: $error";
                          });
                        }) ;

                      }),
                  new FlatButton(
                      child: new Text('deleteTags\n'),
                      onPressed: () {

                        jpush.deleteTags(["lala","haha"]).then((map) {
                          var tags = map['tags'];
                          setState(() {
                            debugLable = "deleteTags success: $map $tags";
                          });
                        })
                            .catchError((error) {
                          setState(() {
                            debugLable = "deleteTags error: $error";
                          });
                        }) ;

                      }),
                  new FlatButton(
                      child: new Text('getAllTags\n'),
                      onPressed: () {

                        jpush.getAllTags().then((map) {
                          setState(() {
                            debugLable = "getAllTags success: $map";
                          });
                        })
                            .catchError((error) {
                          setState(() {
                            debugLable = "getAllTags error: $error";
                          });
                        }) ;

                      }),
                  new FlatButton(
                      child: new Text('setAlias\n'),
                      onPressed: () {

                        jpush.setAlias("thealias11").then((map) {
                          setState(() {
                            debugLable = "setAlias success: $map";
                          });
                        })
                            .catchError((error) {
                          setState(() {
                            debugLable = "setAlias error: $error";
                          });
                        }) ;

                      }),
                  new FlatButton(
                      child: new Text('deleteAlias\n'),
                      onPressed: () {

                        jpush.deleteAlias().then((map) {
                          setState(() {
                            debugLable = "deleteAlias success: $map";
                          });
                        })
                            .catchError((error) {
                          setState(() {
                            debugLable = "deleteAlias error: $error";
                          });
                        }) ;

                      }),
                  new FlatButton(
                      child: new Text('setBadge\n'),
                      onPressed: () {

                        jpush.setBadge(66).then((map) {
                          setState(() {
                            debugLable = "setBadge success: $map";
                          });
                        })
                            .catchError((error) {
                          setState(() {
                            debugLable = "setBadge error: $error";
                          });
                        }) ;

                      }),
                  new FlatButton(
                      child: new Text('stopPush\n'),
                      onPressed: () {

                        jpush.stopPush();

                      }),
                  new FlatButton(
                      child: new Text('resumePush\n'),
                      onPressed: () {

                        jpush.resumePush();

                      }),
                  new FlatButton(
                      child: new Text('clearAllNotifications\n'),
                      onPressed: () {

                        jpush.clearAllNotifications();

                      }),


                ]
            )

        ),
      ),
    );
  }
}
