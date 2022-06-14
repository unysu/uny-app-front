import 'dart:core';

import 'package:floor/floor.dart';

@Entity()
class InterestsModel{

  @PrimaryKey(autoGenerate: true)
  int? id;

  String? name;

  String? type;

  String? color;


  InterestsModel(this.id, this.name, this.type, this.color);

  InterestsModel.ForDB(this.name, this.type, this.color);

  InterestsModel._(this.name, this.type, this.color);


  factory InterestsModel.fromMap(Map<String, dynamic> dataMap) {
    return InterestsModel._(
        dataMap['name'],
        dataMap['type'],
        dataMap['color']
    );
  }

  factory InterestsModel.fromJson(Map<String, dynamic> json) =>
      InterestsModel._(
          json['name'],
          json['type'],
          json['color']
      );

  Map<String, dynamic> toJson() {
    return {
      'name' : name,
      'type' : type,
      'color' : color
    };
  }

}