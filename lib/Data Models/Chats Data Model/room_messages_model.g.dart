// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_messages_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomMessagesModel _$RoomMessagesModelFromJson(Map<String, dynamic> json) =>
    RoomMessagesModel(
      success: json['success'],
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RoomMessagesModelToJson(RoomMessagesModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'messages': instance.messages,
    };
