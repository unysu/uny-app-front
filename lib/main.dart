import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';
import 'package:sizer/sizer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uny_app/Authorization%20Pages/authorization_info_page.dart';
import 'package:uny_app/Authorization%20Pages/authorization_page.dart';
import 'package:uny_app/Interests%20Database/Database/database_object.dart';
import 'package:uny_app/Interests%20Database/interests_database.dart';
import 'package:uny_app/Interests%20Model/all_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/career_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/family_interests.dart';
import 'package:uny_app/Interests%20Model/family_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/general_interests.dart';
import 'package:uny_app/Interests%20Model/general_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/sport_interests.dart';
import 'package:uny_app/Interests%20Model/sport_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/travelling_interests.dart';
import 'package:uny_app/Interests%20Model/travelling_interests_db_model.dart';
import 'package:uny_app/Interests%20Pages/choose_interests_page.dart';
import 'package:uny_app/Shared%20Preferences/shared_preferences.dart';
import 'package:uny_app/Token%20Data/token_data.dart';
import 'package:uny_app/User%20Profile%20Page/user_profile_page.dart';
import 'package:uny_app/Video%20Search%20Page/interests_counter_provider.dart';
import 'Interests Model/career_interests.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ShPreferences.init();
  await TokenData.init();
  runApp(ChangeNotifierProvider<InterestsCounterProvider>(
    create: (_) => InterestsCounterProvider(),
    builder: (context, child){
      return MaterialApp(
        home: SplashScreenPage(),
      );
    }
   )
  );
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
      ShPreferences.setIsFirstRun(false);
      if(TokenData.getUserToken() != ''){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserProfilePage())
        );
      }else{
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AuthorizationPage())
        );
      }
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
                  child: ShPreferences.getIsFirstRun() == null ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 150,
                          height: 150,
                          child: Image.asset('assets/splash_icon.png')
                      ),
                      SizedBox(height: 50),
                      CircularProgressIndicator(
                        strokeWidth: 1,
                        color: Color.fromRGBO(145, 10, 251, 5),
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: Text('Первый запуск...  Может занять несколько секунд', maxLines: 2),
                      )
                    ],
                  ) : SizedBox(
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

    int? allInterestsCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM AllInterestsModel'));
    int? familyInterestsCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM FamilyInterestsModel'));
    int? careerInterestsCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM CareerInterestsModel'));
    int? sportInterestsCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM SportInterestsModel'));
    int? travellingInterestsCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM TravellingInterestsModel'));
    int? generalInterestsCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM GeneralInterestsModel'));

    if(
        allInterestsCount == 0 &&
        familyInterestsCount == 0 &&
        careerInterestsCount == 0 &&
        sportInterestsCount == 0  &&
        travellingInterestsCount == 0 &&
        generalInterestsCount == 0
    ){
      final allInterestsDao = database.allInterestsDao;
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

      List<FamilyInterestsModel> _familyInterests = await familyInterestsDao.getFamilyInterests();
      List<CareerInterestsModel> _careerInterests = await careerInterestsDao.getCareerInterests();
      List<SportInterestsModel> _sportInterests = await sportInterestsDao.getSportInterests();
      List<TravellingInterestsModel> _travelingInterest = await travelingInterestsDao.getTravelingInterests();
      List<GeneralInterestsModel> _generalInterests = await generalInterestsDao.getGeneralInterests();

      Map<String, String> familyInterestsMap = Map.fromIterable(_familyInterests,
          key: (interest) => interest.name,
          value: (interest) => interest.color);

      Map<String, String> careerInterestsMap = Map.fromIterable(_careerInterests,
          key: (interest) => interest.name,
          value: (interest) => interest.color);

      Map<String, String> sportInterestsMap = Map.fromIterable(_sportInterests,
          key: (interest) => interest.name,
          value: (interest) => interest.color);

      Map<String, String> travelingInterestsMap = Map.fromIterable(_travelingInterest,
          key: (interest) => interest.name,
          value: (interest) => interest.color);

      Map<String, String> generalInterestsMap = Map.fromIterable(_generalInterests,
          key: (interest) => interest.name,
          value: (interest) => interest.color);


      List<AllInterestsModel>? _allInterestsList = [];
      Map<String, String> allInterestsMap = {};
      allInterestsMap.addAll(familyInterestsMap);
      allInterestsMap.addAll(careerInterestsMap);
      allInterestsMap.addAll(sportInterestsMap);
      allInterestsMap.addAll(travelingInterestsMap);
      allInterestsMap.addAll(generalInterestsMap);

      allInterestsMap.forEach((name, color) {
        _allInterestsList.add(AllInterestsModel(name, color));
      });

      _allInterestsList.shuffle();
      for(int i = 0; i < _allInterestsList.length; ++i){
        final allInterests = AllInterestsModel.ForDB(i, _allInterestsList[i].name, _allInterestsList[i].color);

        await allInterestsDao.insertAllInterests(allInterests);
      }
    }else{
      return;
    }
  }
}





