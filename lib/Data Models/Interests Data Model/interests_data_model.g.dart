// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interests_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InterestsDataModel _$InterestsDataModelFromJson(Map<String, dynamic> json) =>
    InterestsDataModel(
      id: json['id'],
      userId: json['user_id'],
      interest: json['interest'],
      type: json['type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      color: json['color'],
    );

Map<String, dynamic> _$InterestsDataModelToJson(InterestsDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'interest': instance.interest,
      'type': instance.type,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'color': instance.color,
    };
