
import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app1/home/page/webview/mywebview.dart';
import 'package:flutter_app1/third/agora/pages/agorastart.dart';
import 'package:flutter_app1/third/agora/pages/videoanswer.dart';
import 'package:flutter_app1/third/agora/pages/videocall.dart';
import 'package:flutter_app1/third/jpush/jpushpage.dart';

class Routes {
  /** 这里需要注意的事首页一定要用“/”配置，其它页无所谓。 */
  static Router router;
  static String root = "/";
  static String home = "/home";
  static String call = '/third/agora/pages/videocall';
  static String answer = '/third/agora/pages/videoanswer';
  static String webview = "/home/page/webview";
  static String jiguang = "/third/jpush/jpushpage";
  static String agora = "/third/agora/pages/agorastart";


  /* static void configureRoutes(Router router) {
    List widgetDemosList = new WidgetDemoList().getDemos();
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        });
    router.define(home, handler: homeHandler);

    router.define('/category/:type', handler: categoryHandler);
    router.define('/category/error/404', handler: widgetNotFoundHandler);
    router.define(codeView,handler:fullScreenCodeDialog);
    router.define(webViewPage,handler:webViewPageHand);
      widgetDemosList.forEach((demo) {
        Handler handler = new Handler(
            handlerFunc: (BuildContext context, Map<String, List<String>> params) {
              return demo.buildRouter(context);
      });
      router.define('${demo.routerName}', handler: handler);
    });
  }*/
  static void configureRoutes(Router router) {
    router.define(
        webview, handler: Handler(handlerFunc: (context, params) => MyWebview()));
    router.define(
        jiguang, handler: Handler(handlerFunc: (context, params) => JPushPage()));
    router.define(
        webview, handler: Handler(handlerFunc: (context, params) => AgoraStartPage()));
    /*router.define(
    //相当于跳转的链接
        answer,
        //用来获取传参和创建界面
        handler: Handler(handlerFunc: (context, params) {
      var message = params['message']?.first;//取出传参
      return VideoAnswerPage(message);
    }));*/
    Routes.router = router;
  }
  static void toAppointedPage(Router router,String rootPath,Widget widget) {
    if(router != null){
      router.define(
          rootPath, handler: Handler(handlerFunc: (context, params) => widget));
    }
    /*var json = jsonEncode(Utf8Encoder().convert('来自第一个界面'));
    router.navigateTo( context, '${Routes.page2}?message=$json',
        //跳转路径
        transition: TransitionType.inFromRight//过场效果
    ).then((result) {
      //回传值
      if (result != null) {
        //message = result;
      } });*/
  }

}
