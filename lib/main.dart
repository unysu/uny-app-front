import 'dart:async';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';
import 'package:sqflite/sqflite.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uny_app/Authorization%20Pages/authorization_page.dart';
import 'package:uny_app/Interests%20Database/Database/database_object.dart';
import 'package:uny_app/Interests%20Database/interests_database.dart';
import 'package:uny_app/Interests%20Model/family_interests.dart';
import 'package:uny_app/Interests%20Model/general_interests.dart';
import 'package:uny_app/Interests%20Model/interests_db_model.dart';
import 'package:uny_app/Interests%20Model/sport_interests.dart';
import 'package:uny_app/Interests%20Model/travelling_interests.dart';
import 'package:uny_app/Interests%20Pages/choose_interests_page.dart';
import 'package:uny_app/Providers/user_data_provider.dart';
import 'package:uny_app/Providers/video_controller_provider.dart';
import 'package:uny_app/Shared%20Preferences/shared_preferences.dart';
import 'package:uny_app/Token%20Data/token_data.dart';
import 'package:uny_app/User%20Profile%20Page/user_profile_page.dart';
import 'package:uny_app/Video%20Search%20Page/interests_counter_provider.dart';
import 'Interests Model/career_interests.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ShPreferences.init();
  await TokenData.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<InterestsCounterProvider>(
          create: (context) => InterestsCounterProvider()
      ),

      ChangeNotifierProvider<UserDataProvider>(
          create: (context) => UserDataProvider(),
      ),

      ChangeNotifierProvider<VideoControllerProvider>(
        create: (context) => VideoControllerProvider(),
      )
    ],
    child: AdaptiveTheme(
      initial: AdaptiveThemeMode.light,
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        accentColor: Colors.amber,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        accentColor: Colors.amber,
      ),
      builder: (theme, darkTheme){
        return MaterialApp(
          theme: theme,
          darkTheme: darkTheme,
          home: SplashScreenPage(),
        );
      },
    )
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

  final String _mainLogoAsset = 'assets/uny_main_logo.svg';


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
                          child: SvgPicture.asset(_mainLogoAsset)
                      ),
                      SizedBox(height: 30),
                      Text('UNY', style: TextStyle(fontSize: 32, color: Colors.black)),
                      SizedBox(height: 20),
                      Container(
                        width: 300,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                            'Ожидайте, мы ищем вам лучших людей...',
                            maxLines: 2,
                          style: TextStyle(fontSize: 22, color: Colors.black45),
                        ),
                      )
                    ],
                  ) : SizedBox(
                      width: 150,
                      height: 150,
                      child: SvgPicture.asset(_mainLogoAsset)
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

    int? allInterestsCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM InterestsModel'));

    if(allInterestsCount == 0){
      final interestsDao = database.interestsModelDao;

      List<InterestsModel> allInterests = [];

      for(int i = 0; i < _familyInterestsList!.length; ++i){
        Color? color = _randomColor.randomColor(
            colorHue: ColorHue.custom(Range(120, 130)),
            colorSaturation: ColorSaturation.mediumSaturation,
            colorBrightness: ColorBrightness.primary);

        final familyInterests = InterestsModel.ForDB(_familyInterestsList![i], 'family', color.value.toRadixString(16));

        allInterests.add(familyInterests);
      }

      for(int i = 0; i < _careerInterestsList!.length; ++i){
        Color? color = _randomColor.randomColor(
            colorHue: ColorHue.custom(Range(180, 190)),
            colorSaturation: ColorSaturation.highSaturation,
            colorBrightness: ColorBrightness.primary);

        final careerInterests = InterestsModel.ForDB(_careerInterestsList![i], 'career', color.value.toRadixString(16));

        allInterests.add(careerInterests);
      }

      for(int i = 0; i < _sportInterestsList!.length; ++i){
        Color? color = _randomColor.randomColor(
            colorHue: ColorHue.custom(Range(200, 220)),
            colorSaturation: ColorSaturation.highSaturation,
            colorBrightness: ColorBrightness.primary);

        final sportInterests = InterestsModel.ForDB(_sportInterestsList![i], 'sport', color.value.toRadixString(16));

        allInterests.add(sportInterests);
      }

      for(int i = 0; i < _travelingInterestsList!.length; ++i){
        Color? color = _randomColor.randomColor(
            colorHue: ColorHue.custom(Range(10, 40)),
            colorSaturation: ColorSaturation.highSaturation,
            colorBrightness: ColorBrightness.light);

        final travelingInterests = InterestsModel.ForDB(_travelingInterestsList![i], 'traveling', color.value.toRadixString(16));

        allInterests.add(travelingInterests);
      }

      for(int i = 0; i < _generalInterestsList!.length; ++i){
        Color? color = _randomColor.randomColor(
            colorHue: ColorHue.custom(Range(240, 315)),
            colorSaturation: ColorSaturation.highSaturation,
            colorBrightness: ColorBrightness.light);

        final generalInterests = InterestsModel.ForDB(_generalInterestsList![i], 'general', color.value.toRadixString(16));

        allInterests.add(generalInterests);
      }

      allInterests.shuffle();
      interestsDao.insertInterest(allInterests);
    }else{
      return;
    }
  }
}





