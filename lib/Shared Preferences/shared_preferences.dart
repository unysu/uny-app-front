import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uny_app/Interests%20Model/interests_db_model.dart';


class ShPreferences{

  static var _sharedPreferences;

  static Future<SharedPreferences> init() async {
    return _sharedPreferences = await SharedPreferences.getInstance();
  }

  static void setIsFirstRun(bool isFirstRun){
    _sharedPreferences.setBool('isFirstRun', isFirstRun);
  }


  static void setAllInterests(List<InterestsModel>? _allInterests){
    _sharedPreferences.setString('all_interests', jsonEncode(_allInterests));
  }


  static bool? getIsFirstRun(){
    return _sharedPreferences.getBool('isFirstRun');
  }

  static List<InterestsModel> getAllInterestsShPref() {
    List<InterestsModel> _allInterests = [];
    if(_sharedPreferences.getString('all_interests') != null) {
      List<dynamic> parsedList =  jsonDecode(_sharedPreferences.getString('all_interests'));

       _allInterests = List<InterestsModel>.from(parsedList.map((e) => InterestsModel.fromJson(e)));
      return _allInterests;
    }else{
      return _allInterests;
    }
  }

  static void clear() async {
    await _sharedPreferences.remove('all_interests');
  }
}