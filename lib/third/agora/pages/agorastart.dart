import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/third/agora/pages/index.dart';
import 'package:flutter_app1/third/agora/pages/index2.dart';
import 'package:flutter_app1/third/agora/pages/index3.dart';
import 'package:flutter_app1/fast/utils/value.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AgoraStartPage extends StatefulWidget {
  @override
  createState() => new AgoraStartState();
}

class AgoraStartState extends State<AgoraStartPage> {

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
    return Column(children: <Widget>[
      Container(
          width: double.infinity,
          height: 50,
          margin:  const EdgeInsets.fromLTRB(20,30,20,0),
          child: RaisedButton(
            onPressed: (){
              try{
                Navigator.push(context, new MaterialPageRoute(
                    builder: (BuildContext context) {
                      return new IndexPage();
                    }));
              }catch(e){
                print(e.toString());
              }
            },
            // 文本内容
            child: Text("官方视频通话示例"),
            // 按钮颜色
            color: ThemeColors.colorTheme,
          )),
      Container(
          width: double.infinity,
          height: 50,
          margin:  const EdgeInsets.fromLTRB(20,30,20,0),
          child: RaisedButton(
            onPressed: (){
              try{
                Navigator.push(context, new MaterialPageRoute(
                    builder: (BuildContext context) {
                      return new AgoraRTMPage();
                    }));
              }catch(e){
                print(e.toString());
              }
            },
            // 文本内容
            child: Text("官方信令系统示例"),
            // 按钮颜色
            color: ThemeColors.colorTheme,
          )),
      Container(
          width: double.infinity,
          height: 50,
          margin:  const EdgeInsets.fromLTRB(20,30,20,0),
          child: RaisedButton(
            onPressed: (){
              try{
                Navigator.push(context, new MaterialPageRoute(
                    builder: (BuildContext context) {
                      return new AgoraCustomPage();
                    }));
              }catch(e){
                print(e.toString());
              }
            },
            // 文本内容
            child: Text("自定义视频通话示例（运用以上两个插件）"),
            // 按钮颜色
            color: ThemeColors.colorTheme,
          )),
    ]);
  }
}