import 'package:floor/floor.dart';
import '../../Interests Model/interests_db_model.dart';

@dao
abstract class InterestsDao{

  @Query('SELECT * FROM InterestsModel LIMIT :start, :end')
  Future<List<InterestsModel>> getAllInterestsByLimit(String start, String end);

  @Query("SELECT * FROM InterestsModel WHERE type = 'traveling' LIMIT :start, :end")
  Future<List<InterestsModel>> getTravelingInterestsByLimit(String start, String end);

  @Query("SELECT * FROM InterestsModel WHERE type = 'general' LIMIT :start, :end")
  Future<List<InterestsModel>> getGeneralInterestsByLimit(String start, String end);

  @Query("SELECT * FROM InterestsModel WHERE type = 'career' LIMIT :start, :end")
  Future<List<InterestsModel>> getCareerInterestsByLimit(String start, String end);

  @Query("SELECT * FROM InterestsModel WHERE type = 'family'")
  Future<List<InterestsModel>> getFamilyInterestsByLimit();

  @Query("SELECT * FROM InterestsModel WHERE type = 'sport'")
  Future<List<InterestsModel>> getSportInterestsByLimit();

  @Query('SELECT * FROM InterestsModel WHERE name LIKE %:name%')
  Future<List<InterestsModel>> filterInterests(String name);

  @Query('SELECT * FROM InterestsModel')
  Future<List<InterestsModel>> getAllInterests();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertInterest(List<InterestsModel> interestsModel);
}