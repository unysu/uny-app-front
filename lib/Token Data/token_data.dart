import 'package:shared_preferences/shared_preferences.dart';

class TokenData{

  static var _sharedPreferences;

  static Future<SharedPreferences> init() async {
    return _sharedPreferences = await SharedPreferences.getInstance();
  }

  static void setUserToken(String token){
    _sharedPreferences.setString('user_token', token);
  }

  static String getUserToken() {
    if(_sharedPreferences.getString('user_token') != null) {
      String _token = _sharedPreferences.getString('user_token');
      return _token;
    }else{
      return '';
    }
  }

  static void clearToken(){
    _sharedPreferences.remove('user_token');
  }
}