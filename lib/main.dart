import 'dart:async';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:sqflite/sqflite.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uny_app/Interests%20Database/Database/database_object.dart';
import 'package:uny_app/Interests%20Database/interests_database.dart';
import 'package:uny_app/Interests%20Model/career_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/family_interests.dart';
import 'package:uny_app/Interests%20Model/family_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/general_interests.dart';
import 'package:uny_app/Interests%20Model/general_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/sport_interests.dart';
import 'package:uny_app/Interests%20Model/sport_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/travelling_interests.dart';
import 'package:uny_app/Interests%20Model/travelling_interests_db_model.dart';
import 'package:uny_app/Shared%20Preferences/shared_preferences.dart';
import 'package:uny_app/User%20Profile%20Page/user_profile_page.dart';
import 'Interests Model/career_interests.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ShPreferences.init();
  runApp(MaterialApp(
    home: SplashScreenPage(),
  ));
}

class SplashScreenPage extends StatefulWidget{
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  RandomColor _randomColor = RandomColor();

  late FamilyInterests familyInterests;
  late CareerInterests careerInterests;
  late SportInterests sportInterests;
  late TravelingInterests travelingInterests;
  late GeneralInterests generalInterests;


  List<String>? _familyInterestsList = [];
  List<String>? _careerInterestsList = [];
  List<String>? _sportInterestsList = [];
  List<String>? _travelingInterestsList = [];
  List<String>? _generalInterestsList = [];


 @override
  void initState() {
    super.initState();

    familyInterests = FamilyInterests.init();
    careerInterests = CareerInterests.init();
    sportInterests = SportInterests.init();
    travelingInterests = TravelingInterests.init();
    generalInterests = GeneralInterests.init();

    _familyInterestsList = familyInterests.getFamilyInterests();
    _careerInterestsList = careerInterests.getCareerInterests();
    _sportInterestsList = sportInterests.getSportInterests();
    _travelingInterestsList = travelingInterests.getTravellingInterests();
    _generalInterestsList = generalInterests.getGeneralInterests();

    addInterestsToDb().whenComplete(() {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserProfilePage())
      );
    });
  }

  @override
  void dispose() {
    super.dispose();

    _familyInterestsList!.clear();
    _careerInterestsList!.clear();
    _sportInterestsList!.clear();
    _travelingInterestsList!.clear();
    _generalInterestsList!.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget){
        return ResponsiveWrapper.builder(
            Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Image.asset('assets/splash_icon.png')
                  ),
                )
            ),
          maxWidth: 1200,
          minWidth: 450,
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.resize(200, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(720, name: MOBILE)
          ],
        );
      }
    );
  }

  Future addInterestsToDb() async {
    final database = await $FloorInterestsDatabase.databaseBuilder('interests_database.db').build();
    var db = await openDatabase('interests_database.db');

    DatabaseObject.setDb = database;

    int? familyInterestsCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM FamilyInterestsModel'));
    int? careerInterestsCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM CareerInterestsModel'));
    int? sportInterestsCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM SportInterestsModel'));
    int? travellingInterestsCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM TravellingInterestsModel'));
    int? generalInterestsCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM GeneralInterestsModel'));

    if(
        familyInterestsCount == 0 &&
        careerInterestsCount == 0 &&
        sportInterestsCount == 0  &&
        travellingInterestsCount == 0 &&
        generalInterestsCount == 0
    ){
      final familyInterestsDao = database.familyInterestsDao;
      final careerInterestsDao = database.careerInterestsDao;
      final sportInterestsDao = database.sportInterestsDao;
      final travelingInterestsDao = database.travelingInterestsDao;
      final generalInterestsDao = database.generalInterestsDao;

      for(int i = 0; i < _familyInterestsList!.length; ++i){
        Color? color = _randomColor.randomColor(
            colorHue: ColorHue.custom(Range(120, 130)),
            colorSaturation: ColorSaturation.mediumSaturation,
            colorBrightness: ColorBrightness.primary);

        final familyInterests = FamilyInterestsModel(i, _familyInterestsList![i], color.value.toRadixString(16));

        await familyInterestsDao.insertFamilyInterest(familyInterests);
      }

      for(int i = 0; i < _careerInterestsList!.length; ++i){
        Color? color = _randomColor.randomColor(
            colorHue: ColorHue.custom(Range(180, 190)),
            colorSaturation: ColorSaturation.highSaturation,
            colorBrightness: ColorBrightness.primary);

        final careerInterests = CareerInterestsModel(i, _careerInterestsList![i], color.value.toRadixString(16));

        await careerInterestsDao.insertCareerInterests(careerInterests);
      }

      for(int i = 0; i < _sportInterestsList!.length; ++i){
        Color? color = _randomColor.randomColor(
            colorHue: ColorHue.custom(Range(200, 220)),
            colorSaturation: ColorSaturation.highSaturation,
            colorBrightness: ColorBrightness.primary);

        final sportInterests = SportInterestsModel(i, _sportInterestsList![i], color.value.toRadixString(16));

        await sportInterestsDao.insertSportInterests(sportInterests);
      }

      for(int i = 0; i < _travelingInterestsList!.length; ++i){
        Color? color = _randomColor.randomColor(
            colorHue: ColorHue.custom(Range(10, 40)),
            colorSaturation: ColorSaturation.highSaturation,
            colorBrightness: ColorBrightness.light);

        final travelingInterests = TravellingInterestsModel(i, _travelingInterestsList![i], color.value.toRadixString(16));

        await travelingInterestsDao.insertTravelingInterests(travelingInterests);
      }

      for(int i = 0; i < _generalInterestsList!.length; ++i){
        Color? color = _randomColor.randomColor(
            colorHue: ColorHue.custom(Range(240, 315)),
            colorSaturation: ColorSaturation.highSaturation,
            colorBrightness: ColorBrightness.light);

        final generalInterests = GeneralInterestsModel(i, _generalInterestsList![i], color.value.toRadixString(16));

        await generalInterestsDao.insertGeneralInterests(generalInterests);
      }
    }else{
      return;
    }
  }
}





