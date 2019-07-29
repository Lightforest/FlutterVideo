class DateTimeUtil{
  /// 获取时间，格式为HH:mm:ss(时分秒)
  /// param1- seconds:总秒数
  static String getHMmmss_Seconds(int seconds){
    int h = 0,m = 0,s = 0;String result = "";
    if(seconds <= 59){
      return "00:"+getDoubleStr(seconds);
    }else{
      m = seconds~/60;
      s = seconds % 60;
      if(m <= 59){
        return getDoubleStr(m)+":"+getDoubleStr(s);
      }else{
        h = m ~/ 60;
        m = m % 60;
        return getDoubleStr(h)+":"+getDoubleStr(m)+":"+getDoubleStr(s);
      }
    }
  }
  static String getDoubleStr(int num){
    try {
      if(num < 10){
        return "0"+num.toString();
      }else{
        return num.toString();
      }
    } catch (e) {
      return "00";
    }
  }

}