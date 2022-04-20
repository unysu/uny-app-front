import 'package:floor/floor.dart';

@entity
class CareerInterestsModel{

  @PrimaryKey()
  int? id;

  String? name;

  CareerInterestsModel(this.id, this.name);
}