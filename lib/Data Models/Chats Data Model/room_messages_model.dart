import 'package:json_annotation/json_annotation.dart';
import 'package:uny_app/Data%20Models/Chats%20Data%20Model/all_chats_model.dart';

part 'room_messages_model.g.dart';

@JsonSerializable()
class RoomMessagesModel{

  @JsonKey(name: 'success')
  var success;

  @JsonKey(name: 'messages')
  List<Message>? messages;

  RoomMessagesModel({this.success, this.messages});

  factory RoomMessagesModel.fromJson(Map<String, dynamic> json) => _$RoomMessagesModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoomMessagesModelToJson(this);
}