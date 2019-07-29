import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/fast/utils/dialog.dart';
import 'package:flutter_app1/fast/utils/empty.dart';
import 'package:flutter_app1/fast/utils/value.dart';
import 'package:flutter_app1/ower/sets/update.dart';

class MyDialogPage extends StatefulWidget {

  @override
  createState() => new MyDialogState();
}

class MyDialogState extends State<MyDialogPage> {
  List<String> strList = new List();
  String alert = "";
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text('Dialog'),
        ),
        backgroundColor: ThemeColors.colorSmokeWhite,
        body:Column(children: <Widget>[
          Container(
              width: double.infinity,height: 50,
              margin:  const EdgeInsets.fromLTRB(20,30,20,0),
              child: RaisedButton(
                onPressed: (){
                  _showToastDialog();
                },
                // 文本内容
                child: Text("showToastDialog"),
                // 按钮颜色
                color: ThemeColors.colorTheme,
              )),
          Container(
              width: double.infinity,height: 50,
              margin:  const EdgeInsets.fromLTRB(20,30,20,0),
              child: RaisedButton(
                onPressed: (){
                  _showOptionSimpleDialog();
                },
                // 文本内容
                child: Text("showOptionSimpleDialog"),
                // 按钮颜色
                color: ThemeColors.colorTheme,
              )),
          Container(
              width: double.infinity,height: 50,
              margin:  const EdgeInsets.fromLTRB(20,30,20,0),
              child: RaisedButton(
                onPressed: (){
                  _showAlertDialog();
                },
                // 文本内容
                child: Text("showAlertDialog"),
                // 按钮颜色
                color: ThemeColors.colorTheme,
              )),
          Container(
              width: double.infinity,height: 50,
              margin:  const EdgeInsets.fromLTRB(20,30,20,0),
              child: RaisedButton(
                onPressed: (){
                  _showCustomUpdateDialog();
                },
                // 文本内容
                child: Text("showCustomUpdateDialog"),
                // 按钮颜色
                color: ThemeColors.colorTheme,
              )),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(alert,textAlign: TextAlign.center,),
            ),
          ),
        ],)
    );
  }
  void _showToastDialog(){
    new CommonDialog().showToastDialog(context, "您点击了：showToastDialog");
  }
  void _showOptionSimpleDialog(){
    if(EmptyUtil.listIsEmpty(strList)){
      strList.add("内科");
      strList.add("妇产科");
      strList.add("神经科");
      strList.add("耳鼻喉科");
      strList.add("外科");
    }
    new CommonDialog(onPressedOption: (result){
      setState(() {
        alert = "您选择了:$result";
      });
    }).showOptionSimpleDialog(context, strList);
  }
  void _showAlertDialog(){
    new CommonDialog(onPressedSure: (){
      setState(() {
        alert = "您已成功预约山西第一人民医院-神经科的明天下午的挂号";
      });
    }).showAlertDialog(context, "您确定要预约山西第一人民医院 神经科的明天下午的挂号吗？");
  }
  void _showCustomUpdateDialog(){
    new CommonDialog(onPressedSure: (){
      setState(() {
        alert = "正在更新...";
      });
    }).showCustomUpdateDialog(context,new UpdatePojo());
  }
}