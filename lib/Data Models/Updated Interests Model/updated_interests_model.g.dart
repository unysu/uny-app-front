// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updated_interests_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatedInterestsModel _$UpdatedInterestsModelFromJson(
        Map<String, dynamic> json) =>
    UpdatedInterestsModel(
      success: json['success'],
      interests: (json['all_interests'] as List<dynamic>?)
          ?.map((e) => InterestsDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UpdatedInterestsModelToJson(
        UpdatedInterestsModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'all_interests': instance.interests,
    };
