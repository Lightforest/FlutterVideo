import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

///
///  create by zhoumaotuo on 2019/5/27
///

const double buttonSize = 40.0;

class LikeButtonDemo extends StatefulWidget {
  @override
  _LikeButtonDemoState createState() => _LikeButtonDemoState();
}

class _LikeButtonDemoState extends State<LikeButtonDemo> {
  @override
  Widget build(BuildContext context) {
    final int likeCount = 999;
    return Material(
        child: Column(children: <Widget>[
      AppBar(
        title: Text("Like Button Demo"),
      ),
      Expanded(
        child: GridView(
          children: <Widget>[
          new  LikeButton(
              size: buttonSize,
              likeCount: likeCount,
              countBuilder: (int count, bool isLiked, String text) {
                var color = isLiked ? Colors.pinkAccent : Colors.grey;
                Widget result;
                if (count == 0) {
                  result = Text(
                    "love",
                    style: TextStyle(color: color),
                  );
                } else
                  result = Text(
                    count >= 1000
                        ? (count / 1000.0).toStringAsFixed(1) + "k"
                        : text,
                    style: TextStyle(color: color),
                  );
                return result;
              },
              likeCountAnimationType: likeCount < 1000
                  ? LikeCountAnimationType.part
                  : LikeCountAnimationType.none,
              likeCountPadding: EdgeInsets.only(left: 15.0),
            ),
          new  LikeButton(
              size: buttonSize,
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
              likeCountPadding: EdgeInsets.only(left: 15.0),
            ),
          new  LikeButton(
              size: buttonSize,
              circleColor:
                  CircleColor(start: Color(0xff669900), end: Color(0xff669900)),
              bubblesColor: BubblesColor(
                dotPrimaryColor: Color(0xff669900),
                dotSecondaryColor: Color(0xff99cc00),
              ),
              likeBuilder: (bool isLiked) {
                return Icon(
                  Icons.adb,
                  color: isLiked ? Colors.green : Colors.grey,
                  size: buttonSize,
                );
              },
              likeCount: 665,
              likeCountAnimationType: LikeCountAnimationType.all,
              countBuilder: (int count, bool isLiked, String text) {
                var color = isLiked ? Colors.green : Colors.grey;
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
              likeCountPadding: EdgeInsets.only(left: 15.0),
            ),
          new  LikeButton(
              size: buttonSize,
              isLiked: null,
              circleColor: CircleColor(
                start: Colors.redAccent[100],
                end: Colors.redAccent[400],
              ),
              bubblesColor: BubblesColor(
                dotPrimaryColor: Colors.red[300],
                dotSecondaryColor: Colors.red[200],
              ),
              likeBuilder: (bool isLiked) {
                return Icon(
                  Icons.assistant_photo,
                  color: Colors.red,
                  size: buttonSize,
                );
              },
              likeCount: 888,
              countBuilder: (int count, bool isLiked, String text) {
                var color = Colors.red;
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
              likeCountPadding: EdgeInsets.only(left: 15.0),
            ),
          new  LikeButton(
              size: buttonSize,
              circleColor: CircleColor(
                  start: Colors.pinkAccent[200], end: Colors.pinkAccent[400]),
              bubblesColor: BubblesColor(
                dotPrimaryColor: Colors.lightBlue[300],
                dotSecondaryColor: Colors.lightBlue[200],
              ),
              likeBuilder: (bool isLiked) {
                return Icon(
                  Icons.insert_emoticon,
                  color: isLiked ? Colors.lightBlueAccent : Colors.grey,
                  size: buttonSize,
                );
              },
            ),
          new  LikeButton(
              size: buttonSize,
              isLiked: null,
              circleColor: CircleColor(
                start: Colors.grey[200],
                end: Colors.grey[400],
              ),
              bubblesColor: BubblesColor(
                dotPrimaryColor: Colors.grey[600],
                dotSecondaryColor: Colors.grey[200],
              ),
              likeBuilder: (bool isLiked) {
                return Icon(
                  Icons.cloud,
                  color: isLiked ? Colors.grey[900] : Colors.grey,
                  size: buttonSize,
                );
              },
              likeCount: 888,
              postion: Postion.left,
              countBuilder: (int count, bool isLiked, String text) {
                var color = Colors.grey;
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
              likeCountPadding: EdgeInsets.only(right: 15.0),
            ),
          new LikeButton(
            size: buttonSize,
            isLiked: false,//true-默认展示为彩色喜欢状态，false-默认展示位灰色不喜欢，null-默认彩色且每次点击都有动画
            /*circleColor: CircleColor(start: Color(0xFFFF3030), end: Color(0xFF008000)),
            bubblesColor:BubblesColor(
                dotPrimaryColor: Color(0xFF2F4F4F), dotSecondaryColor: Color(0xFF7B68EE),
            dotThirdColor: Color(0xFF0000FF),dotLastColor:Color(0xFFC71585) ),*/
            circleColor: CircleColor(start: Color(0xFFFF8321), end: Color(0xFFFF5722)),
            bubblesColor:BubblesColor(
                dotPrimaryColor: Color(0xFFF5642C ), dotSecondaryColor: Color(0xFFFFA500),
            dotThirdColor: Color(0xFFF5642C),dotLastColor:Color(0xFFFFA500) ),
              animationDuration:Duration(milliseconds: 1000),
            likeCount: 888,
            likeBuilder: (bool isLiked) {
              return Icon(
                Icons.thumb_up,
                color: isLiked ? Colors.deepOrange : Colors.grey,
                size: buttonSize,
              );
            },
            likeCountPadding: EdgeInsets.only(left: 15.0),
          ),
          //new AnimatedLoginButton,
          ],
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        ),
      )
    ]));
  }
}
