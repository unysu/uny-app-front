
import 'package:floor/floor.dart';

@entity
class TravellingInterestsModel{

  @PrimaryKey()
  int? id;

  String? name;

  TravellingInterestsModel(this.id, this.name);
}