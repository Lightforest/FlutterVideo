/// @Author: 一凨 
/// @Date: 2019-01-07 16:24:42 
/// @Last Modified by: 一凨
/// @Last Modified time: 2019-01-08 17:37:42

import 'dart:async';

import 'package:flutter_app1/fast/constants/database.dart';
import 'package:flutter_app1/fast/utils/sql.dart';


abstract class FriendInterface {
  String get name;
  String get sex;
  int get age;
  String get birthday;
  String get university;
  String get address;

}

class Friend implements FriendInterface {
  String name;
  String sex;
  int age;
  String birthday;
  String university;
  String address;

  Friend({this.name,this.sex,this.age,this.birthday,this.university,this.address});

  factory Friend.fromJSON(Map json){
    return Friend(
      name: json['name'],
      sex: json['sex'],
      age: json['age'],
      birthday: json['birthday'],
      university: json['university'],
      address: json['address'],

    );
  }

  Object toMap() {
    return {'name': name, 'sex': sex, 'age': age, 'birthday': birthday, 'university': university, 'address': address};
  }
}

class FriendControlModel {
  final String table = MyDataBase.DB_TABLE_FRIEND;
  Sql sql;

  FriendControlModel() {
    sql = Sql.setTable(table);
  }

  // 获取所有的收藏

  // 插入新收藏
  Future insert(Friend friend) {
    var result =
    sql.insert({'name': friend.name, 'sex': friend.sex, 'age': friend.age,
      'birthday': friend.birthday, 'university': friend.university, 'address': friend.address});
    return result;
  }

  // 获取全部的收藏
  Future<List<Friend>> getAllFriend() async {
    List list = await sql.getByCondition();
    List<Friend> resultList = [];
    list.forEach((item){
      print(item);
      resultList.add(Friend.fromJSON(item));
    });
    return resultList;
  }

  // 通过收藏名获取router
  Future getRouterByName(String name) async {
    List list = await sql.getByCondition(conditions: {'name': name});
    return list;
  }

  // 删除
  Future deleteByName(String name) async{
    return await sql.delete(name,'name');
  }
}
