import 'package:flutter/material.dart';
import 'package:uny_app/Data%20Models/Chats%20Data%20Model/all_chats_model.dart';

class ChatsDataProvider extends ChangeNotifier{

  List<Chats>? _allRoomsList;
  List<Chats>? get allRoomsList => _allRoomsList;


  Map<int, List<Message>> _roomMessages = {};
  Map<int, List<Message>> get roomMessages => _roomMessages;


  void setAllRooms(List<Chats> _rooms){
    this._allRoomsList = _rooms;

    notifyListeners();
  }

  void setRoomMessages(Map<int, List<Message>> _messagesMap){
    this._roomMessages.addAll(_messagesMap);

    notifyListeners();

  }

  void updateMessage(int chatId, int messageId, String newText){
    List<Message> messagesList = this._roomMessages[chatId]!.toList();

    int index = messagesList.indexWhere((element) => element.messageId == messageId);

    messagesList[index].text = newText;

    this._roomMessages.update(messageId, (value) => messagesList);

    notifyListeners();
  }

  void removeMessage(int chatId, int messageId){
    this.roomMessages.removeWhere((key, value) => key == chatId && value == messageId);

    notifyListeners();
  }
}