import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

List<CameraDescription> cameras;

Future<void> getCameras(BuildContext context) async {
  cameras = await availableCameras();
  runApp(CameraApp());
//return _CameraAppState();
}

class CameraApp extends StatefulWidget {

  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;
  String imagePath;
  @override
  void initState() {
    super.initState();
    if(cameras != null){
      controller = CameraController(cameras[0], ResolutionPreset.medium);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return  new MaterialApp(

      home: new Scaffold(
        body: new Builder(builder:  (BuildContext context){
          return Container(
            child: AspectRatio(
                aspectRatio:
                controller.value.aspectRatio,
                child: CameraPreview(controller)),
            foregroundDecoration: BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('assets/images/bg_identify_head.png'),
                fit: BoxFit.scaleDown,
              ),
            ),
          );


//          return new Scaffold(
//            body: AspectRatio(
//                aspectRatio:
//                controller.value.aspectRatio,
//                child: CameraPreview(controller)),
//            /*floatingActionButton:new FloatingActionButton(
//              foregroundColor: Colors.white,
//              elevation: 10.0,
//              onPressed: () {},
//              child: new Image.asset('assets/images/bg_identify_head.png'),
//            ),
//            floatingActionButtonLocation:FloatingActionButtonLocation.centerFloat,*/
//          );


        }),
        floatingActionButton: new FloatingActionButton(
          foregroundColor: Colors.white,
          elevation: 10.0,
          onPressed: controller != null &&
              controller.value.isInitialized &&
              !controller.value.isRecordingVideo
              ? onTakePictureButtonPressed
              : null,
          child: new Image.asset('assets/images/ic_take_photo.png'),
        ),
        floatingActionButtonLocation:FloatingActionButtonLocation.centerFloat,
      ),
    );
/*return AspectRatio(
        aspectRatio:
        controller.value.aspectRatio,
        child: CameraPreview(controller));*/
  }
  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
//videoController?.dispose();
//videoController = null;
        });
        if (filePath != null) showInSnackBar('Picture saved to $filePath');
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
      showInSnackBar(e.toString());
      return null;
    }
    return filePath;
  }
  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
//showInSnackBar('Error: select a camera first.');
      Fluttertoast.showToast(msg: "'Error: select a camera first.");
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
// A recording is already started, do nothing.
      return null;
    }

    try {
//videoPath = filePath;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
//_showCameraException(e);
      return null;
    }
    return filePath;
  }
}