import 'package:json_annotation/json_annotation.dart';

part 'interests_data_model.g.dart';

@JsonSerializable()
class InterestsDataModel{

  @JsonKey(name: 'id')
  var id;

  @JsonKey(name: 'user_id')
  var userId;

  @JsonKey(name: 'interest')
  var interest;

  @JsonKey(name: 'type')
  var type;

  @JsonKey(name: 'created_at')
  var createdAt;

  @JsonKey(name: 'updated_at')
  var updatedAt;

  @JsonKey(name: 'start_color')
  var startColor;

  @JsonKey(name: 'end_color')
  var endColor;

  InterestsDataModel({
    this.id,
    this.userId,
    this.interest,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.startColor,
    this.endColor
  });


  factory InterestsDataModel.fromJson(Map<String, dynamic> json) => _$InterestsDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$InterestsDataModelToJson(this);
}