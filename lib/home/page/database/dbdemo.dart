import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/fast/custom_widgets/myscrollview.dart';
import 'package:flutter_app1/fast/utils/dialog.dart';
import 'package:flutter_app1/fast/utils/empty.dart';
import 'package:flutter_app1/fast/utils/style.dart';
import 'package:flutter_app1/fast/utils/value.dart';
import 'package:flutter_app1/home/page/database/friend.dart';
import 'package:flutter_app1/ower/sets/update.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyDBPage extends StatefulWidget {

  @override
  createState() => new MyDBtate();
}

class MyDBtate extends State<MyDBPage> {
  FriendControlModel _friendControl = new FriendControlModel();
  ScrollController _listcontroller = ScrollController();
  final _nameController = TextEditingController();
  final _sexController = TextEditingController();
  final _ageController = TextEditingController();
  final _birthController = TextEditingController();
  final _universityController = TextEditingController();
  final _addressController = TextEditingController();
  final TextStyle _keyTextStyle =AppStyle.inputTextKey1;
  final TextStyle _valueTextStyle =AppStyle.inputText1;
  DateTime _date =  DateTime.now();
  List<Friend> _friends = new List();
  List<Friend> _tempfriends = new List();
  List<String> sexList = new List();
  double height1 = 50.0;
  double height2 = 40.0;
  bool _hideInfoBuild = true;

