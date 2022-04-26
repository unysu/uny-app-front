import 'package:floor/floor.dart';
import 'package:uny_app/Interests%20Model/career_interests_db_model.dart';

@dao
abstract class CareerInterestsDao{

  @Query('SELECT * FROM CareerInterestsModel LIMIT :start, :end')
  Future<List<CareerInterestsModel>> getCareerInterestsByLimit(String start, String end);

  @Query('SELECT * FROM CareerInterestsModel')
  Future<List<CareerInterestsModel>> getCareerInterests();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCareerInterests(CareerInterestsModel careerInterestsModel);

}