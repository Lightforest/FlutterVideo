import 'package:flutter/material.dart';
import 'package:flutter_app1/fast/custom_widgets/myscrollview.dart';
import 'package:flutter_app1/start/sign_up_page.dart';
import 'package:random_pk/random_pk.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_app1/start/sign_in_page.dart';
import 'package:flutter_app1/fast/utils/style.dart' as theme;

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  PageController _pageController;
  PageView _pageView;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
    _pageView = new PageView(
      controller: _pageController,
      children: <Widget>[
        new SignInPage(),
        new SignUpPage(),
      ],
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      /**
       * SafeArea，让内容显示在安全的可见区域
       * SafeArea，可以避免一些屏幕有刘海或者凹槽的问题
       */
        body: new Container(
          /**这里要手动设置container的高度和宽度，不然显示不了
           * 利用MediaQuery可以获取到跟屏幕信息有关的数据
           */
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          //设置渐变的背景
          decoration: new BoxDecoration(
            gradient: theme.Theme.primaryGradient,
          ),
          child:ListViewDemo(
            children: <Widget>[
              new Container(
                /**这里要手动设置container的高度和宽度，不然显示不了
                 * 利用MediaQuery可以获取到跟屏幕信息有关的数据
                 */
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  //设置渐变的背景
                  decoration: new BoxDecoration(
                    gradient: theme.Theme.primaryGradient,
                  ),
                  child: Stack(children: <Widget>[
                    Container(
                      height: 200,
                      margin:EdgeInsets.only(top: 20),
                      alignment: Alignment.center,
                      child:  Image(//顶部图片
                          fit: BoxFit.fill,
                          width: 270,
                          image: new AssetImage("assets/images/login_logo.png")),
                    ),
                    new Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new SizedBox(
                          height: 160,
                        ),
                        /**
                         * 可以用SizeBox这种写法代替Padding：在Row或者Column中单独设置一个方向的间距的时候
                         */
//                    new Padding(padding: EdgeInsets.only(top: 75)),

                        //中间的Indicator指示器
                        new Container(
                          width: 220,
                          height: 42,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            color: Color(0x552B2B2B),
                          ),
                          child: new Row(
                            children: <Widget>[
                              Expanded(
                                  child: new Container(
                                    /**
                                     * TODO:暂时不会用Paint去自定义indicator，所以暂时只能这样实现了
                                     */
                                    decoration: _currentPage == 0
                                        ? BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(25),
                                      ),
                                      color: Colors.white,
                                    )
                                        : null,
                                    child: new Center(
                                      child: new FlatButton(
                                        onPressed: () {
                                          _pageController.animateToPage(0,
                                              duration: Duration(milliseconds: 500),
                                              curve: Curves.decelerate);
                                        },
                                        child: new Text(
                                          "Existing",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  )),
                              Expanded(
                                  child: new Container(
                                    decoration: _currentPage == 1
                                        ? BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(25),
                                      ),
                                      color: Colors.white,
                                    )
                                        : null,
                                    child: new Center(
                                      child: new FlatButton(
                                        onPressed: () {
                                          _pageController.animateToPage(1,
                                              duration: Duration(milliseconds: 500),
                                              curve: Curves.decelerate);
                                        },
                                        child: new Text(
                                          "New",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
//                      new SignInPage(),
//                      new SignUpPage(),
                        new Expanded(child: _pageView),
                      ],
                    )
                  ],)
              )
            ],
          ),
        )
    );
  }
}