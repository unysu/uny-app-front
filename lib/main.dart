import 'dart:async';
import 'dart:math';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/Authorization%20Pages/authorization_page.dart';
import 'package:uny_app/Firebase/firebase_options.dart';
import 'package:uny_app/Interests%20Database/Database/database_object.dart';
import 'package:uny_app/Interests%20Database/interests_database.dart';
import 'package:uny_app/Interests%20Model/family_interests.dart';
import 'package:uny_app/Interests%20Model/general_interests.dart';
import 'package:uny_app/Interests%20Model/interests_db_model.dart';
import 'package:uny_app/Interests%20Model/sport_interests.dart';
import 'package:uny_app/Interests%20Model/travelling_interests.dart';
import 'package:uny_app/Interests%20Page/choose_interests_page.dart';
import 'package:uny_app/Providers/chat_counter_provider.dart';
import 'package:uny_app/Providers/chat_data_provider.dart';
import 'package:uny_app/Providers/user_data_provider.dart';
import 'package:uny_app/Providers/video_controller_provider.dart';
import 'package:uny_app/Shared%20Preferences/shared_preferences.dart';
import 'package:uny_app/Token%20Data/token_data.dart';
import 'package:uny_app/User%20Profile%20Page/user_profile_page.dart';
import 'package:uny_app/Video%20Search%20Page/interests_counter_provider.dart';
import 'package:uny_app/Video%20Search%20Page/video_search_page.dart';
import 'Interests Model/career_interests.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ShPreferences.init();
  await TokenData.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AwesomeNotifications().initialize(
    UniversalPlatform.isAndroid ? 'resource://drawable/uny_logo' : 'resource://Runner/Assets.xcassets/AppIcon.appiconset/uny_logo.png',
    [
      NotificationChannel(
        channelKey: 'high_importance_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Uny App',
        defaultRingtoneType: DefaultRingtoneType.Notification,
        importance: NotificationImportance.High,
        enableVibration: true,
      )
    ],
  );
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
      ),

      ChangeNotifierProvider<ChatsDataProvider>(
        create: (context) => ChatsDataProvider(),
      ),

      ChangeNotifierProvider<ChatCounterProvider>(
        create: (context) => ChatCounterProvider(),
      )
    ],
    child: AdaptiveTheme(
      initial: AdaptiveThemeMode.light,
      light: ThemeData(
        colorScheme: ColorScheme.fromSwatch(brightness: Brightness.light),
        fontFamily: 'SF Pro Display'
      ),
      dark: ThemeData(
        colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark),
        fontFamily: 'SF Pro Display'
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(UniversalPlatform.isIOS){
        FirebaseMessaging messaging = FirebaseMessaging.instance;

        await messaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
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

      Map<int, List<Color>> familyInterestsColor = {
        0 : [Color.fromRGBO(77, 227, 63, 10), Color.fromRGBO(83, 234, 122, 10)],
        1 : [Color.fromRGBO(7, 159, 59, 10), Color.fromRGBO(9, 86, 31, 10)],
        2 : [Color.fromRGBO(120, 226, 42, 10), Color.fromRGBO(158, 218, 41, 10)]
      };

      Map<int, List<Color>> careerInterestsColor = {
        0 : [Color.fromRGBO(4, 223, 223, 10), Color.fromRGBO(32, 216, 216, 10)],
        1 : [Color.fromRGBO(81, 214, 174, 10), Color.fromRGBO(83, 214, 206, 10)],
        2 : [Color.fromRGBO(81, 198, 233, 10), Color.fromRGBO(22, 201, 247, 10)]
      };

      Map<int, List<Color>> sportInterestsColor = {
        0 : [Color.fromRGBO(12, 65, 253, 10), Color.fromRGBO(35, 111, 240, 10)],
        1 : [Color.fromRGBO(22, 120, 218, 10), Color.fromRGBO(22, 93, 216, 10)],
        2 : [Color.fromRGBO(115, 175, 255, 10), Color.fromRGBO(81, 143, 241, 10)]
      };

      Map<int, List<Color>> travelingInterestsColor = {
        0 : [Color.fromRGBO(254, 222, 2, 10), Color.fromRGBO(231, 152, 1, 10)],
        1 : [Color.fromRGBO(255, 134, 2, 10), Color.fromRGBO(255, 151, 1, 10)],
        2 : [Color.fromRGBO(255, 193, 104, 10), Color.fromRGBO(255, 153, 0, 10)]
      };

      Map<int, List<Color>> generalInterestsColor = {
        0 : [Color.fromRGBO(208, 2, 255, 10), Color.fromRGBO(167, 2, 255, 10)],
        1 : [Color.fromRGBO(77, 2, 169, 10), Color.fromRGBO(122, 14, 194, 10)],
        2 : [Color.fromRGBO(85, 110, 241, 10), Color.fromRGBO(156, 116, 250, 10)]
      };


      for(int i = 0; i < _familyInterestsList!.length; ++i){

        int rn = Random().nextInt(3);

        final familyInterests = InterestsModel.ForDB(_familyInterestsList![i], 'family', familyInterestsColor[rn]![0].value.toRadixString(16), familyInterestsColor[rn]![1].value.toRadixString(16));

        allInterests.add(familyInterests);
      }

      for(int i = 0; i < _careerInterestsList!.length; ++i){

        int rn = Random().nextInt(3);

        final careerInterests = InterestsModel.ForDB(_careerInterestsList![i], 'career', careerInterestsColor[rn]![0].value.toRadixString(16), careerInterestsColor[rn]![1].value.toRadixString(16));

        allInterests.add(careerInterests);
      }

      for(int i = 0; i < _sportInterestsList!.length; ++i){

        int rn = Random().nextInt(3);

        final sportInterests = InterestsModel.ForDB(_sportInterestsList![i], 'sport', sportInterestsColor[rn]![0].value.toRadixString(16), sportInterestsColor[rn]![1].value.toRadixString(16));

        allInterests.add(sportInterests);
      }

      for(int i = 0; i < _travelingInterestsList!.length; ++i){

        int rn = Random().nextInt(3);

        final travelingInterests = InterestsModel.ForDB(_travelingInterestsList![i], 'traveling', travelingInterestsColor[rn]![0].value.toRadixString(16), travelingInterestsColor[rn]![1].value.toRadixString(16));

        allInterests.add(travelingInterests);
      }

      for(int i = 0; i < _generalInterestsList!.length; ++i){

        int rn = Random().nextInt(3);

        final generalInterests = InterestsModel.ForDB(_generalInterestsList![i], 'general', generalInterestsColor[rn]![0].value.toRadixString(16), generalInterestsColor[rn]![1].value.toRadixString(16));

        allInterests.add(generalInterests);
      }

      allInterests.shuffle();
      interestsDao.insertInterest(allInterests);
    }else{
      return await Future.delayed(Duration(seconds: 1));
    }
  }
}





