
import 'package:floor/floor.dart';

@Entity()
class CareerInterestsModel{

  @PrimaryKey()
  int? id;

  String? name;

  String? color;

  CareerInterestsModel(this.id, this.name, this.color);
  CareerInterestsModel._(this.name, this.color);


  factory CareerInterestsModel.fromMap(Map<String, dynamic> dataMap) {
    return CareerInterestsModel._(
        dataMap['name'],
        dataMap['color']
    );
  }

  factory CareerInterestsModel.fromJson(Map<String, dynamic> json) =>
      CareerInterestsModel._(
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