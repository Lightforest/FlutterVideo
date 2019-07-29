
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app1/fast/utils/app.dart';
import 'package:flutter_app1/fast/utils/callback.dart';
import 'package:flutter_app1/fast/utils/style.dart';
import 'package:flutter_app1/fast/utils/value.dart';
import 'package:flutter_app1/ower/sets/update.dart';

class CommonDialog{
  PressedOptionCB onPressedOption;
  PressedSureCB onPressedSure;

  CommonDialog({this.onPressedOption,this.onPressedSure});

  /// 展示关于APP的dialog
  static void showAppAboutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) =>  AboutDialog(
            applicationName: AppHelper.app_name,
            applicationIcon:  Image.asset('assets/images/app_logo.png'),
            applicationVersion: AppHelper.app_version_name,
            children: <Widget>[
              Text(AppHelper.app_introduce)
            ]
        ));
  }
  /// 展示string列表选项的simpleDialog
  void showOptionSimpleDialog(
      BuildContext context,
      List<String> list) {
    showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return  SimpleDialog(
          children: <Widget>[
            ListView.builder(
                shrinkWrap: true,//高度自适应
                //physics:NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: list.length, // item 的个数
                //separatorBuilder: (BuildContext context, int index) => Divider(height:1.0,color: ThemeColors.colorDDDDDD),  // 添加分割线
                itemBuilder: (BuildContext context, int index)
                {
                  return SimpleDialogOption(
                    child:  Text(list[index]),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onPressedOption(list[index]);
                    },
                  );
                }
            ),],
        );
      },
    );
  }
  /// 展示提示信息，并确定或取消
  void showAlertDialog(BuildContext context,String alertStr) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // 表示是否点击空白区域关闭对话框,默认为true
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(alignment:Alignment.center,child: Text('温馨提示'),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(alertStr),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
                onPressedSure();
              },
            ),
            FlatButton(
              child: Text('取消',style: TextStyle(color: ThemeColors.color666666),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  /// 展示提示信息，并确定或取消
  void showToastDialog(BuildContext context,String alertStr) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(alertStr,textAlign: TextAlign.center,),
          actions: <Widget>[
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  /// 自定义的APP更新提示的dialog
  void showCustomUpdateDialog(BuildContext context,UpdatePojo update) {
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (context) {
          return StatefulBuilder(
              builder: (context, state) {
                return Dialog(
                    child:Container(
                      padding: EdgeInsets.all(16.0),
                      child:  Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 26),
                            child:Text('发现新版本',textAlign: TextAlign.center,style: AppStyle.dialogKeyText3,),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 12.0),
                            child:Row(children: <Widget>[
                              Text('应用    ',textAlign: TextAlign.left,style: AppStyle.dialogKeyText1),
                              Text(AppHelper.app_name,textAlign: TextAlign.left,style: AppStyle.dialogValueText1),
                            ],) ,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 12.0),
                            child:  Row(children: <Widget>[
                              Text('版本    ',textAlign: TextAlign.left,style: AppStyle.dialogKeyText1),
                              Text(update.versionName,textAlign: TextAlign.left,style: AppStyle.dialogValueText1),
                            ],),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 12.0),
                            child: Row(children: <Widget>[
                              Text('大小    ',textAlign: TextAlign.left,style: AppStyle.dialogKeyText1),
                              Text(update.versionSize,textAlign: TextAlign.left,style: AppStyle.dialogValueText1),
                            ],),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 12.0),
                            alignment: Alignment.centerLeft,
                            child:Text('详情',style: AppStyle.dialogKeyText2),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 12.0),
                            child: Text(update.versionIntroduce,textAlign: TextAlign.left,style: AppStyle.dialogValueText1),
                          ),
                          Row(children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(right: 12),
                                child: RaisedButton(
                                  shape: AppStyle.btnStyle_grey_line,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child:  Text("以后再说",style: AppStyle.buttonText2,),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(left: 12),
                                child: RaisedButton(
                                  color: ThemeColors.colorWhite,
                                  shape: AppStyle.btnStyle_grey_line,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    onPressedSure();
                                  },
                                  child:  Text("立即更新",style: AppStyle.buttonText2,),
                                ),
                              ),),
                          ],),
                        ],
                      ),
                    )

                );
              }
          );
        }
    );
  }
}