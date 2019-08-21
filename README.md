# 声网视频通话在Flutter中的应用

  APP成功运行需要注意以下几个步骤：

  1.到声网官网注册账号，并申请APPKey。<br>
  2.将申请的APP Key 配置到lib/fast/constants.dart/APPApiKey/Agora_app_id中。<br>
  3.APP跑起来后自定义个userid登录，按以下步骤找到视频部分入口<br>
  （若想先跳过登录步骤，可将main.dart文件中的变量_isLogin设为true）
  
  Agora视频通话示例--自定义视频通话示例--输入好友id后，点击和好友通话即可

  ··“官方视频通话示例”为声网官方对于插件agora_rtc_engine的实现demo<br>
  ··“官方信令系统示例”为声网官方对于插件agora_rtm的实现demo<br>
  ··“自定义视频通话示例”则是本demo的重点，将以上两个插件结合实现视频的呼叫接听（群视频暂未实现）
  
  
# 自定义相机
  
  自定义相机的实现和webview加载html的功能在一起，按以下步骤运行APP：
  
  
  1.将main.dart文件中的变量_isLogin设为true<br>
  2.APP跑起来后点击WebView示例，进入百度HTML页面（mywebview.dart），等待三秒即会自动跳入自定义识别身份证的相机页面（调用了方法`startIdentifyIDCard(context)`）。<br>
  3.进入各个自定义相机页面的入口都在mywebview.dart文件中
  
  lib\home\page\camera\identify_card.dart （自定义识别身份证的相机页面）     
  lib\home\page\camera\identify_face.dart （自定义识别人脸的相机页面）  
  lib\home\page\camera\identify_qrcode.dart （自定义扫描二维码的相机页面）  
  
 
 
 
 
# 注意
 
  *本demo没有完整核验bug，只供部分参考*
 
