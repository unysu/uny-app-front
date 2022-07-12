import 'package:flutter/material.dart';


class ChatsDataProvider extends ChangeNotifier{

  final Map<int, String?> _lastMessagesMap = {};
  final Map<int, String?> _lastMessageTimeMap = {};

  Map<int, String?> get lastMessagesMap => _lastMessagesMap;
  Map<int, String?> get lastMessageTimeMap => _lastMessageTimeMap;

  void setLastMessage(int chatId, String? lastMessage){
    _lastMessagesMap.addAll({
      chatId : lastMessage
    });

    notifyListeners();
  }

  void setLastMessageTime(int chatId, String? lastMessageTime){
    _lastMessageTimeMap.addAll({
      chatId : lastMessageTime
    });
  }

  void clearChatData(int chatRoomId){
    _lastMessagesMap[chatRoomId] = null;
    _lastMessageTimeMap[chatRoomId] = null;

    notifyListeners();
  }
}