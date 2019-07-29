本demo主要展示声网视频通话在Flutter中的应用，其他部分可自行忽略。

APP成功运行需要注意以下几个步骤：

1.到声网官网注册账号，并申请APPKey。<br>
2.将申请的APP Key 配置到lib/fast/constants.dart/APPApiKey/Agora_app_id中。<br>
3.APP跑起来后自定义个userid登录，按以下步骤找到视频部分入口<br>
  
  Agora视频通话示例--自定义视频通话示例--输入好友id后，点击和好友通话即可

  ··“官方视频通话示例”为声网官方对于插件agora_rtc_engine的实现demo<br>
  ··“官方信令系统示例”为声网官方对于插件agora_rtm的实现demo<br>
  ··“自定义视频通话示例”则是本demo的重点，将以上两个插件结合实现视频的呼叫接听（群视频暂未实现）
