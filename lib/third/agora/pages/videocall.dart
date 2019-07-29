import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app1/fast/constants/constant.dart';
import 'package:flutter_app1/third/agora/utils/agora_utils.dart';
import 'package:flutter_app1/third/agora/utils/videosession.dart';
import 'package:flutter_app1/fast/utils/MethodChannelUtils.dart';
import 'package:flutter_app1/fast/utils/datetime.dart';
import 'package:flutter_app1/fast/utils/empty.dart';
import 'package:flutter_app1/fast/utils/value.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class VideoCallPage extends StatefulWidget {
  /// 视频通道
  final String channelName;
  /// 好友的 agora Id
  final String firendName;

  VideoCallPage(this.channelName, this.firendName);

  /*/// Creates a call page with given channel name.
  const VideoCallPage({Key key, this.channelName, this.firendName}) : super(key: key);*/

  @override
  createState() => new VideoCallState();
}

class VideoCallState extends State<VideoCallPage> {
  /// 和android本地交互的通道
  static const _methodChannel1 = const MethodChannel(MethodChannelUtils.channelMedia);
  static final _sessions = List<VideoSession>();
  final _infoStrings = <String>[];
  BuildContext mcontext;
  AgoraRtmClient _client;
  /// 声网上获取的App ID
  var APP_ID = APPApiKey.Agora_app_id;
  bool muted = false;
  /// 视频是否成功接通
  bool videoSuccess = false;
  /// 发出视频请求但未接通时，自己取消通话
  bool isClosedByOne = false;
  /// 主窗口展示自己？
  /// true 展示自己   false 展示好友
  bool mainWindowShowOneself = true;
  /// 计时的数值
  int _count = 0;
  Timer _timer;

  @override
  void dispose() {
    // clean up native views & destroy sdk
    if(_sessions != null && _sessions.length > 0){
      _sessions.forEach((session) {
        AgoraRtcEngine.removeNativeView(session.viewId);
      });
      _sessions.clear();
    }
    AgoraRtcEngine.leaveChannel();

    // 停止播放响铃
    stopPlay();
    if(!isClosedByOne && !videoSuccess){
      /// 请求视频对方还未接听时，自己先取消，则需要通知对方，我已取消
      _initSendMessage();
    }
    stopTimer();
    AgoraUtils.clearVideoCallState();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize third.agora sdk
    initialize();// 初始化视频SDK
    startPlay();// 开始播放响铃
  }

