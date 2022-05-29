// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaDataModel _$MediaDataModelFromJson(Map<String, dynamic> json) =>
    MediaDataModel(
      id: json['id'],
      url: json['url'],
      type: json['type'],
      filter: json['filter'],
      updatedAt: json['updated_at'],
    );

Map<String, dynamic> _$MediaDataModelToJson(MediaDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'type': instance.type,
      'filter': instance.filter,
      'updated_at': instance.updatedAt,
    };
