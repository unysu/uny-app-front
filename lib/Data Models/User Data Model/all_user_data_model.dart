import 'package:json_annotation/json_annotation.dart';
import 'package:uny_app/Data%20Models/User%20Data%20Model/user_data_model.dart';

import '../Interests Data Model/interests_data_model.dart';
import '../Media Data Model/media_data_model.dart';


@JsonSerializable()
class AllUserDataModel{

  @JsonKey(name: 'success')
  bool? success;

  @JsonKey(name: 'user')
  UserDataModel? user;

  @JsonKey(name: 'media')
  MediaDataModel? media;

  @JsonKey(name: 'interests')
  List<InterestsDataModel>? interests;

  AllUserDataModel({this.success, this.user, this.media});

  AllUserDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    user = json['user'] != null ? UserDataModel.fromJson(json['user']) : null;
    media = json['media'] != null ? MediaDataModel.fromJson(json['media']) : null;
    if (json['interests'] != null) {
      interests = <InterestsDataModel>[];
      json['interests'].forEach((v) {
        interests!.add(InterestsDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (media != null) {
      data['media'] = media!.toJson();
    }
    if (interests != null) {
      data['interests'] = interests!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}