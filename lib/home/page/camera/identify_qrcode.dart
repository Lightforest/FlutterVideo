import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app1/fast/constants/constant.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'camera_pojo.dart';

class IdentifyQRCode extends StatefulWidget {

  List<CameraDescription> _cameras;

  IdentifyQRCode(this._cameras){
    cameras = _cameras;
  }

  @override
  _IdentifyQRCodeState createState() {
    return _IdentifyQRCodeState();
  }
}


void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _IdentifyQRCodeState extends State<IdentifyQRCode> {
  CameraController controller;
  String imagePath;
  String videoPath;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;
  WidgetsBinding widgetsBinding;
  Timer timer;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(cameras != null && !cameras.isEmpty){
      onNewCameraSelected(cameras[0]);
    }
    timer = new Timer(const Duration(milliseconds: 3000), () {
      try {
        Navigator.pop(context);
      } catch (e) {

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: new Container(
            child: new Stack(children: <Widget>[
              new Container(
                child: _cameraPreviewWidget(),
              ),
              new Positioned(
                  child: new Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.fromLTRB(30, 50, 30, 50),
                    child:new Image.asset('assets/images/bg_identify_qrcode.png'),
                  )),
              new Positioned(
                  child: new Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(bottom: 6),
                    child: Text(
                        '眨眨眼，点点头',
                        style:TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 28.0,
                        )
                    ),
                  )),
            ]))
    );
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
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
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
          imagePath = filePath;
          videoController = null;
          videoController?.dispose();
        });
        if (filePath != null) {
          showInSnackBar('Picture saved to $filePath');
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
}


List<CameraDescription> cameras;



