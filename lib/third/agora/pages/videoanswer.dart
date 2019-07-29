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

class VideoAnswerPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;
  final String firendName;
  VideoAnswerState videoAnswerState;
  AgoraRtmClient _client;
  /// 接听视频邀请
  /// 参数（视频通道id，好友名称）
  VideoAnswerPage(this.channelName, this.firendName,this._client);

  @override
  VideoAnswerState createState() {
    videoAnswerState = new VideoAnswerState();
    return videoAnswerState;
  }
}

class VideoAnswerState extends State<VideoAnswerPage> {
  static const _methodChannel1 = const MethodChannel(MethodChannelUtils.channelMedia);
  static final _sessions = List<VideoSession>();
  final _infoStrings = <String>[];
  BuildContext mcontext;
  var APP_ID = APPApiKey.Agora_app_id;
  bool muted = false;
  /// 视频是否成功接通
  bool videoSuccess = false;
  /// 拒绝通话
  bool isClosedByOne = false;
  /// 主窗口展示自己？
  /// true 自己   false 好友
  bool mainWindowShowOneself = true;
  int _count = 0;
  Timer _timer;


  @override
  void dispose() {
    // clean up native views & destroy sdk
    try {
      if(_sessions != null && _sessions.length > 0){
        _sessions.forEach((session) {
          AgoraRtcEngine.removeNativeView(session.viewId);
        });
        _sessions.clear();
      }
      AgoraRtcEngine.leaveChannel();
      stopPlay();
      if(!isClosedByOne && !videoSuccess){
        /// 视频没有接通前自己挂断，则需要通知对方，我已拒绝
        _initSendMessage();
      }
      stopTimer();
    } catch (e) {
      print(e);
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize third.agora sdk
    initialize();
    startPlay();
  }
  void startPlay(){
    _methodChannel1.invokeListMethod(MethodChannelUtils.methodStartMedia);
  }
  void stopPlay(){
    _methodChannel1.invokeListMethod(MethodChannelUtils.methodStopMedia);
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

    _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    // use _addRenderView everytime a native video view is needed
    _addRenderView(0, (viewId) {
      AgoraRtcEngine.setupLocalVideo(viewId, VideoRenderMode.Hidden);
      AgoraRtcEngine.startPreview();
      // state can access widget directly
      // AgoraRtcEngine.joinChannel(null, widget.channelName, null, 0);// 修改为点击接听按钮后再接通
    });
  }
  Future<void> _initSendMessage() async{
    /*-------收到消息--------*/
    try {
      String msg = AgoraUtils.getAgoraMsgType(3);
      await widget._client.sendMessageToPeer(widget.firendName, AgoraRtmMessage(msg));
    } catch (e) {
      print(e);
    }
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
    /// 有其他用户加入到视频中的回调
    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        String info = 'userJoined: ' + uid.toString();
        //setState(() { videoSuccess = true; });
        _infoStrings.add(info);
        videoSuccess = true;
        startTimer();
        _addRenderView(uid, (viewId) {
          AgoraRtcEngine.setupRemoteVideo(viewId, VideoRenderMode.Hidden, uid);
        });
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        try {
          /*String info = 'userOffline: ' + uid.toString();
          _infoStrings.add(info);
          _removeRenderView(uid);*/
          onCallEnd(mcontext);
        } catch (e) {
          print(e);
        }
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
    try {
      return _sessions.firstWhere((session) {
        return session.uid == uid;
      });
    } catch (e) {
      return null;
    }
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
                child: Text(" 视图 ",
                  style: TextStyle(
                    color: ThemeColors.transparent,
                    fontSize: 20.0,
                  ),
                ),
              )
            ],)
        ),
      ),
    );
  }
  /// 未接通视频前的一层遮罩
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

  /// Toolbar layout
  Widget _toolbar() {
    if(videoSuccess){
      return _answerSuccessToolbar();
    }else{
      return _waitAnswerToolbar();
    }
  }
  /// 通话时的工具栏
  Widget _answerSuccessToolbar(){
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(vertical: 48),

      child:Container(
        height: 100.0,
        child: Column(children: <Widget>[
          Container(
            height: 20.0,
            margin: EdgeInsets.only(bottom:10.0),
            child: Text(DateTimeUtil.getHMmmss_Seconds(_count),
                style: TextStyle(
                  color: ThemeColors.colorWhite,
                  fontSize: 16,
                )),
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
  /// 响铃时的工具栏
  Widget _waitAnswerToolbar(){
    return  Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () => _onCancelAnswer(context),
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
            onPressed: () => _onAnswerVideo(),
            child: new Icon(
              Icons.call_received,
              color: Colors.white,
              size: 35.0,
            ),
            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.green,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }
  /// 好友的信息视图
  Widget _friendInfo() {
    return Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.all(15),
        child: Offstage(
            offstage: videoSuccess,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.firendName,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: ThemeColors.colorWhite,
                    fontSize: 25,
                  ),
                ),
                Text(
                  "邀请你进行视频通话",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: ThemeColors.colorWhite,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],)
        )
    );
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
  /// 当点击接受应答
  void _onAnswerVideo() {
    try {
      stopPlay();
      AgoraRtcEngine.joinChannel(null, widget.channelName, null, 0);
    } catch (e) {
      print(e);
    }
  }
  /// 当点击取消应答
  void _onCancelAnswer(BuildContext context) {
    Navigator.pop(context);
  }
  /// 退出视频页面，停止视频
  void onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }
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
          title: Text('Agora Flutter QuickStart'),
        ),
        backgroundColor: Colors.black,
        body: Center(
            child: Stack(
              children: <Widget>[_viewRows(),_smallWindow(),_mask(), _toolbar(),_friendInfo()],//_panel(),
            )));
  }
  Widget _emptyView(){
    return Container(
      width: 1.0,
      height: 1.0,
    );
  }
}

