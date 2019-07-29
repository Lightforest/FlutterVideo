class EmptyUtil{
  /// 判断字符串是否为空
  static bool textIsEmpty(String text){
    if(text == null){
      return true;
    }else if(text.length <= 0){
      return true;
    }else{
      return false;
    }
  }

  static bool listIsEmpty(List list){
    if(list == null){
      return true;
    }else if(list.isEmpty){
      return true;
    }else{
      return false;
    }
  }
}