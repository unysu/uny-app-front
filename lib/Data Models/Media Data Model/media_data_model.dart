import 'package:json_annotation/json_annotation.dart';

part 'media_data_model.g.dart';

@JsonSerializable()
class MediaDataModel{

  @JsonKey(name: 'main+')
  MediaModel? mainPhoto;

  @JsonKey(name: 'main')
  List<MediaModel>? mainPhotosList;

  @JsonKey(name: 'other')
  List<MediaModel>? otherPhotosList;

  MediaDataModel({
    this.mainPhoto,
    this.mainPhotosList,
    this.otherPhotosList
  });

  factory MediaDataModel.fromJson(Map<String, dynamic> json) => _$MediaDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$MediaDataModelToJson(this);
}


@JsonSerializable()
class MediaModel{

  @JsonKey(name: 'id')
  var id;

  @JsonKey(name: 'url')
  var url;

  @JsonKey(name: 'type')
  var type;

  @JsonKey(name: 'filter')
  var filter;

  @JsonKey(name: 'thumbnail')
  var thumbnail;

  MediaModel({
    this.id,
    this.url,
    this.type,
    this.filter,
    this.thumbnail
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) => _$MediaModelFromJson(json);

  Map<String, dynamic> toJson() => _$MediaModelToJson(this);
}