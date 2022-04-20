
import 'package:floor/floor.dart';

@entity
class SportInterestsModel{

  @PrimaryKey()
  int? id;

  String? name;

  SportInterestsModel(this.id, this.name);
}