// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_search_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoSearchDataModel _$PhotoSearchDataModelFromJson(
        Map<String, dynamic> json) =>
    PhotoSearchDataModel(
      success: json['success'],
      matches: (json['matches'] as List<dynamic>?)
          ?.map((e) => Matches.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PhotoSearchDataModelToJson(
        PhotoSearchDataModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'matches': instance.matches,
    };

Matches _$MatchesFromJson(Map<String, dynamic> json) => Matches(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      age: json['age'],
      gender: json['gender'],
      location: json['location'],
      zodiacSign: json['zodiac_sign'],
      dateOfBirth: json['date_of_birth'],
      aboutMe: json['about_me'],
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => InterestsDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      media: json['media'] == null
          ? null
          : MediaDataModel.fromJson(json['media'] as Map<String, dynamic>),
      matchPercent: json['match_percent'],
    );

Map<String, dynamic> _$MatchesToJson(Matches instance) => <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'age': instance.age,
      'gender': instance.gender,
      'location': instance.location,
      'zodiac_sign': instance.zodiacSign,
      'date_of_birth': instance.dateOfBirth,
      'match_percent': instance.matchPercent,
      'about_me': instance.aboutMe,
      'media': instance.media,
      'interests': instance.interests,
    };
