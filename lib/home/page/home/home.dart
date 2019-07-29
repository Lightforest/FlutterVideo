//import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/fast/constants/constant.dart';
import 'package:flutter_app1/home/page/camera/example_camera.dart';
import 'package:flutter_app1/home/page/camera/identify_card.dart';
//import 'package:flutter_app1/home/page/custom_camera.dart';
//import 'package:flutter_app1/home/page/example_camera.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>{
  //https://www.cnblogs.com/pjl43/p/9866753.html
  //https://blog.csdn.net/qq_39347285/article/details/86219020
  //https://www.jianshu.com/p/f87044ebe9e7
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  var webUrl = "http://192.168.2.55:8020/XF%E9%A1%B9%E7%9B%AE/login.html";
  var webUrl1= "assets/xf_demo/login.html";
  var webUrl2;
  @override
  Widget build(BuildContext context) {

    /*return new MaterialApp(
      routes: {
        "/": (_) => new WebviewScaffold(
          url: "https://www.baidu.com",
          appBar: new AppBar(
            title: new Text("退役军人信访"),
          ),
        )
      },
    );*/
    /*return new SafeArea(
      top: true,
      child:  WebviewScaffold(
        url:webUrl,
        withZoom: false,
        withLocalStorage: true,
        withJavascript: true,
      ),
    );*/
    return Scaffold(
      body: SafeArea(
        top: true,
        child: WebviewScaffold(
          url:webUrl,
          withZoom: false,
          withLocalStorage: true,
          withJavascript: true,
        ),
      ),
      backgroundColor: Colors.white,
    );
    /*return Scaffold(
    // 默认时沉浸式
      backgroundColor: Colors.white,
      body: WebviewScaffold(
        url:webUrl,
        withZoom: false,
        withLocalStorage: true,
        withJavascript: true,
      ),
    );*/
  }
  @override
  void initState() {
    flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state){
      switch(state.type){
        case WebViewState.shouldStart:
        //准备加载
          print("准备加载");
          break;
        case WebViewState.startLoad:
        //开始加载
          print("开始加载");
          break;
        case WebViewState.finishLoad:
        //加载完成
          print("加载完成");
          //loginWebSuccess();
          //identifyIDCardResult();
          break;
        case WebViewState.abortLoad:
          print("abortLoad");
          break;
      }
    });
    flutterWebviewPlugin.onUrlChanged.listen((String url){
      String nowUrl = url;
      if(nowUrl.contains("findPassword")){
       toCustomCamera(context, ConstantKey.camera_identify_face);
      }
    });
    flutterWebviewPlugin.onDestroy.listen((Null){
      print("onDestroy");

    });
    flutterWebviewPlugin.onHttpError.listen((WebViewHttpError error){
      print("onHttpError");
    });
  }
  /*JavascriptChannel _alertJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toast',
        onMessageReceived: (JavascriptMessage message) {
          showToast(message.message);
        });
  }*/
  startIdentifyFace(String message){
    //startActivity(new Intent(StartWebActivity.this, IdentifyVideoActivity.class));
    Fluttertoast.showToast(msg: "开始识别人脸");
  }
  startIdentifyQRcode(String message){
    //startActivity(new Intent(StartWebActivity.this, IdentifyQRcodeActivity.class));
    Fluttertoast.showToast(msg: "开始识别二维码");
  }
  Future startIdentifyIDCard() async {
    //CommonField.init("RegistIDCardCollectFragment", "信息采集", false);
    //startActivity(new Intent(StartWebActivity.this, CommonActivity.class));
    Fluttertoast.showToast(msg: "开始识别身份证");
    Map result = await Navigator .of(context) .push(
        new MaterialPageRoute(builder: (context) {
          //return new IdentifyCardIndex();
        }));
    if(result != null){
      identifyIDCardResult(result[ConstantKey.IDCARD_NUM],result[ConstantKey.IDCARD_NAME]);
    }
  }

  void loginWebSuccess() {
    flutterWebviewPlugin.evalJavascript("loginWebSuccess();");
  }

  void identifyIDCardResult(var card,var name) {
    var idcard_num = "140401199603032641";
    var idcard_name = "彭昭慧";
    flutterWebviewPlugin.evalJavascript("identifyIDCardResult('" + card + "','" + name + "');");
  }
  @override void dispose() {
    // 回收相关资源
    // Every listener should be canceled, the same should be done with this stream.
    //onUrlChanged.cancel();
    //onStateChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  toCustomCamera(BuildContext context,int cameraType){
    //return CameraApp();
    getCameras(context);

    // pushAndRemoveUntil方式：跳转到下个页面，并且销毁当前页面
    //push方法：直接跳转到下个页面，可以传递参数
    /*Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => new CustomCameraPage(cameraType)
      ),
    );*/
  }
  /*List<CameraDescription> cameras;
  Future<void> getCameras() async {
    cameras = await availableCameras();
    runApp(CameraApp(cameras));
  }*/
}

