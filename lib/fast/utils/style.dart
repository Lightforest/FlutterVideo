import 'package:flutter/material.dart';
import 'package:flutter_app1/fast/utils/value.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


//文本设置
class AppStyle{

  /*------------------------------------------------TextStyle-----------------------------------------------------*/
  /// 字体：#666  16
  static var inputTextKey1 = TextStyle(
    color: ThemeColors.color666666,
    fontSize: TextSize.add6,
  );

  /// 字体：#333  16
  static var inputText1 = TextStyle(
    color: ThemeColors.color333333,
    fontSize: TextSize.add6,
  );
  /// 字体：#333  16   w700
  static var itemTitleText1 = TextStyle(
      color: ThemeColors.color333333,
      fontSize: TextSize.add16,
      fontWeight: FontWeight.w700
  );
  /// 字体：#666  14
  static var dialogKeyText1 = TextStyle(
    color: ThemeColors.color666666,
    fontSize: TextSize.add4,
  );
  /// 字体：#666  12
  static var textStyle12_c6 = TextStyle(
    color: ThemeColors.color666666,
    fontSize: TextSize.add2,
  );
  /// 字体：#333  12
  static var textStyle12_c3 = TextStyle(
    color: ThemeColors.color333333,
    fontSize: TextSize.add2,
  );
  /// 字体：#666  16    w300
  static var dialogKeyText2 = TextStyle(
      color: ThemeColors.color666666,
      fontSize: TextSize.add6,
      fontWeight: FontWeight.w300
  );
  /// 字体：#333  24    w300
  static var dialogKeyText3 = TextStyle(
      color: ThemeColors.color333333,
      fontSize: TextSize.add14,
      fontWeight: FontWeight.w300
  );
  /// 字体：#333  14    w300
  static var dialogValueText1 = TextStyle(
      color: ThemeColors.color333333,
      fontSize: TextSize.add4,
      fontWeight: FontWeight.w300
  );
  /// 字体：#fff  18    w500
  static var buttonText1 = TextStyle(
      color: ThemeColors.colorWhite,
      fontSize: TextSize.add8,
      fontWeight: FontWeight.w500
  );
  /// 字体：#666  16    w300
  static var buttonText2 = TextStyle(
      color: ThemeColors.color666666,
      fontSize: TextSize.add6,
      fontWeight: FontWeight.w300
  );
  /*-----------------------------------------RoundedRectangleBorder-------------------------------------------------------------------------*/
  static var buttonStyle1 = RoundedRectangleBorder(
    side: BorderSide( // 保留原来的边框样式
      width: 0,
      color: ThemeColors.colorDDDDDD,
      style: BorderStyle.solid,
    ),
    borderRadius: BorderRadius.all(Radius.circular(50)),
  );
  /// button 圆角矩形（6）  边框（#999  宽-0.5）
  static var btnStyle_grey_line = RoundedRectangleBorder(
    side: BorderSide( // 保留原来的边框样式
      width: 0.5,
      color: ThemeColors.color999999,
      style: BorderStyle.solid,
    ),
    borderRadius: BorderRadius.all(Radius.circular(6)),
  );
  /*------------------------------------------BoxDecoration----------------------------------------------------------------------------*/
  /// layout 半椭圆（15.0）
  static var layoutStyle_noline =   new BoxDecoration(
    //border: new Border.all(color: Color(0xFFFF0000), width: 0.5), // 边色与边宽度
    color: ThemeColors.colorEEEEEE, // 底色
    borderRadius: new BorderRadius.circular((28.0)), // 圆角度
    //borderRadius: new BorderRadius.vertical(top: Radius.elliptical(20, 50)), // 也可控件一边圆角大小
  );
  /*-----------------------------------------------------------------------------------------------------------------*/
  static InputDecoration getSearchInputDec(String alert){
    return InputDecoration(
      hintText:alert ,// 提示文本内容
      border:InputBorder.none,
      fillColor: ThemeColors.transparent,//设置背景色
      filled: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),// 可控制高度
    );
  }
  static TextStyle getTextStyle_28_a(BuildContext c){
    return TextStyle(
      color: ThemeColors.colorAAA,// 文本（字体）颜色
      fontSize: ScreenUtil().setSp(TextSize.font_h),// 字体大小
    );
  }
  static TextStyle getTextStyle_32_3(BuildContext c){
    return TextStyle(
      color: ThemeColors.color333333,// 文本（字体）颜色
      fontSize: ScreenUtil().setSp(TextSize.font_xxh),// 字体大小
    );
  }
  static TextStyle getTextStyle_30_6(BuildContext c){
    return TextStyle(
      color: ThemeColors.color666666,// 文本（字体）颜色
      fontSize: ScreenUtil().setSp(TextSize.font_xh),// 字体大小
    );
  }
  static TextStyle getTextStyle_36_3(BuildContext c){
    return TextStyle(
      color: ThemeColors.color333333,// 文本（字体）颜色
      fontSize: ScreenUtil().setSp(TextSize.font_xxxh),// 字体大小
    );
  }
  static TextStyle getTextStyle_30_9(BuildContext c){
    return TextStyle(
      color: ThemeColors.color999999,// 文本（字体）颜色
      fontSize: ScreenUtil().setSp(TextSize.font_xh),// 字体大小
    );
  }
}

class WidgetDemoColor {
  static const int fontColor = 0xFF607173;
  static const int iconColor = 0xFF607173;
  static const int borderColor = 0xFFEFEFEF;

}
class Theme {

  /**
   * 登录界面，定义渐变的颜色
   */
 /* static const Color loginGradientStart = const Color(0xFFF9986B);
  static const Color loginGradientEnd = const Color(0xFFF7438C);*/

  static const Color loginGradientStart = const Color(0xFFD1EAAC);
  static const Color loginGradientEnd = const Color(0xFF51D7C9);

  static const LinearGradient primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}