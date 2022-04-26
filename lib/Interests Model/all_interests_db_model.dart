import 'package:floor/floor.dart';

@Entity()
class AllInterestsModel{

  @PrimaryKey()
  int? id;

  String? name;

  String? color;

  AllInterestsModel(this.name, this.color);
  AllInterestsModel._(this.name, this.color);

  AllInterestsModel.ForDB(this.id, this.name, this.color);

  factory AllInterestsModel.fromMap(Map<String, dynamic> dataMap) {
    return AllInterestsModel._(
        dataMap['name'],
        dataMap['color']
    );
  }

  factory AllInterestsModel.fromJson(Map<String, dynamic> json) =>
      AllInterestsModel._(
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