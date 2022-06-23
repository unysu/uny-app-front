// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_chats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllChatsModel _$AllChatsModelFromJson(Map<String, dynamic> json) =>
    AllChatsModel(
      success: json['success'],
      chats: (json['chats'] as List<dynamic>?)
          ?.map((e) => Chats.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AllChatsModelToJson(AllChatsModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'chats': instance.chats,
    };

Chats _$ChatsFromJson(Map<String, dynamic> json) => Chats(
      chatRoomId: json['chat_room_id'],
      participants: (json['participants'] as List<dynamic>?)
          ?.map((e) => Participants.fromJson(e as Map<String, dynamic>))
          .toList(),
      chatName: json['name'],
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatsToJson(Chats instance) => <String, dynamic>{
      'chat_room_id': instance.chatRoomId,
      'name': instance.chatName,
      'participants': instance.participants,
      'messages': instance.messages,
    };

Participants _$ParticipantsFromJson(Map<String, dynamic> json) => Participants(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      matchPercent: json['match_percent'],
      media: json['media'] == null
          ? null
          : MediaDataModel.fromJson(json['media'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ParticipantsToJson(Participants instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'match_percent': instance.matchPercent,
      'media': instance.media,
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      messageId: json['message_id'],
      userId: json['user_id'],
      text: json['text'],
      replyTo: json['reply_to'],
      isEdited: json['is_edited'],
      createdAt: json['created_at'],
      media: json['media'],
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'message_id': instance.messageId,
      'user_id': instance.userId,
      'text': instance.text,
      'reply_to': instance.replyTo,
      'is_edited': instance.isEdited,
      'created_at': instance.createdAt,
      'media': instance.media,
    };
