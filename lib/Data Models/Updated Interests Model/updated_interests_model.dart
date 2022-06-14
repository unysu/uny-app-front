import 'package:json_annotation/json_annotation.dart';

import '../Interests Data Model/interests_data_model.dart';

part 'updated_interests_model.g.dart';

@JsonSerializable()
class UpdatedInterestsModel{

  @JsonKey(name: 'success')
  var success;

  @JsonKey(name: 'all_interests')
  List<InterestsDataModel>? interests;

  UpdatedInterestsModel({
    this.success,
    this.interests
  });

  factory UpdatedInterestsModel.fromJson(Map<String, dynamic> json) => _$UpdatedInterestsModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatedInterestsModelToJson(this);
}