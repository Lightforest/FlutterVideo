import 'package:flutter_app1/fast/constants/user.dart';

class ConstantKey{
  static final  int camera_identify_face = 101;
  static final  int camera_identify_idcard = 101;
  static final  int camera_identify_ercode = 101;

  static final String IDCARD_NUM = "id_card_number";
  static final String IDCARD_NAME = "name";
  static final String Web_Identify_IDCard = "Identify_IDCard";
  //static final String Web_Identify_IDCard = "startIdentifyIDCard";
  static final String Web_Identify_Face = "Identify_Face";
  static final String Web_Identify_QRCode = "Identify_QRCode";
}

class APPApiKey{
  static final String Face_api_key = "yours";
  static final String Face_api_secret = "yours";

  static final String Jpush_app_key ="yours";
  static final String Agora_app_id = "yours";

}
class SharedKey{
  static final String USER_NAME = "user_name";

}
class ConstantObject{
  static User  mUser;
  static User getUser(){
    if(mUser == null){
      mUser = new User();
      mUser.agoraId = "Rose";
    }
    return mUser;
  }
}