
import 'package:floor/floor.dart';

@entity
class GeneralInterestsModel{

  @PrimaryKey()
  int? id;

  String? name;

  GeneralInterestsModel(this.id, this.name);
}