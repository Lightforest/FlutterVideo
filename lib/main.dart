import 'package:agora_rtm/agora_rtm.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app1/fast/constants/constant.dart';
import 'package:flutter_app1/fast/constants/user.dart';
import 'package:flutter_app1/fast/routers/routers.dart';
import 'package:flutter_app1/fast/utils/provider.dart';
import 'package:flutter_app1/home/page/database/dbdemo.dart';
import 'package:flutter_app1/home/page/dialog/dialogdemo.dart';
import 'package:flutter_app1/home/page/webview/mywebview.dart';
import 'package:flutter_app1/start/like_button_demo.dart';
import 'package:flutter_app1/start/login.dart';
import 'package:flutter_app1/start/titlebardemo.dart';
import 'package:flutter_app1/third/agora/pages/agorastart.dart';
import 'package:flutter_app1/third/agora/pages/videoanswer.dart';
import 'package:flutter_app1/third/agora/utils/agora_utils.dart';
import 'package:flutter_app1/third/jpush/jpushpage.dart';
import 'package:flutter_app1/fast/utils/empty.dart';
import 'package:flutter_app1/fast/utils/value.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:orientation/orientation.dart';
import 'package:shared_preferences/shared_preferences.dart';

var db;
Future main() async {
  try {
    final provider = new Provider();
    await provider.init(true);
    db = Provider.db;
  } catch (e) {
    print(e);
  }
  OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
  runApp(new MyApp());
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "引导页",
      theme: new ThemeData(
        primarySwatch: ThemeColors.colorTheme,
      ),
      home: new MyHomePage(),
    );
  }

}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);


  @override
  MyAppState createState() => new MyAppState();
}
class MyAppState extends State<MyHomePage> with WidgetsBindingObserver{

  final JPush jpush = new JPush();
  AppLifecycleState appLifecycleState;
  String debugLable = 'Unknown';
  BuildContext c;
  var widgetsBinding;

