import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:uny_app/FCM%20Controller/fcm_client.dart';

class NotificationManager{

  static NotificationManager? _instance;


  static NotificationManager init(){
    if(_instance == null){
      return _instance = NotificationManager();
    }else{
      return _instance!;
    }
  }


  void notify(String sender, String profilePictureUrl, String msg, String chatId, String userId) async {
    var bytes = utf8.encode(chatId);
    String notificationJsonData = '{'
        '"notification" : {'
        '"body" : "$msg", '
        '"title" : "$sender", '
        '"sound" : "default"'
        '}, "to" : "/topics/${sha256.convert(bytes).toString()}", '
        '"data" : {"chatId" : "${sha256.convert(bytes).toString()}", "userId" : "$userId", "profilePicture" : "${profilePictureUrl.toString()}"}}';

    await FCMClient.create().notify(jsonDecode(notificationJsonData));
  }
}