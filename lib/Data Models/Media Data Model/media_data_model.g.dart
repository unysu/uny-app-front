// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaDataModel _$MediaDataModelFromJson(Map<String, dynamic> json) =>
    MediaDataModel(
      mainPhoto: json['main+'] == null
          ? null
          : MediaModel.fromJson(json['main+'] as Map<String, dynamic>),
      mainPhotosList: (json['main'] as List<dynamic>?)
          ?.map((e) => MediaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      otherPhotosList: (json['other'] as List<dynamic>?)
          ?.map((e) => MediaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MediaDataModelToJson(MediaDataModel instance) =>
    <String, dynamic>{
      'main+': instance.mainPhoto,
      'main': instance.mainPhotosList,
      'other': instance.otherPhotosList,
    };

MediaModel _$MediaModelFromJson(Map<String, dynamic> json) => MediaModel(
      id: json['id'],
      url: json['url'],
      type: json['type'],
      filter: json['filter'],
      thumbnail: json['thumbnail'],
    );

Map<String, dynamic> _$MediaModelToJson(MediaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'type': instance.type,
      'filter': instance.filter,
      'thumbnail': instance.thumbnail,
    };
