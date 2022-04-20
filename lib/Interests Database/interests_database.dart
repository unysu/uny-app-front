import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:uny_app/Interests%20Database/Interests%20Dao/career_interests_dao.dart';
import 'package:uny_app/Interests%20Database/Interests%20Dao/general_interests_dao.dart';
import 'package:uny_app/Interests%20Database/Interests%20Dao/sport_interests_dao.dart';
import 'package:uny_app/Interests%20Database/Interests%20Dao/traveling_interests_dao.dart';
import 'package:uny_app/Interests%20Model/career_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/family_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/general_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/sport_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/travelling_interests_db_model.dart';

import 'Interests Dao/family_interests_dao.dart';

part 'interests_database.g.dart';

@Database(version: 1, entities: [
  FamilyInterestsModel,
  CareerInterestsModel,
  SportInterestsModel,
  TravellingInterestsModel,
  GeneralInterestsModel
])
abstract class InterestsDatabase extends FloorDatabase{

  FamilyInterestsDao get familyInterestsDao;
  CareerInterestsDao get careerInterestsDao;
  SportInterestsDao  get sportInterestsDao;
  TravelingInterestsDao get travelingInterestsDao;
  GeneralInterestsDao get generalInterestsDao;
}