import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';



@entity
class FamilyInterestsModel{

  @PrimaryKey()
  int? id;

  String? name;

  String? color;

  FamilyInterestsModel(this.id, this.name, this.color);
  FamilyInterestsModel._(this.name, this.color);

  factory FamilyInterestsModel.fromMap(Map<String, dynamic> dataMap) {
    return FamilyInterestsModel._(
      dataMap['name'],
      dataMap['color']
    );
  }

  factory FamilyInterestsModel.fromJson(Map<String, dynamic> json) =>
       FamilyInterestsModel._(
        json['name'],
        json['color']
      );

  Map<String, dynamic> toJson() {
    return {
      'name' : name,
      'color' : color
    };
  }

  static Map<String, dynamic> toMap(FamilyInterestsModel interestsModel) => {
    'name' : interestsModel.name,
    'color' : interestsModel.color
  };

}