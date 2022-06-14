import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:uny_app/Interests%20Database/Interests%20Dao/interests_dao.dart';
import 'package:uny_app/Interests%20Model/interests_db_model.dart';

part 'interests_database.g.dart';

@Database(version: 1, entities: [InterestsModel])
abstract class InterestsDatabase extends FloorDatabase{

  InterestsDao get interestsModelDao;

}