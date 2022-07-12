import 'package:json_annotation/json_annotation.dart';
import 'package:uny_app/Data%20Models/Media%20Data%20Model/media_data_model.dart';

part 'all_chats_model.g.dart';

@JsonSerializable()
class AllChatsModel{

  @JsonKey(name: 'success')
  var success;

  @JsonKey(name: 'chats')
  List<Chats>? chats;

  AllChatsModel({this.success, this.chats});

  factory AllChatsModel.fromJson(Map<String, dynamic> json) => _$AllChatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AllChatsModelToJson(this);
}


@JsonSerializable()
class Chats{

  @JsonKey(name: 'chat_room_id')
  var chatRoomId;

  @JsonKey(name: 'name')
  var chatName;

  @JsonKey(name: 'participants')
  List<Participants>? participants;

  @JsonKey(name: 'messages')
  List<Message>? messages;

  Chats({
    this.chatRoomId,
    this.participants,
    this.chatName,
    this.messages
  });

  factory Chats.fromJson(Map<String, dynamic> json) => _$ChatsFromJson(json);

  Map<String, dynamic> toJson() => _$ChatsToJson(this);
}

@JsonSerializable()
class Participants{

  @JsonKey(name: 'id')
  var id;

  @JsonKey(name: 'first_name')
  var firstName;

  @JsonKey(name: 'last_name')
  var lastName;

  @JsonKey(name: 'match_percent')
  var matchPercent;

  @JsonKey(name: 'mute')
  var mute;

  @JsonKey(name: 'media')
  MediaDataModel? media;

  Participants({
    this.id,
    this.firstName,
    this.lastName,
    this.matchPercent,
    this.media
  });

  factory Participants.fromJson(Map<String, dynamic> json) => _$ParticipantsFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantsToJson(this);
}


@JsonSerializable()
class Message{

  @JsonKey(name: 'message_id')
  var messageId;

  @JsonKey(name: 'user_id')
  var userId;

  @JsonKey(name: 'text')
  var text;

  @JsonKey(name: 'reply_to')
  var replyTo;

  @JsonKey(name: 'is_edited')
  var isEdited;

  @JsonKey(name: 'created_at')
  var createdAt;

  @JsonKey(name: 'media')
  var media;

  Message({
    this.messageId,
    this.userId,
    this.text,
    this.replyTo,
    this.isEdited,
    this.createdAt,
    this.media
  });

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