  void initialize() {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings
            .add("APP_ID missing, please provide your APP_ID in settings.dart");
        _infoStrings.add("Agora Engine is not starting");
      });
      return;
    }

    _initAgoraRTM();// 信令系统
    _initAgoraRtcEngine();// 视频通话
    _addAgoraEventHandlers();
    // use _addRenderView everytime a native video view is needed
    _addRenderView(0, (viewId) {
      AgoraRtcEngine.setupLocalVideo(viewId, VideoRenderMode.Hidden);
      AgoraRtcEngine.startPreview();
      // state can access widget directly
      AgoraRtcEngine.joinChannel(null, widget.channelName, null, 0);
    });
  }
  /// 获取 AgoraRtmClient
  Future<void> _initAgoraRTM() async{
    _client =await AgoraUtils.getAgoraRtmClient();
    AgoraUtils.videoCallState = this;
  }
  /// 发送消息通知对方取消通话
  Future<void> _initSendMessage() async{
    String msg = AgoraUtils.getAgoraMsgType(2);
    await _client.sendMessageToPeer(widget.firendName, AgoraRtmMessage(msg));
  }
  /// Create third.agora sdk instance and initialze
  Future<void> _initAgoraRtcEngine() async {
    AgoraRtcEngine.create(APP_ID);
    AgoraRtcEngine.enableVideo();
  }

  /// Add third.agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (int code) {
      setState(() {
        String info = 'onError: ' + code.toString();
        _infoStrings.add(info);
      });
    };
    /// 成功加入某次视频的回调
    AgoraRtcEngine.onJoinChannelSuccess =
        (String channel, int uid, int elapsed) {
      setState(() {
        String info = 'onJoinChannel: ' + channel + ', uid: ' + uid.toString();
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
      });
    };
    /// 有其他用户（好友）成功加入到视频中的回调
    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        String info = 'userJoined: ' + uid.toString();
        //setState(() { videoSuccess = true; });
        _infoStrings.add(info);
        videoSuccess = true;// 成功开始视频通话
        stopPlay(); // 停止播放响铃
        startTimer(); // 开始通话计时
        _addRenderView(uid, (viewId) {
          AgoraRtcEngine.setupRemoteVideo(viewId, VideoRenderMode.Hidden, uid);
        });
      });
    };
    /// 好友退出通话
    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        /*String info = 'userOffline: ' + uid.toString();
        _infoStrings.add(info);
        _removeRenderView(uid);*/
        onCallEnd(mcontext);// 自己也退出
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame =
        (int uid, int width, int height, int elapsed) {
      setState(() {
        String info = 'firstRemoteVideo: ' +
            uid.toString() +
            ' ' +
            width.toString() +
            'x' +
            height.toString();
        _infoStrings.add(info);
      });
    };
  }

  /// Create a native view and add a new video session object
  /// The native viewId can be used to set up local/remote view
  void _addRenderView(int uid, Function(int viewId) finished) {
    Widget view = AgoraRtcEngine.createNativeView(uid, (viewId) {
      setState(() {
        _getVideoSession(uid).viewId = viewId;
        if (finished != null) {
          finished(viewId);
        }
      });
    });
    VideoSession session = VideoSession(uid, view);
    _sessions.add(session);
  }

  /// Remove a native view and remove an existing video session object
  void _removeRenderView(int uid) {
    VideoSession session = _getVideoSession(uid);
    if (session != null) {
      _sessions.remove(session);
    }
    AgoraRtcEngine.removeNativeView(session.viewId);
  }

  /// Helper function to filter video session with uid
  VideoSession _getVideoSession(int uid) {
    return _sessions.firstWhere((session) {
      return session.uid == uid;
    });
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    return _sessions.map((session) => session.view).toList();
  }

  /// Video view wrapper
  /// Expanded组件必须用在Row、Column、Flex内，并且从Expanded到封装它的Row、Column、Flex的路径必须只包括StatelessWidgets或StatefulWidgets组件(不能是其他类型的组件，像RenderObjectWidget，它是渲染对象，不再改变尺寸了，因此Expanded不能放进RenderObjectWidget)。
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video layout wrapper
  Widget _viewRows() {
    //List<Widget> views = _getRenderViews();
    List<Widget> views = new List();
    views.addAll(_getRenderViews());
    return _mainWindow(views);
  }

  /// 主窗口视图
  Widget _mainWindow(List<Widget> views){
    return GestureDetector(
      child: Container(
          child: Column(
            children: <Widget>[
              mainWindowShowOneself ?
              _videoView(views[0]) : _videoView(views[1])
            ],
          )),
    );
  }
  /// 右上角小窗口视图
  Widget _smallWindow() {
    //List<Widget> views = _getRenderViews();
    List<Widget> views = new List();
    if(!videoSuccess ){
      return _emptyView();
    }else {
      views.addAll(_getRenderViews());
      if( mainWindowShowOneself ){
        if(!EmptyUtil.listIsEmpty(views) && views.length > 1){
          return  _smallVideoView(views[1]);
        }else{
          return _emptyView();
        }
      }else {
        if(!EmptyUtil.listIsEmpty(views)){
          return _smallVideoView(views[0]);
        }else{
          return _emptyView();
        }
      }
    }
  }
  /// 右上角小窗口视图
  Widget _smallVideoView(Widget view){
    return GestureDetector(
      onTap: updateDoubleWindow,
      onDoubleTap: updateDoubleWindow,
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
            width: 80.0,
            height: 130.0,
            margin: EdgeInsets.all(20),
            color: ThemeColors.colorWhite,
            child:   Stack(children: <Widget>[
              Column(
                children: <Widget>[
                  _videoView(view)
                ],
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                color: ThemeColors.transparent,
                child: Text("  "),
              )
            ],)
        ),
      ),
    );
  }
  /// 未接通视频前的一层透明遮罩
  Widget _mask(){
    return Container(
      child:Offstage(
        offstage: videoSuccess,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: ThemeColors.transparent1,
        ),
      ) ,
    );
  }
  /// 响铃时的dialog
  Widget _ProgressDialog() {
    return Offstage(
      offstage: videoSuccess,
      child:Container(
        height: 25.0,
        color: ThemeColors.transparent,
        margin: EdgeInsets.only(top:110),
        alignment: Alignment.topCenter,
        child: SpinKitWave(color: ThemeColors.colorTheme),
      ) ,
    );
  }
  /// 视频界面底部的工具栏（静音、挂断、摄像头切换）
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(vertical: 48),
      child:Container(
        height: 100.0,
        child: Column(children: <Widget>[
          Offstage(
            offstage: !videoSuccess,//true -显示
            child: Container(
              height: 20.0,
              margin: EdgeInsets.only(bottom:10.0),
              child: Text(DateTimeUtil.getHMmmss_Seconds(_count),
                  style: TextStyle(
                    color: ThemeColors.colorWhite,
                    fontSize: 16,
                  )),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RawMaterialButton(
                onPressed: () => _onToggleMute(),
                child: new Icon(
                  muted ? Icons.mic : Icons.mic_off,
                  color: muted ? Colors.white : ThemeColors.colorTheme,
                  size: 20.0,
                ),
                shape: new CircleBorder(),
                elevation: 2.0,
                fillColor: muted ? ThemeColors.colorTheme : Colors.white,
                padding: const EdgeInsets.all(12.0),
              ),
              RawMaterialButton(
                onPressed: () => onCallEnd(context),
                child: new Icon(
                  Icons.call_end,
                  color: Colors.white,
                  size: 35.0,
                ),
                shape: new CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.redAccent,
                padding: const EdgeInsets.all(15.0),
              ),
              RawMaterialButton(
                onPressed: () => _onSwitchCamera(),
                child: new Icon(
                  Icons.switch_camera,
                  color: ThemeColors.colorTheme,
                  size: 20.0,
                ),
                shape: new CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(12.0),
              )
            ],
          ),
        ],),
      ) ,
    );
  }

  /// 好友的信息视图（名称）
  Widget _friendInfo() {
    return Container(
        height: 50.0,
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(top:60),
        child: Offstage(
          offstage: videoSuccess,
          child:   Text(
            widget.firendName,
            style: TextStyle(
              color: ThemeColors.colorWhite,
              fontSize: 26,
            ),
          ),
        )
    );
  }
  /// 退出通话
  void onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }
  /// 切换摄像头
  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }
  /// 开始播放自定义的响铃文件
  void startPlay(){
    _methodChannel1.invokeListMethod(MethodChannelUtils.methodStartMedia);
  }
  /// 停止播放响铃
  void stopPlay(){
    _methodChannel1.invokeListMethod(MethodChannelUtils.methodStopMedia);
  }
  /// 更换主窗口和小窗口的画面
  void updateDoubleWindow(){
    setState(() {
      mainWindowShowOneself = !mainWindowShowOneself;
    });
  }
  /// 开始计时
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    var callback = (timer) => {
    setState(() {
      _count++;// 秒数+1
    })
  };
    _timer = Timer.periodic(oneSec, callback);
  }
  /// 停止计时
  void stopTimer(){
    if(_timer != null){
      _timer.cancel();
    }
  }
  @override
  Widget build(BuildContext context) {
    mcontext = context;
    return Scaffold(
        appBar: AppBar(
          title: Text('Agora Flutter'),
        ),
        backgroundColor: Colors.black,
        body: Center(
            child: Stack(
              children: <Widget>[_viewRows(),_smallWindow(),_mask(),_ProgressDialog(), _toolbar(),_friendInfo()],//_panel(),
            )));
  }
  Widget _emptyView(){
    return Container(
      width: 1.0,
      height: 1.0,
    );
  }
}