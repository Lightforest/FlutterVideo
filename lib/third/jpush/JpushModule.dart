import 'package:flutter_app1/fast/constants/constant.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

class JpushNotification{


  JPush jpush;
  void initJpush (){
    createJpush ();
    addJpushEventHandler();
    setupJpush();
  }
  JPush createJpush (){
    jpush = new JPush();
    return jpush;
  }
  void addJpushEventHandler(){
    if(jpush == null){
      createJpush ();
    }
    jpush.addEventHandler(
// 接收通知回调方法。
      onReceiveNotification: (Map<String, dynamic> message) async {
        // 可以收到附加消息字段
        print("flutter onReceiveNotification: $message");
      },
// 点击通知回调方法。
      onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
      },
// 接收自定义消息回调方法。
      onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
      },
    );
  }
  /// 初始化 JPush SDK   、  将缓存的事件下发到 dart 环境中
  void setupJpush(){
    if(jpush == null){
      createJpush();
    }
    jpush.setup(
      appKey: APPApiKey.Jpush_app_key,
      channel: "theChannel",
      production: false,
      debug: true, // 设置是否打印 debug 日志
    );
  }
  /// 获取 registrationId，这个 JPush 运行通过 registrationId 来进行推送
  String getJpushRegistrationID(){
    if(jpush == null){
      createJpush();
    }
    jpush.getRegistrationID().then((rid ) {
      print(rid);
    });
  }
  /// 停止推送功能，调用该方法将不会接收到通知
  void stopPush(){
    if(jpush == null){
      createJpush();
    }
    jpush.stopPush();
  }
  /// 调用 stopPush 后，可以通过 resumePush 方法恢复推送
  void resumePush(){
    if(jpush == null){
      createJpush();
    }
    jpush.resumePush();
  }
  /// 设置别名，极光后台可以通过别名来推送，一个 App 应用只有一个别名，一般用来存储用户 id
  void setJpushAlias(String alias){
    if(jpush == null){
      createJpush();
    }
    if(alias != null && alias != ""){
      jpush.setAlias(alias).then((map) { });
    }
  }
  /// 可以通过 deleteAlias 方法来删除已经设置的 alias
  void deleteJpushAlias(){
    if(jpush == null){
      createJpush();
    }
    jpush.deleteAlias().then((map) {});
  }
  /// ios only
  void applyPushAuthority(){
    if(jpush == null){
      createJpush();
    }
    jpush.applyPushAuthority(new NotificationSettingsIOS(
        sound: true,
        alert: true,
        badge: true));
  }
  /// 重置 tags。
  void setJpushTags(List<String> tags){
    if(jpush == null){
      createJpush();
    }
    if(tags != null ){
      jpush.setTags(tags).then((map) { });
    }
  }
  /// 在原来的 Tags 列表上删除指定 tags。
  void addJpushTags(List<String> tags){
    if(jpush == null){
      createJpush();
    }
    if(tags != null ){
      jpush.addTags(tags).then((map) { });
    }
  }
  /// 可以通过 deleteTags 方法来删除已经设置的 tags
  void deleteJpushTags(List<String> tags){
    if(jpush == null){
      createJpush();
    }
    jpush.deleteTags(tags).then((map) {});
  }
  Map<dynamic,dynamic> getJpushAllTags(){
    Map<dynamic,dynamic> tags;
    jpush.getAllTags().then((map) {
      tags = map;
      return tags;
    });
  }
  void cleanJpushTags(){
    if(jpush == null){
      createJpush();
    }
    jpush.cleanTags( ).then((map) {});
  }
}
