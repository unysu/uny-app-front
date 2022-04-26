import 'package:floor/floor.dart';
import 'package:uny_app/Interests%20Model/family_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/general_interests_db_model.dart';

@dao
abstract class GeneralInterestsDao{

  @Query('SELECT * FROM GeneralInterestsModel LIMIT :start, :end')
  Future<List<GeneralInterestsModel>> getGeneralInterestsByLimit(String start, String end);

  @Query('SELECT * FROM GeneralInterestsModel')
  Future<List<GeneralInterestsModel>> getGeneralInterests();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertGeneralInterests(GeneralInterestsModel generalInterestsModel);
}