  @override
  void initState() {
    super.initState();
    init();
  }
  void init(){
    sexList.add("女");sexList.add("男");sexList.add("其他");
    setDataBase();
  }
  /// 获取数据库的朋友信息数据
  Future setDataBase() async {
    try {
      _friendControl.getAllFriend().then((list){
        if(!EmptyUtil.listIsEmpty(list)){
          setState(() {
            _friends.addAll(list);
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }
  /// 向数据库添加朋友
  void insertDB(Friend friend){
    // 插入操作
    try {
      _friendControl
          .insert(friend)
          .then((result) {
        print("数据库-增");
      });
    } catch (e) {
      print(e);
    }
  }
  /// 删除数据库中指定的朋友信息
  void deleteDB(Friend friend){
    // 插入操作
    _friendControl
        .deleteByName(friend.name)
        .then((result) {
      if (result > 0 ) {
        print('删除成功');
        Fluttertoast.showToast(msg: friend.name+"信息删除成功");
      }else{
        print('删除错误');
        Fluttertoast.showToast(msg: friend.name+"信息删除错误");
      }
    });
  }

  /// 获取朋友信息，并添加朋友
  void addFriend(){
    Friend friend = new Friend();
    if(EmptyUtil.textIsEmpty(_nameController.text)) _nameController.text = "暂无";
    if(EmptyUtil.textIsEmpty(_sexController.text)) _sexController.text = "暂无";
    if(EmptyUtil.textIsEmpty(_ageController.text)) _ageController.text = "暂无";
    if(EmptyUtil.textIsEmpty(_birthController.text)) _birthController.text = "暂无";
    if(EmptyUtil.textIsEmpty(_universityController.text)) _universityController.text = "暂无";
    if(EmptyUtil.textIsEmpty(_addressController.text)) _addressController.text = "暂无";
    friend.name = _nameController.text;
    friend.sex = _sexController.text;
    try {
      friend.age = int.parse(_ageController.text);
    } catch (e) {
      print(e);
    }
    friend.birthday = _birthController.text;
    friend.university = _universityController.text;
    friend.address = _addressController.text;
    insertDB(friend);
    setState(() {
      _hideInfoBuild = !_hideInfoBuild;
      _friends.clear();_friends.add(friend);_friends.addAll(_tempfriends);
    });
    _tempfriends.clear();_tempfriends.addAll(_friends);
    _listcontroller.jumpTo(_listcontroller.position.minScrollExtent);
  }
  /// 获取指定朋友，并删除朋友信息
  void deleteFriend(int  index){
    deleteDB(_friends[index]);
    _friends.removeAt(index);
    setState(() {
      _friends = _friends;
    });
  }
  /// 删除朋友时的确认提示框
  void showDelAlertDialog1(BuildContext context,int index) {
    CommonDialog commonDialog2 = CommonDialog(onPressedSure: (){
      deleteFriend(index);
    });
    commonDialog2.showAlertDialog(context,'确认删除'+_friends[index].name+'的信息吗？');
  }
  /// 选择日期控件
  void _selectDate(BuildContext context) {
    showDatePicker(context: context, initialDate: _date, firstDate: DateTime(_date.year-200,1), lastDate: _date)
        .then((picked){
      setState(() {
        _birthController.text = picked.year.toString()+"-"+picked.month.toString()+"-"+picked.day.toString();
      });
    }).catchError((onError){
      print(onError);
    });
  }

  /// 展示选择性别的dialog
  void _showSexDialog1(){
    if(!EmptyUtil.listIsEmpty(sexList)){
      new CommonDialog(onPressedOption: (result){
        setState(() {
          _sexController.text = result;
        });
      }).showOptionSimpleDialog(context, sexList);
    }
  }
  Widget _inputNameBuild(){
    return Container(
      height: height1,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Row(children: <Widget>[
        Text(
          "姓名：",
          style: _keyTextStyle,
        ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.centerLeft,
            child:TextField(
              controller: _nameController,
              style: _valueTextStyle,
              decoration: InputDecoration(
                //intText: "请输入好友名称",
                  hintText:"请输入好友名称" ,
                  border:InputBorder.none
              ),
            ),
          ),
        ),
      ]),
    );
  }
  Widget _inputSexBuild(){
    return Container(
      height: height1,
      child: Row(children: <Widget>[
        Text(
          "性别：",
          style: _keyTextStyle,
        ),
        Expanded(
          flex: 1,
          child: TextField(
            controller: _sexController,
            style: _valueTextStyle,
            onTap: _showSexDialog1,
            focusNode: new AlwaysDisabledFocusNode(),
            decoration: InputDecoration(
                hintText: "请选择好友性别",
                border:InputBorder.none
            ),
          ),
        ),
      ],),
    );
  }
  Widget _inputAgeBuild(){
    return Container(
      height: height1,
      child: Row(children: <Widget>[
        Text(
          "年龄：",
          style: _keyTextStyle,
        ),
        Expanded(
          flex: 1,
          child:TextField(
            keyboardType: TextInputType.number,
            controller: _ageController,
            style: _valueTextStyle,
            decoration: InputDecoration(
                hintText: "请输入好友年龄",
                border:InputBorder.none
            ),
          ),
        ),
      ],),
    );
  }
  Widget _inputBirthBuild(){
    return  Container(
      height: height1,
      child: Row(children: <Widget>[
        Text(
          "生日：",
          style: _keyTextStyle,
        ),
        Expanded(
          flex: 1,
          child: TextField(
            controller: _birthController,
            style: _valueTextStyle,
            focusNode: new AlwaysDisabledFocusNode(),
            onTap: (){
              _selectDate(context);
            },
            decoration: InputDecoration(
                hintText: "请选择好友生日",
                border:InputBorder.none
            ),
          ),
        ),
      ],),
    );
  }
  Widget _inputUniversityBuild(){
    return Container(
      height: height1,
      child: Row(children: <Widget>[
        Text(
          "毕业院校：",
          style: _keyTextStyle,
        ),
        Expanded(
          flex: 1,
          child:TextField(
            controller: _universityController,
            style: _valueTextStyle,
            decoration: InputDecoration(
                hintText: "请输入好友毕业院校",
                border:InputBorder.none
            ),
          ),
        ),

      ],),
    );
  }
  Widget _inputAddressBuild(){
    return  Container(
      height: height1,
      child: Row(children: <Widget>[
        Text(
          "现居住地：",
          style: _keyTextStyle,
        ),
        Expanded(
          flex: 1,
          child:TextField(
            controller: _addressController,
            style: _valueTextStyle,
            decoration: InputDecoration(
                hintText: "请输入好友现居住地",
                border:InputBorder.none
            ),
          ),
        ),
      ],),
    );
  }
  Widget _listviewBuild(){
    if( !EmptyUtil.listIsEmpty(_friends) ){
      return Container(
        margin: EdgeInsets.only(top: 0),color:ThemeColors.colorWhite,
        child:ListView.separated(
          controller: _listcontroller,
          shrinkWrap: true,//高度自适应
          //physics:NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: _friends.length, // item 的个数
          //itemCount: 20, // item 的个数
          separatorBuilder: (BuildContext context, int index) => Divider(height:1.0,color: ThemeColors.colorDDDDDD),  // 添加分割线
          itemBuilder: (BuildContext context, int index) {
            return _itemBuild(index);
          },
        ),
      );

    }else{
      return Container(
        height: 1.0,
        color: ThemeColors.transparent,
      );
    }
  }
  Widget _itemBuild(int index){
    return GestureDetector(
      onDoubleTap: (){
        showDelAlertDialog1(context,index);
        //deleteFriend(index);
      },
      child: Container(
        padding: EdgeInsets.all(20),
        color: ThemeColors.colorWhite,
        child: Column(children: <Widget>[
          Container(
            height: height2,
            alignment: Alignment.bottomLeft,
            child:Text(
              _friends[index].name,
              style: AppStyle.itemTitleText1,
            ),
          ),
          Container(
            height: height2,
            alignment: Alignment.bottomLeft,
            child: Row(children: <Widget>[
              Text(
                _friends[index].sex,
                style: AppStyle.inputTextKey1,
              ),
              Container(
                margin: EdgeInsets.only(left: 12),
                child:Text(
                  _friends[index].age.toString(),
                  style: AppStyle.inputTextKey1,
                ) ,
              ),
              Container(
                margin: EdgeInsets.only(left: 12),
                child:Text(
                  _friends[index].birthday,
                  style: AppStyle.inputTextKey1,
                ) ,
              ),
            ],),
          ),
          Container(
            height: height2,
            alignment: Alignment.bottomLeft,
            child:Text(
              _friends[index].university,
              style: AppStyle.inputTextKey1,
            ) ,
          ),
          Container(
            height: height2,
            alignment: Alignment.bottomLeft,
            child:Text(
              _friends[index].address,
              style: AppStyle.inputTextKey1,
            ) ,
          ),
        ],),
      ),
    );
  }
  Widget _line(){
    return Container(
      height: 1.0,
      //margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
      color: ThemeColors.colorF6F6F8,
    );
  }
  Widget _inputBuild(){
    return Offstage(
        offstage: _hideInfoBuild,
        child: ListViewDemo(
          children: <Widget>[
            Container(
              padding:EdgeInsets.all(20),
              color:ThemeColors.colorF6F6F8,
              child: Column(children: <Widget>[
                _inputNameBuild(),
                _line(),
                _inputSexBuild(),
                _line(),
                _inputAgeBuild(),
                _line(),
                _inputBirthBuild(),
                _line(),
                _inputUniversityBuild(),
                _line(),
                _inputAddressBuild(),
                _line(),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton.icon(
                    icon: Icon(Icons.add,color: ThemeColors.colorWhite,size: 20.0,),
                    label: Text("添加好友",style: AppStyle.buttonText1,),
                    color: ThemeColors.colorTheme,
                    shape: AppStyle.buttonStyle1,
                    onPressed: addFriend,
                  ),
                ),
              ],),
            ),
          ],
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('数据库'),
        ),
        backgroundColor: ThemeColors.colorSmokeWhite,
        body: Column(children: <Widget>[
          Container(
            height: 50.0,padding:EdgeInsets.fromLTRB(20,0,20,0),color: ThemeColors.colorF6F6F8,
            child: Container(
              color: ThemeColors.colorF6F6F8,
              child: Row(children: <Widget>[
                Text("编辑好友信息"),
                Expanded(
                  flex: 1,
                  child: Text(""),
                ),
                IconButton(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  color: ThemeColors.color666666,
                  icon: Icon(Icons.arrow_downward),
                  onPressed: (){
                    setState(() {
                      _hideInfoBuild = !_hideInfoBuild;
                    });
                  },
                ),
              ],),
            ),
          ),
          Expanded(
            flex: 1,
            child: Stack(
              children: <Widget>[
                /* ListViewDemo(children: <Widget>[
                      _listviewBuild(),// 列表展示布局
                    ],),*/
                _listviewBuild(),
                _inputBuild(),//输入信息布局
              ],//_panel(),
            ) ,
          )

        ],)
    );
  }
}
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}