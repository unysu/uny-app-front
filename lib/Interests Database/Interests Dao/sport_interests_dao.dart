import 'package:floor/floor.dart';
import 'package:uny_app/Interests%20Model/sport_interests_db_model.dart';

@dao
abstract class SportInterestsDao{

  @Query('SELECT * FROM SportInterestsModel LIMIT :start, :end')
  Future<List<SportInterestsModel>> getSportInterestsByLimit(String start, String end);

  @Query('SELECT * FROM SportInterestsModel')
  Future<List<SportInterestsModel>> getSportInterests();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSportInterests(SportInterestsModel sportInterestsModel);
}