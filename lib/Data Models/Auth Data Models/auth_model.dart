import 'package:json_annotation/json_annotation.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthModel{

  @JsonKey(name: 'success')
  var success;

  @JsonKey(name: 'msg')
  var msg;

  AuthModel({
    this.success,
    this.msg
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => _$AuthModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthModelToJson(this);
}