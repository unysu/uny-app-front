import 'package:floor/floor.dart';
import 'package:uny_app/Interests%20Model/family_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/travelling_interests_db_model.dart';

@dao
abstract class TravelingInterestsDao{

  @Query('SELECT * FROM TravellingInterestsModel')
  Future<List<TravellingInterestsModel>> getTravelingInterests();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTravelingInterests(TravellingInterestsModel travellingInterestsModel);
}