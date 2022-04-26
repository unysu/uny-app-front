
import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';

@Entity()
class GeneralInterestsModel{

  @PrimaryKey()
  int? id;

  String? name;

  String? color;

  GeneralInterestsModel(this.id, this.name, this.color);
  GeneralInterestsModel._(this.name, this.color);

  factory GeneralInterestsModel.fromMap(Map<String, dynamic> dataMap) {
    return GeneralInterestsModel._(
        dataMap['name'],
        dataMap['color']
    );
  }

  factory GeneralInterestsModel.fromJson(Map<String, dynamic> json) =>
      GeneralInterestsModel._(
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