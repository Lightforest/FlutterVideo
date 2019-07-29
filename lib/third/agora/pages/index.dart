import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import './call.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new IndexState();
  }
}

class IndexState extends State<IndexPage> {
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();

  /// if channel textfield is validated to have error
  bool _validateError = false;

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Agora Flutter QuickStart'),
        ),
        body: Center(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 400,
              child: Column(
                children: <Widget>[
                  Row(children: <Widget>[]),
                  Row(children: <Widget>[
                    Expanded(
                        child: TextField(
                          controller: _channelController,
                          decoration: InputDecoration(
                              errorText: _validateError
                                  ? "Channel name is mandatory"
                                  : null,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(width: 1)),
                              hintText: 'Channel name'),
                        ))
                  ]),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              onPressed: () => onJoin(),
                              child: Text("Join"),
                              color: Colors.blueAccent,
                              textColor: Colors.white,
                            ),
                          )
                        ],
                      ))
                ],
              )),
        ));
  }

  onJoin() async {
    // update input validation
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      bool getP =  await _handleCameraAndMic();

      // push video page with given channel name
      if(getP){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new CallPage(
                  channelName: _channelController.text,
                )));
      }
    }
  }
  List<PermissionGroup> permissionList = [PermissionGroup.camera, PermissionGroup.microphone];
  Future<bool> _handleCameraAndMic() async {
    bool getPerm = false;

    for(PermissionGroup p in permissionList){
      /// 检查权限
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(p);
      if(permission == PermissionStatus.granted){
        getPerm = true;
      }else{
        /// 请求权限
        Map<PermissionGroup, PermissionStatus> permissions =await PermissionHandler()
            .requestPermissions([p]);
        if(permissions[p] == PermissionStatus.granted){
          getPerm = true;
        }else{
          getPerm = false;
          break;
        }
      }
    }
    return getPerm;
  }
}
