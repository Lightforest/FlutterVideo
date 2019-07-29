
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter_app1/fast/constants/constant.dart';
import 'package:flutter_app1/third/agora/pages/videocall.dart';
import 'package:flutter_app1/fast/utils/empty.dart';

class AgoraUtils{

  static AgoraRtmClient _client;
  static VideoCallState _videoCallState;

  /// Agora 初始化
  static Future<AgoraRtmClient> getAgoraRtmClient() async {
    if(_client == null){
      _client =
      await AgoraRtmClient.createInstance(APPApiKey.Agora_app_id);
    }
    return _client;
  }

  /// 查询用户是否在线
  ///  true-在线  , false-离线
  static Future<bool> queryPeerOnlineStatus(AgoraRtmClient _client, String peerUid) async {
    if(EmptyUtil.textIsEmpty(peerUid)){
      return false;
    }else{
      try {
        Map<String, bool> result =
        await _client.queryPeersOnlineStatus([peerUid]);
        return result[peerUid];
      } catch (errorCode) {
        return false;
      }
    }
  }
  /// 获取声网的消息类型
  /// 1-请求视频通话
  /// 2-取消请求通话
  /// 3-拒绝通话请求
  static String getAgoraMsgType(int type){
    switch(type){
      case 1:
        return "CALLVIDEO";
      case 2:
        return "CANCEL_VIDEO";
      case 3:
        return "REFUSE_VIDEO";
      default:
        return "";
    }

  }
  /// 视频请求
  static set videoCallState(VideoCallState value) {
    _videoCallState = value;
  }
  /// 视频请求
  static VideoCallState get videoCallState => _videoCallState;

  static clearVideoCallState(){
    _videoCallState= null;
  }

}