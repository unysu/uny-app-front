import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:uny_app/Data%20Models/Chats%20Data%20Model/all_chats_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class SocketSettings{


  WebSocketChannel? _channel;
  Stream? _socketBroadcastStream;

  static final SocketSettings _instance = SocketSettings._internal();


  factory SocketSettings.init(){
    return _instance;
  }


  SocketSettings._internal() {
    _channel = WebSocketChannel.connect(Uri.parse('ws://ec2-54-163-55-135.compute-1.amazonaws.com/socket'));
    _socketBroadcastStream = _channel!.stream.asBroadcastStream();
  }


  Stream? getStream() => _socketBroadcastStream;

  void joinRoom(String participantId){
    var bytes = utf8.encode(participantId);
    String idHash = sha256.convert(bytes).toString();

    var data = {
      'join' : idHash
    };

    _channel!.sink.add(jsonEncode(data));
  }

  void sendMessage(String chatRoomId, Message msg){
    var bytes = utf8.encode(chatRoomId);
    String idHash = sha256.convert(bytes).toString();

    var data = {
      'room' : idHash,
      'msg' : jsonEncode(msg)
    };

    _channel!.sink.add(jsonEncode(data));
  }

  void editMessage(String chatRoomId, Message msg){
    var bytes = utf8.encode(chatRoomId);
    String idHash = sha256.convert(bytes).toString();

    var data = {
      'room' : idHash,
      'edited_message' : jsonEncode(msg)
    };

    _channel!.sink.add(jsonEncode(data));
  }

  void removeMessageForEveryone(String chatRoomId, String id){
    var bytes = utf8.encode(chatRoomId);
    String idHash = sha256.convert(bytes).toString();

    var data = {
      'room' : idHash,
      'deleted_message_id' : id
    };

    _channel!.sink.add(jsonEncode(data));
  }

  void clearChat(String chatRoomId, bool isChatCleared){
    var bytes = utf8.encode(chatRoomId);
    String idHash = sha256.convert(bytes).toString();

    var data = {
      'room' : idHash,
      'clear_chat' : isChatCleared
    };

    _channel!.sink.add(jsonEncode(data));
  }

  void closeSocket(){
    _channel!.sink.close();
  }
}
