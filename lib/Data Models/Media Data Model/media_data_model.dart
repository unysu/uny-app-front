import 'package:json_annotation/json_annotation.dart';

part 'media_data_model.g.dart';

@JsonSerializable()
class MediaDataModel{

  @JsonKey(name: 'id')
  var id;

  @JsonKey(name: 'url')
  var url;

  @JsonKey(name: 'type')
  var type;

  @JsonKey(name: 'filter')
  var filter;

  @JsonKey(name: 'updated_at')
  var updatedAt;

  MediaDataModel({
    this.id,
    this.url,
    this.type,
    this.filter,
    this.updatedAt
  });

  factory MediaDataModel.fromJson(Map<String, dynamic> json) => _$MediaDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$MediaDataModelToJson(this);
}