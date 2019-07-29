import 'package:flutter/material.dart';
import 'package:flutter_app1/fast/custom_widgets/custom_titlebar.dart';
class TitleBarGradient extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _TitleBarGradientState();
  }
}
class _TitleBarGradientState extends State<TitleBarGradient> {
  ScrollController _mScrollController = new ScrollController();
  GlobalKey<CustomTitleBarState>_mTitleKey = new GlobalKey();
  CustomTitleBarController _mCustomTitleBarController = new CustomTitleBarController();
  bool _isNeedSetAlpha = false;
  @override
  void initState() {
    super.initState();
    _mCustomTitleBarController.value.alpha = 0;
    _mScrollController.addListener(() {
      if (_mScrollController.offset < 80.0) {
        _isNeedSetAlpha = true;
        _mCustomTitleBarController.value.alpha =
            ((_mScrollController.offset / 80) * 255).toInt();
        _mTitleKey.currentState.setState(() {});
      } else {
        if (_isNeedSetAlpha) {
          _mCustomTitleBarController.value.alpha = 255;
          _mTitleKey.currentState.setState(() {});
          _isNeedSetAlpha = false;
        }
      }
    });
  }
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new Container(
            height: MediaQuery.of(context).size.height,
            child: new Listener(
              onPointerDown: (dd) {},
              onPointerMove: (sss) {},
              onPointerUp: (ss) {},
              onPointerCancel: (s) {},
              child: new SingleChildScrollView(
                controller: _mScrollController,
                child: new Column(
                  children: <Widget>[
                    new Container(
                      color: Colors.red,
                      height: 200.0,
                      child: new Center(child: new Text("内容1"),),
                    ),
                    new Container(
                      height: 200.0,
                      child: new Center(child: new Text("内容2"),),
                    ),
                    new Container(
                      height: 200.0,
                      child: new Center(child: new Text("内容3"),),
                    ),
                    new Container(
                      height: 200.0,
                      child: new Center(child: new Text("内容4"),),
                    ),
                    new Container(
                      height: 200.0,
                      child: new Center(child: new Text("dasdasdasdasd"),),
                    ), new Container(
                      height: 200.0,
                      child: new Center(child: new Text("dasdasdasdasd"),),
                    ), new Container(
                      height: 200.0,
                      child: new Center(child: new Text("dasdasdasdasd"),),
                    )
                  ],
                ),
              ),
            ),
          ),
          new CustomTitleBar(
            height: 80.0,
            controller: _mCustomTitleBarController,
            key: _mTitleKey,
          ),
        ],
      ),
    );
  }
  /*Widget _buildCustomBtn(){
    return LikeButton(
      size: 60,
      circleColor:
      CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
      bubblesColor: BubblesColor(
        dotPrimaryColor: Color(0xff33b5e5),
        dotSecondaryColor: Color(0xff0099cc),
      ),
      likeBuilder: (bool isLiked) {
        return Icon(
          Icons.home,
          color: isLiked ? Colors.deepPurpleAccent : Colors.grey,
          size: buttonSize,
        );
      },
      likeCount: 665,
      countBuilder: (int count, bool isLiked, String text) {
        var color = isLiked ? Colors.deepPurpleAccent : Colors.grey;
        Widget result;
        if (count == 0) {
          result = Text(
            "love",
            style: TextStyle(color: color),
          );
        } else
          result = Text(
            text,
            style: TextStyle(color: color),
          );
        return result;
      },
    );

  }*/
  /*Future<bool> onLikeButtonTap(bool isLiked, TuChongItem item) {
    ///send your request here
    ///
    final Completer<bool> completer = new Completer<bool>();
    Timer(const Duration(milliseconds: 200), () {
      item.isFavorite = !item.isFavorite;
      item.favorites =
      item.isFavorite ? item.favorites + 1 : item.favorites - 1;

      // if your request is failed,return null,
      completer.complete(item.isFavorite);
    });
    return completer.future;
  }*/

}
