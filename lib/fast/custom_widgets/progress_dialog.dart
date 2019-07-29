import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';//导入系统基础包


class ShowProgress extends StatefulWidget {
  ShowProgress(this.requestCallback);
  final Future<Null> requestCallback;//这里Null表示回调的时候不指定类型
  @override
  _ShowProgressState createState() => new _ShowProgressState();
}

class _ShowProgressState extends State<ShowProgress> {
  @override
  initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 10), () {//每隔10ms回调一次
      widget.requestCallback.then((Null) {//这里Null表示回调的时候不指定类型
        Navigator.of(context).pop();//所以pop()里面不需要传参,这里关闭对话框并获取回调的值
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }
}
////////////上面是对话框控件，下面是按钮控件/////////////////
class ClickEvent extends StatefulWidget{
  @override
  _ClickEventState createState() {
    return new _ClickEventState();
  }
}

getProgressDialog(){
  runApp(ClickEvent());
}
class _ClickEventState extends State<ClickEvent>{
  Future<Null> _myClick()  {
    return showDialog<Null>(
        context: context,
        barrierDismissible: true, // false表示必须点击按钮才能关闭
        child:new ShowProgress(_postData())//将网络请求的方法_postData作为参数传递给ShowProgress显示对话框
    );
  }
  var httpclient=new HttpClient();//获取http对象
  var url='https://api.github.com/';
  var response;
  //核心的网络请求方法
  _postData() async{
    var request = await httpclient.getUrl(Uri.parse(url));
    response = await request.close();
    //response=await httpclient.req(url);//发送网络请求，read()表示读取返回的结果，get()表示不读取返回的结果
    print('Response=$response');
   /* Map data= JSON.decode(response);
    var url1= data['current_user_url'];
    print('current_user_url:$url1');*/
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('网络请求'),
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Text('获取数据'),
          onPressed: _myClick),
    );
  }
}