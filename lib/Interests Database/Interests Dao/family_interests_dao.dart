import 'package:floor/floor.dart';
import 'package:uny_app/Interests%20Model/family_interests_db_model.dart';

@dao
abstract class FamilyInterestsDao{

  @Query('SELECT * FROM FamilyInterestsModel')
  Future<List<FamilyInterestsModel>> getFamilyInterests();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertFamilyInterest(FamilyInterestsModel familyInterestsModel);
}