  @override
  void initState() {
    super.initState();
    setState(() {});
    initAgoraRtm();
    widgetsBinding=WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback){
      getUserName();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Flutter练习"),
      ),
      body: showNextPage(),
    );
  }
  showNextPage(){
    return mainMenu();
  }
  Widget mainMenu(){
    return Builder(
        builder: (context) => Container(
          width:double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child:Stack(children: <Widget>[
              GridView.count(
                crossAxisCount: 2,//一行的Widget数量
                childAspectRatio:2,//宽高比
                children: <Widget>[
                  getRaisedButton("WebView 示例",context),
                  getRaisedButton("JiGuang推送 示例",context),
                  getRaisedButton("Agora视频通话 示例",context),
                  getRaisedButton("数据库 示例",context),
                  getRaisedButton("dialog 示例",context),
                  getRaisedButton("适配 示例",context),
                  getRaisedButton("登录 示例",context),
                  getRaisedButton("状态栏颜色渐变",context),
                  getRaisedButton("推特点赞特效",context),
                ],),
              _buildLogin()
            ],),
          ),
        ));
  }
  Widget getRaisedButton(String text,BuildContext context){
    c = context;
    return Container(
      width: double.infinity,
      margin:  const EdgeInsets.all(10),
      child: RaisedButton(
        onPressed: (){
          if(text.contains("WebView")){
            _onClickWebview(context);
          }else if(text.contains("JiGuang")){
            _onClickJiGuang(context);
          }else if(text.contains("Agora")){
            _onClickAgoraVideo(context);
          }else if(text.contains("数据库")){
            _onClickDatabase(context);
          }else if(text.contains("dialog")){
            _onClickDialog(context);
          }else if(text.contains("适配")){
            _onClickAdaptive(context);
          }else if(text.contains("登录")){
            _onClickLogin(context);
          }else if(text.contains("状态栏")){
            _onClickStausBar(context);
          }else if(text.contains("点赞")){
            _onClickGiveLike(context);
          }
        },
        // 文本内容
        child: Text(text),
        // 按钮颜色
        color: ThemeColors.colorTheme,
        // 按钮亮度
        colorBrightness: Brightness.dark,
        // 高亮时的背景色
        //highlightColor: Colors.yellow,
        // 失效时的背景色
        disabledColor: Colors.grey,
        // 该按钮上的文字颜色，但是前提是不设置字体自身的颜色时才会起作用
        textColor: Colors.black,
        // 按钮失效时的文字颜色，同样的不能使用文本自己的样式或者颜色时才会起作用
        disabledTextColor: Colors.grey,
        // 按钮主题,主要用于与ButtonTheme和ButtonThemeData一起使用来定义按钮的基色,RaisedButton，RaisedButton，OutlineButton，它们是基于环境ButtonTheme配置的
        //ButtonTextTheme.accent，使用模版颜色的;ButtonTextTheme.normal，按钮文本是黑色或白色取决于。ThemeData.brightness;ButtonTextTheme.primary，按钮文本基于。ThemeData.primaryColor.
        textTheme: ButtonTextTheme.normal,
        // 按钮内部,墨汁飞溅的颜色,点击按钮时的渐变背景色，当你不设置高亮背景时才会看的更清楚
        splashColor: Colors.blueAccent,
        // 抗锯齿能力,抗锯齿等级依次递增,none（默认),hardEdge,antiAliasWithSaveLayer,antiAlias
        clipBehavior: Clip.antiAlias,
        padding:EdgeInsets.only(bottom: 5.0, top: 5.0, left: 30.0, right: 30.0),// 等同于 EdgeInsets.fromLTRB(30.0,5.0, 30.0, 5.0),
        /* shape:  Border.all(
          // 设置边框样式
          color: Colors.grey,
          width: 2.0,
          style: BorderStyle.solid,
        ),*/
      ),);
  }
  /// 跳入webview的示例页面
  void _onClickWebview(BuildContext context){
    try{
      Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) {
            return new MyWebview();
          }));
    }catch(e){
      print(e.toString());
    }
  }
  /// 跳入极光页面
  void _onClickJiGuang(BuildContext context){
    try{
      Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) {
            return new JPushPage();
          }));
    }catch(e){
      print(e.toString());
    }
  }
  /// 跳入声网视频的页面
  void _onClickAgoraVideo(BuildContext context){
    try{
      Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) {
            return new AgoraStartPage();
          }));
    }catch(e){
      print(e.toString());
    }
  }
  /// 跳入数据库示例的页面
  void _onClickDatabase(BuildContext context){
    try{
      Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) {
            return new MyDBPage();
          }));
    }catch(e){
      print(e.toString());
    }
  }
  /// 跳入各种dialog示例的页面
  void _onClickDialog(BuildContext context){
    try{
      Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) {
            return new MyDialogPage();
          }));
    }catch(e){
      print(e.toString());
    }
  }
  /// 跳入适配示例的页面
  void _onClickAdaptive(BuildContext context){
    /*try{
      Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) {
            return new MyAdaptivePage();
          }));
    }catch(e){
      print(e.toString());
    }*/
  }
  /// 跳入自定义登录的页面
  void _onClickLogin(BuildContext context){
    try{
      Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) {
            return new LoginPage();
          }));
    }catch(e){
      print(e.toString());
    }
  }
  /// 状态栏颜色渐变
  void _onClickStausBar(BuildContext context){
    try {
      Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) {
            return new TitleBarGradient();
          }));
    } catch (e) {
      print(e);
    }
  }
  /// 点赞特效的按钮
  void _onClickGiveLike(BuildContext context){
    try{
      Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) {
            return new LikeButtonDemo();
          }));
    }catch(e){
      print(e.toString());
    }
  }
  /*--------------------------声网初始化-----------------------------------*/

  bool _isLogin = false;
  bool _noProgress = true;

  final _userNameController = TextEditingController();
  static TextStyle textStyle = TextStyle(fontSize: 18, color: ThemeColors.colorTheme);
  Widget _buildLogin() {
    if(_isLogin){
      return new Container();
    }else{
      return Container(
          width: double.infinity,
          height: double.infinity,
          color: ThemeColors.colorWhite,
          alignment: Alignment.center,
          padding: EdgeInsets.all(20.0),
          child:Stack(children: <Widget>[
            Row(children: <Widget>[
              new Expanded(
                  child: new TextField(
                      controller: _userNameController,
                      decoration: InputDecoration(hintText: 'Input your user id'))),
              new OutlineButton(
                child: Text(_isLogin ? 'Logout' : 'Login', style: textStyle),
                onPressed: _toggleLogin,
              )
            ]),
            _ProgressDialog()
          ],)
      );
    }
  }
  /// 请求时的dialog
  Widget _ProgressDialog() {
    return Offstage(
      offstage: _noProgress,
      child:Container(
        color: ThemeColors.transparent,
        alignment: Alignment.center,
        child: SpinKitFadingCircle(color: ThemeColors.colorTheme),
      ) ,
    );
  }
  AgoraRtmClient _client;
  /// 收到通话请求时的响铃页面
  VideoAnswerPage answer;
  /// 声网RTM初始化、注册接收
  Future initAgoraRtm() async {
    // 初始化
    _client =await AgoraUtils.getAgoraRtmClient();
    // 设置消息接收器
    _client.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      if(!EmptyUtil.textIsEmpty(message.text)){
        // 收到视频请求，消息内容定义为： “CALLVIDEO,视频通道id”（请求者id接收者id）
        if(message.text.contains(AgoraUtils.getAgoraMsgType(1)) && message.text.contains(",")){
          try{
            String _channelName =message.text.split(",")[1];
            // 收到通话请求时的响铃页面
            answer = new VideoAnswerPage(_channelName,peerId,_client);
            // 跳到响铃页面
            // E/AGORA_SDK(13447): cannot open log file for writing: agorartm.log, err=30
             Navigator.push(c, new MaterialPageRoute(
                builder: (BuildContext context) {
                  return answer;
                }));
          }catch(e){
            print(e.toString());
          }
          // 收到消息：视频请求者取消了通话
        }else if(message.text.contains(AgoraUtils.getAgoraMsgType(2)) ){
          if(answer != null){
            answer.videoAnswerState.isClosedByOne = true;
            answer.videoAnswerState.onCallEnd(c);
          }
          // 对方拒绝了通话请求
        }else if(message.text.contains(AgoraUtils.getAgoraMsgType(3)) ){
          if(AgoraUtils.videoCallState != null){
            AgoraUtils.videoCallState.isClosedByOne = true;
            AgoraUtils.videoCallState.onCallEnd(c);
          }
        }
      }
    };
    _client.onConnectionStateChanged = (int state, int reason) {
      // _log('Connection state changed: ' +  state.toString() +  ', reason: ' + reason.toString());
      if (state == 5) {
        _client.logout();
      }
    };
  }


  /// 声网登录
  void _toggleLogin() async {
    if (!_isLogin) {
      // 获取输入框的user id（英文 || 数字）
      String userId = _userNameController.text;
      if (userId.isEmpty) {
        Fluttertoast.showToast(msg: "Please input your user id to login");
        return;
      }
      if(_client == null){
        return;
      }
      setState(() {
        _noProgress = false;
      });
      try {
        await _client.login(null, userId);
        setState(() {
          _noProgress = true;
          _isLogin = true;
        });
        //
        User user = new User();
        user.agoraId = userId;
        setUserName(userId);
        // 刷新用户信息
        ConstantObject.mUser = user;
        return;
      } catch (errorCode) {
        print(errorCode);
        setState(() {
          _noProgress = true;
        });
      }
      Fluttertoast.showToast(msg: "声网登录失败");
    }
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    appLifecycleState = state;
    // state:  null-无变化 ，0 - resumed, 1 - inactive, 2 - paused.
    //resumed 	可见并能相应用户的输入
    //inactive 	处在并不活动状态，无法处理用户相应
    //paused 	不可见并不能相应用户的输入，但是在后台继续活动中

  }
  SharedPreferences _preferences;
  /// 获取本地保存的用户名
  Future getUserName() async {
    if(_preferences == null){
      _preferences = await SharedPreferences.getInstance();
    }
    setState(() {
      _userNameController.text = _preferences.getString(SharedKey.USER_NAME);
    });
  }
  /// 将用户名保存到本地
  Future setUserName(String name) async {
    if(_preferences == null){
      _preferences = await SharedPreferences.getInstance();
    }
    _preferences.setString(SharedKey.USER_NAME, name);
  }
}
