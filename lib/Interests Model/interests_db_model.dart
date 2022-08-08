import 'dart:core';

import 'package:floor/floor.dart';

@Entity()
class InterestsModel{

  @PrimaryKey(autoGenerate: true)
  int? id;

  String? name;

  String? type;

  String? startColor;

  String? endColor;


  InterestsModel(this.id, this.name, this.type, this.startColor, this.endColor);

  InterestsModel.ForDB(this.name, this.type, this.startColor, this.endColor);

  InterestsModel._(this.name, this.type, this.startColor, this.endColor);


  factory InterestsModel.fromMap(Map<String, dynamic> dataMap) {
    return InterestsModel._(
        dataMap['name'],
        dataMap['type'],
        dataMap['start_color'],
        dataMap['end_color']
    );
  }

  factory InterestsModel.fromJson(Map<String, dynamic> json) =>
      InterestsModel._(
          json['name'],
          json['type'],
          json['start_color'],
          json['end_color']
      );

  Map<String, dynamic> toJson() {
    return {
      'name' : name,
      'type' : type,
      'start_color' : startColor,
      'end_color' : endColor
    };
  }

}