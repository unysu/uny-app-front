// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDataModel _$UserDataModelFromJson(Map<String, dynamic> json) =>
    UserDataModel(
      success: json['success'],
      token: json['token'],
      phoneNumber: json['phone_number'],
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      location: json['location'],
      dateOfBirth: json['date_of_birth'],
      aboutMe: json['about_me'],
      gender: json['gender'],
    );

Map<String, dynamic> _$UserDataModelToJson(UserDataModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'token': instance.token,
      'phone_number': instance.phoneNumber,
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'location': instance.location,
      'date_of_birth': instance.dateOfBirth,
      'about_me': instance.aboutMe,
      'gender': instance.gender,
    };
