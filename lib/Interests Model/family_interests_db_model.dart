
import 'package:floor/floor.dart';

@entity
class FamilyInterestsModel{

  @PrimaryKey()
  int? id;

  String? name;

  FamilyInterestsModel(this.id, this.name);
}