import 'package:permission_handler/permission_handler.dart';

class PermissionUtil{
  /// 检查并请求权限  param-权限列表
  static Future<bool> handlePermission(List<PermissionGroup> permissionList) async {
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