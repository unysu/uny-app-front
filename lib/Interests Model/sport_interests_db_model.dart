
import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';

@entity
class SportInterestsModel{

  @PrimaryKey()
  int? id;

  String? name;

  String? color;

  SportInterestsModel(this.id, this.name, this.color);
  SportInterestsModel._(this.name, this.color);

  factory SportInterestsModel.fromMap(Map<String, dynamic> dataMap) {
    return SportInterestsModel._(
        dataMap['name'],
        dataMap['color']
    );
  }

  factory SportInterestsModel.fromJson(Map<String, dynamic> json) =>
      SportInterestsModel._(
          json['name'],
          json['color']
      );

  Map<String, dynamic> toJson() {
    return {
      'name' : name,
      'color' : color
    };
  }
}