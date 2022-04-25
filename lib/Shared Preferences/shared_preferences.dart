import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uny_app/Interests%20Model/all_interests_model.dart';
import 'package:uny_app/Interests%20Model/career_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/family_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/general_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/sport_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/travelling_interests_db_model.dart';


class ShPreferences{

  static var _sharedPreferences;

  static Future<SharedPreferences> init() async {
    return _sharedPreferences = await SharedPreferences.getInstance();
  }

  static void setAllInterests(List<AllInterestsModel>? _allInterests){
    _sharedPreferences.setString('all_interests', jsonEncode(_allInterests));
  }

  static void setFamilyInterests(List<FamilyInterestsModel>? _familyInterests){
    _sharedPreferences.setString('family_interests', jsonEncode(_familyInterests));
  }

  static void setCareerInterests(List<CareerInterestsModel>? _careerInterests){
    _sharedPreferences.setString('career_interests', jsonEncode(_careerInterests));
  }

  static void setSportInterests(List<SportInterestsModel>? _sportInterests){
    _sharedPreferences.setString('sport_interests', jsonEncode(_sportInterests));
  }

  static void setTravelingInterests(List<TravellingInterestsModel>? _travelingInterests){
    _sharedPreferences.setString('traveling_interests', jsonEncode(_travelingInterests));
  }

  static void setGeneralInterests(List<GeneralInterestsModel>? _generalInterests){
    _sharedPreferences.setString('general_interests', jsonEncode(_generalInterests));
  }


  static List<AllInterestsModel>?  getAllInterestsShPref() {
    if(_sharedPreferences.getString('all_interests') != null) {
      List<dynamic> parsedList =  jsonDecode(_sharedPreferences.getString('all_interests'));
      List<AllInterestsModel> _allInterests = List<AllInterestsModel>.from(parsedList.map((e) => AllInterestsModel.fromJson(e)));
      return _allInterests;
    }else{
      return null;
    }
  }


  static List<FamilyInterestsModel>?  getFamilyInterestsShPref() {
    if(_sharedPreferences.getString('family_interests') != null) {
      List<dynamic> parsedList =  jsonDecode(_sharedPreferences.getString('family_interests'));
      List<FamilyInterestsModel> _familyInterests = List<FamilyInterestsModel>.from(parsedList.map((e) => FamilyInterestsModel.fromJson(e)));
      return _familyInterests;
    }else{
      return null;
    }
  }

  static List<CareerInterestsModel>? getCareerInterestsShPref() {
    if(_sharedPreferences.getString('career_interests') != null){
      List<dynamic> parsedList = jsonDecode(_sharedPreferences.getString('career_interests'));
      List<CareerInterestsModel> _careerInterests = List<CareerInterestsModel>.from(parsedList.map((e) => CareerInterestsModel.fromJson(e)));
      return _careerInterests;
    }else{
      return null;
    }
  }

  static List<SportInterestsModel>? getSportInterestsShPref() {
    if(_sharedPreferences.getString('sport_interests') != null){
      List<dynamic> parsedList = jsonDecode(_sharedPreferences.getString('sport_interests'));
      List<SportInterestsModel> _sportInterests = List<SportInterestsModel>.from(parsedList.map((e) => SportInterestsModel.fromJson(e)));
      return _sportInterests;
    }else{
      return null;
    }
  }

  static List<TravellingInterestsModel>? getTravelingInterestsShPref() {
    if(_sharedPreferences.getString('traveling_interests') != null){
      List<dynamic> parsedList = jsonDecode(_sharedPreferences.getString('traveling_interests'));
      List<TravellingInterestsModel> _travelingInterests = List<TravellingInterestsModel>.from(parsedList.map((e) => TravellingInterestsModel.fromJson(e)));
      return _travelingInterests;
    }else{
      return null;
    }
  }

  static List<GeneralInterestsModel>? getGeneralInterestsShPref() {
    if(_sharedPreferences.getString('general_interests') != null){
      List<dynamic> parsedList = jsonDecode(_sharedPreferences.getString('general_interests'));
      List<GeneralInterestsModel> _generalInterests = List<GeneralInterestsModel>.from(parsedList.map((e) => GeneralInterestsModel.fromJson(e)));
      return _generalInterests;
    }else{
      return null;
    }
  }

  static void clear() async {
    await _sharedPreferences.clear();
  }
}