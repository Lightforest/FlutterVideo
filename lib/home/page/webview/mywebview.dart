import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/fast/constants/constant.dart';
import 'package:flutter_app1/home/page/camera/identify_card.dart';
import 'package:flutter_app1/home/page/camera/identify_face.dart';
import 'package:flutter_app1/home/page/camera/identify_qrcode.dart';


import 'package:webview_flutter/webview_flutter.dart';

class MyWebview extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MyWebviewState();
  }
}

class _MyWebviewState extends State<MyWebview>{
  var webUrl = "";
  var webUrl2;
  //WebViewController _Controller;
  final Completer<WebViewController> _controller =Completer<WebViewController>();
  Future<WebViewController> future_controller ;
  WebViewController _webViewController;
Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCameras();
    timer = new Timer(const Duration(milliseconds: 3000), () {
      try {
       startIdentifyIDCard(context);
      } catch (e) {

      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        top: true,
        //showIDCardPage(),
        child: WebView(
          initialUrl: webUrl,
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: <JavascriptChannel>[
            _alertJavascriptChannel(context),
          ].toSet(),

          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
            future_controller = _controller.future;
          },
        ),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: jsButton(),
    );
  }
  Widget jsButton() {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          _webViewController  = controller.data;
          return Container();
        });
  }
  JavascriptChannel _alertJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Flutter',
        onMessageReceived: (JavascriptMessage message) {
          if(message != null && message.message != null){
            String msg = message.message;
            if(msg == ConstantKey.Web_Identify_Face){
              startIdentifyFace("");
            }else if(msg == ConstantKey.Web_Identify_IDCard){
              startIdentifyIDCard(context);
            }else if(msg == ConstantKey.Web_Identify_QRCode){
              startIdentifyQRcode("");
            }
          }
        });
  }
  /// 开始识别人脸
  startIdentifyFace(String message){
    //startActivity(new Intent(StartWebActivity.this, IdentifyVideoActivity.class));
    //Fluttertoast.showToast(msg: "开始识别人脸");
    try{
      Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) {
            return showFacePage();
          }));
    }catch(e){
      print(e.toString());
    }
  }
  /// 开始识别二维码
  startIdentifyQRcode(String message){
    //startActivity(new Intent(StartWebActivity.this, IdentifyQRcodeActivity.class));
    //Fluttertoast.showToast(msg: "开始识别二维码");
    try{
      Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) {
            return showQRCodePage();
          }));
    }catch(e){
      print(e.toString());
    }
  }
    /// 开始识别身份证
Future startIdentifyIDCard(BuildContext context) async {
    Navigator.push<Map>(context, new MaterialPageRoute(
        builder: (BuildContext context) {
          /*return new MaterialApp(
            home:new Scaffold(
              body: showNextPage(),
            ) ,
          );*/
          return showIDCardPage();
        })).then((Map result) {
      if(result != null){
        identifyIDCardResult(result[ConstantKey.IDCARD_NUM],result[ConstantKey.IDCARD_NAME]);
        //print(result);
      }
    });
  }
  showIDCardPage() {
    if(cameras == null || cameras.isEmpty){
       getCameras();
    }
    return new IdentifyCard(cameras);
  }
  showQRCodePage() {
    if(cameras == null || cameras.isEmpty){
      getCameras();
    }
    return new IdentifyQRCode(cameras);
  }
  showFacePage() {
    if(cameras == null || cameras.isEmpty){
      getCameras();
    }
    return new IdentifyFace(cameras);
  }
  List<CameraDescription> cameras;
  Future<void> getCameras() async {
// Fetch the available cameras before initializing the app.
    try {
      cameras = await availableCameras();
      //FlutterImageCompress.showNativeLog = true;
    } on CameraException catch (e) {
      print(e.toString());
    }
  }
  /// 发送身份证识别结果
  void identifyIDCardResult(var id_card,var name) {
    //_webViewController.evaluateJavascript("identifyIDCardResult('" + card + "','" + name + "');");
    var param1  = "";var temp_card = "";var temp_name = "";
    try{
      temp_card = id_card;temp_name = name;
      param1 = "identifyIDCardResult("+'"'+temp_card+'"'+","+'"'+temp_name+'"'+");";
    } catch(e){
      print(e.toString());
    }
    //var param = 'identifyIDCardResult(1407221994,"鹏华总");';
    _webViewController.evaluateJavascript(param1);
  }
  @override void dispose() {
    // 回收相关资源
    super.dispose();
  }

}

