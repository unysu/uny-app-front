import 'package:uny_app/Interests%20Database/interests_database.dart';

class DatabaseObject {

  static InterestsDatabase? _db;

  static set setDb(InterestsDatabase db){
    _db = db;
  }

  static InterestsDatabase? get getDb{
    return _db;
  }
}