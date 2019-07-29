import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/fast/constants/constant.dart';
import 'package:flutter_app1/fast/utils/permission.dart';
import 'package:flutter_app1/third/agora/pages/videocall.dart';
import 'package:flutter_app1/third/agora/utils/agora_utils.dart';
import 'package:flutter_app1/fast/utils/empty.dart';
import 'package:flutter_app1/fast/utils/value.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraCustomPage extends StatefulWidget {
  @override
  createState() => new AgoraCustomState();
}

class AgoraCustomState extends State<AgoraCustomPage> {
  TextEditingController _friendController = new TextEditingController();
  TextEditingController _groupController = new TextEditingController();
  String _channelName = "agora";
  AgoraRtmClient _client;

  @override
  void initState() {
    super.initState();
    initAgoraRtm();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("声网"),
      ),
      body: buildStartPage(),
    );
  }
  Widget buildStartPage(){
    return SingleChildScrollView(
      child: ConstrainedBox(// 添加额外为限制条件到child，如最小/大宽度、高度。。。
        constraints: BoxConstraints(
          minHeight: 120.0,
        ),
        child: Column(children: <Widget>[
          Container(
              width: double.infinity,
              margin:  const EdgeInsets.fromLTRB(20,30,20,0),
              child: TextField(
                controller: _friendController,
                autofocus: false,
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: '请输入好友id',
                  helperText: '请正确输入好友的id',
                ),
              )
          ),
          Container(
              width: double.infinity,
              height: 50,
              margin:  const EdgeInsets.fromLTRB(20,30,20,0),
              child: RaisedButton(
                onPressed: (){
                  clickFriendVideo();
                },
                // 文本内容
                child: Text("和好友视频通话"),
                // 按钮颜色
                color: ThemeColors.colorTheme,
              )),
          Container(
              width: double.infinity,
              margin:  const EdgeInsets.fromLTRB(20,30,20,0),
              child: TextField(
                controller: _groupController,
                autofocus: false,
                decoration: InputDecoration(
                  icon: Icon(Icons.group),
                  labelText: '请输入群id',
                  helperText: '请输入群视频的通道id',
                ),
              )
          ),
          Container(
              width: double.infinity,
              height: 50,
              margin:  const EdgeInsets.fromLTRB(20,30,20,0),
              child: RaisedButton(
                onPressed: (){
                  clickGroupVideo();
                },
                // 文本内容
                child: Text("加入群视频通话"),
                // 按钮颜色
                color: ThemeColors.colorTheme,
              )),
          /*GestureDetector(
            onTap: testTap,
            child:Align(
              alignment: Alignment.center,
              child: Container(
                  width: 100.0,
                  height: 50,
                  margin:  const EdgeInsets.fromLTRB(20,30,20,0),
                  color: ThemeColors.colorTheme,
                  child: Column(children: <Widget>[
                    Text("测试点击事件")
                  ],)
              ),
            ) ,
          ),*/
        ]),),
    );
  }
  void testTap(){
    Fluttertoast.showToast(msg: "点击响应");
  }
  Future clickFriendVideo() async {
    List<PermissionGroup> permissionList = [PermissionGroup.camera, PermissionGroup.microphone];
    bool getPerm = await PermissionUtil.handlePermission(permissionList);
    if(getPerm){
      if(EmptyUtil.textIsEmpty(_friendController.text)){
        Fluttertoast.showToast(msg: "Friend id cannot be empty");
      }else{
        _callVideo(_friendController.text);
      }
    }else{
      Fluttertoast.showToast(msg: "请授权相关权限");
    }
  }
  Future _callVideo(String peerId) async {

    if(_client != null){
      bool online =await AgoraUtils.queryPeerOnlineStatus(_client, peerId);
      if(online){
        try{
          _channelName = ConstantObject.getUser().agoraId+peerId;
          String msg = AgoraUtils.getAgoraMsgType(1)+","+_channelName;
          await _client.sendMessageToPeer(peerId, AgoraRtmMessage(msg));
          Navigator.push(context, new MaterialPageRoute(
              builder: (BuildContext context) {
                return new VideoCallPage(_channelName,peerId);
              }));
        }catch(e){
          print(e.toString());
        }
      }else{
        Fluttertoast.showToast(msg: "The friend is offline");
      }
    }
  }
  void clickGroupVideo(){
    if(EmptyUtil.textIsEmpty(_groupController.text)){
      Fluttertoast.showToast(msg: "Group id cannot be empty");
    }else{

    }
  }
  Future initAgoraRtm() async {
    _client =await AgoraUtils.getAgoraRtmClient();
  }
}