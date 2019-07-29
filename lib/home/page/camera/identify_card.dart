import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/home/page/camera/identify_face.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app1/fast/constants/constant.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'camera_pojo.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


Future<void> getIdentifyCardDemo() async {
// Fetch the available cameras before initializing the app.
  try {
    cameras = await availableCameras();
    FlutterImageCompress.showNativeLog = true;
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  //return new IdentifyCard();
}

class IdentifyCard extends StatefulWidget {
  List<CameraDescription> _cameras;

  IdentifyCard(this._cameras){
    cameras = _cameras;
  }

  @override
  _IdentifyCardState createState() {
    return _IdentifyCardState();
  }
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _IdentifyCardState extends State<IdentifyCard> {
  CameraController controller;
  //String imagePath;
  String videoPath;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;
  WidgetsBinding widgetsBinding;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    if(cameras != null && !cameras.isEmpty){
      onNewCameraSelected(cameras[0]);// 后置摄像头
     // onNewCameraSelected(cameras[1]);// 前置摄像头
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: new Container(
          color: Colors.black,
          child:new Stack(children: <Widget>[
            new Column(children: <Widget>[
              Expanded(
                flex: 3,//flex用来设置当前可用空间的占优比
                child:  new Stack(children: <Widget>[
                  _cameraPreviewWidget(),//相机视图
                  _cameraFloatImage(),//悬浮的身份证框图
                ]),
              ),
              Expanded(
                flex: 1,//flex用来设置当前可用空间的占优比
                child: _takePictureLayout(),//拍照操作区域布局
              ),
            ],),
            getPhotoPreview(),//图片预览布局
            getProgressDialog(),//数据加载中提示框
            getRestartAlert(),// 身份证识别失败，重新拍照的提示按钮
          ]),
        )
    );
  }
  Widget _takePictureLayout(){
    return new Align(
        alignment: Alignment.bottomCenter,
        child: new Container(
          color: Colors.blueAccent,
          alignment: Alignment.center,
          child:  new IconButton(
            iconSize: 50.0,
            onPressed: controller != null &&
                controller.value.isInitialized &&
                !controller.value.isRecordingVideo
                ? onTakePictureButtonPressed
                : null,
            icon: Icon(
              Icons.photo_camera,
              color: Colors.white,
            ),
          ),
        ));
  }
  Widget _cameraFloatImage(){
    return new Positioned(
        child: new Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.fromLTRB(50, 50, 50, 50),
          child:new Image.asset('assets/images/bg_identify_idcard.png'),
        ));
  }
  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return new Container(
        width:double.infinity,
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller),
        ),
      );
    }
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          videoController = null;
          videoController?.dispose();
        });
        if (filePath != null) {
          //showInSnackBar('Picture saved to $filePath');
          photoPath = filePath;
          setState(() { });
          getIDCardInfo(File(filePath));
        }
      }
    });
  }



  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
  Future getIDCardInfo(File file) async {
    showProgressDialog =true;//展示加载框
    Dio dio = new Dio();
    dio.options.contentType=ContentType.parse("multipart/form-data");
    var baseUrl = "https://api-cn.faceplusplus.com/cardpp/v1/ocridcard";

    final String targetPath = await getTempDir();
    File compressFile =await getCompressImage(file, targetPath);
    FormData formData = new FormData.from({
      "api_key": APPApiKey.Face_api_key,
      "api_secret": APPApiKey.Face_api_secret,
      "image_file": new UploadFileInfo(compressFile, "image_file")
    });
    Response<Map>  response;
    try {
      response =await dio.post<Map>(baseUrl,data:formData);
    } catch (e) {
      print(e);
      showProgressDialog =false;//隐藏加载框
      setState(() {});
    }
    showProgressDialog =false;//隐藏加载框
    setState(() {});
    if(response != null){
      print(response.data);
      Map<String,Object> resultMap = response.data;
      List<dynamic> cards =resultMap['cards'];
      if(cards != null && !cards.isEmpty){
        Map<String,dynamic> card = cards[0];
        Navigator.pop(context, card);
        var idcard = card[IDCardIdentifyResult.id_card_number];
        var name = card[IDCardIdentifyResult.name];
        var birth = card[IDCardIdentifyResult.birthday];
        var address = card[IDCardIdentifyResult.address];
        print('身份证号： ${idcard}');
        print('姓名： ${name}');
        print('出生日期： ${birth}');
        print('地址： ${address}');
      }else{
        restart = true;//展示重新拍照的提示
        setState(() {});
      }
    }else{
      restart = true;//展示重新拍照的提示
      setState(() {});
    }
  }
  Widget getRestartAlert(){
    if(restart){
      return new Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
            children: <Widget>[
              new Text(
                "身份证识别失败，重新采集识别?",
                style: TextStyle(color: Colors.black26,fontSize: 18.0),
              ),
              IconButton(
                icon: Icon(
                  Icons.subdirectory_arrow_right,
                  color: Colors.blueAccent,
                ),
                onPressed:toRestartIdentify() ,),
            ]
        ),
      );
    }else{
      return new Container(
        height: 1.0,
        width: 1.0,
        color: Colors.black,
        alignment: Alignment.bottomLeft,
      );
    }
  }
  toRestartIdentify(){
    restart = true;
    photoPath = null;
    setState(() {});
    restart = false;

  }
}
class IdentifyCardPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showNextPage(context),
    );
  }
  showNextPage(BuildContext context) async {
    // await getIdentifyCardDemo(context);
  }
}
/*class IdentifyCardIndex extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IdentifyCard(),
    );
  }
}*/

List<CameraDescription> cameras;

/*getIdentifyCardDemo(BuildContext context) async {//Future<void>
// Fetch the available cameras before initializing the app.
  try {
    cameras = await availableCameras();
    FlutterImageCompress.showNativeLog = true;
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  Navigator.push<Map>(context, new MaterialPageRoute(
      builder: (BuildContext context) {
        return new IdentifyCardIndex();
      })).then((Map result) {
    if(result != null){
      Navigator.pop(context,result);
      print(result);
    }
  });
  return Container();
  //runApp(IdentifyCardIndex());
  //return new IdentifyCardIndex();
}*/
/*------------------------------------------------*/
bool showProgressDialog = false;
bool restart = false;
var photoPath = null;

Future<File> getCompressImage(File file, String targetPath) async {
  var path = file.absolute.path;
  var result = await FlutterImageCompress.compressAndGetFile(
    path, targetPath,
    quality: 88,
    rotate: 180,
  );

  print(file.lengthSync());
  print(result.lengthSync());

  return result;

}
Future<String> getTempDir() async {
  var dir = await path_provider.getTemporaryDirectory();
  var targetPath = dir.absolute.path + "/temp.png";
  return targetPath;
}


Widget getProgressDialog(){
  if(showProgressDialog){
    return new Container(
      color: Colors.black12,
      alignment: Alignment.center,
      child: SpinKitFadingCircle(color: Colors.blueAccent),
    );
  }else{
    return new Container(
      height: 1.0,
      width: 1.0,
      color: Colors.black,
      alignment: Alignment.bottomLeft,
    );
  }
}

Widget getPhotoPreview(){
  if( null != photoPath){
    return new Container(
      width:double.infinity,
      height: double.infinity,
      color: Colors.black,
      alignment: Alignment.center,
      child: Image.file(File(photoPath)),
    );
  }else{
    return new Container(
      height: 1.0,
      width: 1.0,
      color: Colors.black,
      alignment: Alignment.bottomLeft,
    );
  }
}

