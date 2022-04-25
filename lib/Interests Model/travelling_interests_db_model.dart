
import 'package:floor/floor.dart';

@entity
class TravellingInterestsModel{

  @PrimaryKey()
  int? id;

  String? name;

  String? color;

  TravellingInterestsModel(this.id, this.name, this.color);
  TravellingInterestsModel._(this.name, this.color);

  factory TravellingInterestsModel.fromMap(Map<String, dynamic> dataMap) {
    return TravellingInterestsModel._(
        dataMap['name'],
        dataMap['color']
    );
  }

  factory TravellingInterestsModel.fromJson(Map<String, dynamic> json) =>
      TravellingInterestsModel._(
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