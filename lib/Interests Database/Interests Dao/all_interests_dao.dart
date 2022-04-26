import 'package:floor/floor.dart';
import 'package:uny_app/Interests%20Model/all_interests_db_model.dart';

@dao
abstract class AllInterestsDao {

  @Query('SELECT * FROM AllInterestsModel LIMIT :start, :end')
  Future<List<AllInterestsModel>> getAllInterestsByLimit(String start, String end);

  @Query('SELECT * FROM AllInterestsModel WHERE name LIKE %:name%')
  Future<List<AllInterestsModel>> filterInterest(String name);

  @Query('SELECT * FROM AllInterestsModel')
  Future<List<AllInterestsModel>> getAllInterests();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAllInterests(AllInterestsModel allInterestsModel);
}