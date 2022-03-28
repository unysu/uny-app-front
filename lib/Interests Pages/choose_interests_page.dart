import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_color/random_color.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/Interests%20Model/career_interests_model.dart';
import 'package:uny_app/Interests%20Model/family_interests_model.dart';
import 'package:uny_app/Interests%20Model/general_interests_model.dart';
import 'package:uny_app/Interests%20Model/sport_interests_model.dart';
import 'package:uny_app/Interests%20Model/travelling_interests_model.dart';

class InterestsPage extends StatefulWidget {
  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  RandomColor _randomColor = RandomColor();

  int _counter = 0;

  late FamilyInterests familyInterests;
  late CareerInterests careerInterests;
  late SportInterests sportInterests;
  late TravelingInterests travelingInterests;
  late GeneralInterests generalInterests;

  late double height;
  late double width;

  bool _isSearching = false;

  bool _isFamilyEnabled = true;
  bool _isCareerEnabled = false;
  bool _isSportEnabled = false;
  bool _isTravelingEnabled = false;
  bool _isGeneralEnabled = false;

  List<String>? _familyInterestsList = [];
  List<String>? _careerInterestsList = [];
  List<String>? _sportInterestsList = [];
  List<String>? _travelingInterestsList = [];
  List<String>? _generalInterestsList = [];

  List<String> _selectedFamilyInterests = [];
  List<String> _selectedCareerInterests = [];
  List<String> _selectedSportInterests = [];
  List<String> _selectedTravelingInterests = [];
  List<String> _selectedGeneralInterests = [];

  List<String> _familyFilteredList = [];
  List<String> _careerFilteredList = [];
  List<String> _sportFilteredList = [];
  List<String> _travelingFilteredList = [];
  List<String> _generalFilteredList = [];

  double _selectedFamilyInterestsValue = 0.0;
  double _selectedCareerInterestsValue = 0.0;
  double _selectedSportInterestsValue = 0.0;
  double _selectedTravelingInterestsValue = 0.0;
  double _selectedGeneralInterestsValue = 0.0;

  List<Color> _colors = [];

  @override
  void initState() {
    super.initState();

    familyInterests = FamilyInterests.init();
    careerInterests = CareerInterests.init();
    sportInterests = SportInterests.init();
    travelingInterests = TravelingInterests.init();
    generalInterests = GeneralInterests.init();

    _familyInterestsList = familyInterests.getFamilyInterests();
    _familyFilteredList = _familyInterestsList!;

    _careerInterestsList = careerInterests.getCareerInterests();
    _careerFilteredList = _careerInterestsList!;

    _sportInterestsList = sportInterests.getSportInterests();
    _sportFilteredList = _sportInterestsList!;

    _travelingInterestsList = travelingInterests.getTravellingInterests();
    _travelingFilteredList = _travelingInterestsList!;

    _generalInterestsList = generalInterests.getGeneralInterests();
    _generalFilteredList = _generalInterestsList!;

    for (int i = 0; i < familyInterests.getFamilyInterests().length; ++i) {
      _colors.add(_randomColor.randomColor(
          colorHue: ColorHue.custom(Range(120, 130)),
          colorSaturation: ColorSaturation.mediumSaturation,
          colorBrightness: ColorBrightness.primary));
    }

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (UniversalPlatform.isIOS) {
        await showCupertinoModalPopup(
            context: context,
            builder: (context) {
              return popup18PlusAttentionWidget();
            });
      } else if (UniversalPlatform.isAndroid) {
        await showModalBottomSheet(
            context: context,
            builder: (context) {
              return popup18PlusAttentionWidget();
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        return ResponsiveWrapper.builder(
            Scaffold(
              resizeToAvoidBottomInset: false,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Container(
                  height: height / 20,
                  padding: EdgeInsets.only(right: width / 20),
                  child: TextFormField(
                    cursorColor: Color.fromRGBO(145, 10, 251, 5),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: height / 50),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      prefixIcon: _isSearching != true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.search, color: Colors.grey),
                                Text('Поиск интересов',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.grey))
                              ],
                            )
                          : null,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.1))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.1))),
                    ),
                    onTap: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                    onChanged: (value) {
                      _familyFilteredList = _familyInterestsList!.where((interest) => interest.toLowerCase().startsWith(value.toLowerCase())).toList();
                      if (value.length == 0) {
                        setState(() {
                          _isSearching = false;
                        });
                      } else {
                        setState(() {
                          _isSearching = true;
                        });
                      }
                    },
                  ),
                ),
                centerTitle: true,
              ),
              body: mainBody(),
            ),
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.resize(480, name: MOBILE),
              const ResponsiveBreakpoint.autoScale(720, name: MOBILE)
            ]);
      },
    );
  }

  Widget mainBody() {
    return Wrap(
      children: [
        Container(
            padding: EdgeInsets.only(
                top: height / 7, left: width / 20, bottom: height / 30),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 35,
                        width: 35,
                        child: Icon(Icons.lock_open, color: Colors.white),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text('Семья',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      SizedBox(width: 5),
                      Container(
                        width: width / 8,
                        height: 2,
                        color: _isCareerEnabled
                            ? Colors.green
                            : Colors.grey.withOpacity(0.5),
                      ),
                      SizedBox(width: 5)
                    ],
                  ),
                  Row(
                    children: [
                      _isCareerEnabled
                          ? Container(
                              height: 35,
                              width: 35,
                              child: Image.asset('assets/unlocked.png'),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.lightBlue,
                              ),
                            )
                          : Icon(CupertinoIcons.lock_circle_fill,
                              color: Colors.grey, size: 40),
                      SizedBox(width: 5),
                      Text('Карьера',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      SizedBox(width: 5),
                      Container(
                        width: width / 8,
                        height: 2,
                        color: _isCareerEnabled
                            ? Colors.lightBlue
                            : Colors.grey.withOpacity(0.5),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                  Row(
                    children: [
                      _isSportEnabled
                          ? Container(
                              height: 35,
                              width: 35,
                              child: Image.asset('assets/unlocked.png'),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blueAccent,
                              ),
                            )
                          : Icon(CupertinoIcons.lock_circle_fill,
                              color: Colors.grey, size: 40),
                      SizedBox(width: 5),
                      Text('Спорт',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      SizedBox(width: 5),
                      Container(
                        width: width / 8,
                        height: 2,
                        color: _isCareerEnabled
                            ? Colors.blueAccent
                            : Colors.grey.withOpacity(0.5),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      _isTravelingEnabled
                          ? Container(
                              height: 35,
                              width: 35,
                              child: Image.asset('assets/unlocked.png'),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blueAccent,
                              ),
                            )
                          : Icon(CupertinoIcons.lock_circle_fill,
                              color: Colors.grey, size: 40),
                      SizedBox(width: 5),
                      Text('Путешествия',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      SizedBox(width: 5),
                      Container(
                        width: width / 8,
                        height: 2,
                        color: _isCareerEnabled
                            ? Colors.blueAccent
                            : Colors.grey.withOpacity(0.5),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                  Row(
                    children: [
                      _isGeneralEnabled
                          ? Container(
                              height: 35,
                              width: 35,
                              child: Image.asset('assets/unlocked.png'),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.deepPurpleAccent,
                              ),
                            )
                          : Icon(CupertinoIcons.lock_circle_fill,
                              color: Colors.grey, size: 40),
                      SizedBox(width: 5),
                      Text('Общее',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      SizedBox(width: 5),
                    ],
                  ),
                ],
              ),
            )),
        familyInterestsGridView(),
      ],
    );
  }

  Widget familyInterestsGridView() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: width * 0.78,
                height: 26,
                padding: EdgeInsets.only(left: width / 20),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: Stack(
                      children: [
                        Container(
                          height: height,
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.green[100],
                            color: Colors.green,
                            value: _selectedFamilyInterestsValue,
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            '${_counter}',
                            style: TextStyle(fontSize: 15, color: Colors.green),
                          ),
                        )
                      ],
                    ))),
            InkWell(
              child: Container(
                height: 50,
                width: 100,
                child: Center(
                  child: Text('Далее',
                      style: TextStyle(fontSize: 15, color: Colors.white)),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.deepPurpleAccent, Colors.blueAccent])),
              ),
            )
          ],
        ),
        SizedBox(height: height / 100),
        _selectedFamilyInterests.length == 0
            ? Center(
                child: Text(
                  'Выберите минимум один интерес для продолжения',
                  style: TextStyle(
                      fontSize: 15, color: Colors.grey.withOpacity(0.7)),
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Wrap(
                    spacing: 6.0,
                    runSpacing: 6.0,
                    children:
                    List.generate(_selectedFamilyInterests.length, (index) {
                      return Material(
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: Chip(
                            labelPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                            elevation: 3.0,
                            visualDensity: VisualDensity.comfortable,
                            padding: EdgeInsets.all(10),
                            backgroundColor: _colors[index],
                            shadowColor: Colors.grey,
                            label: Text(
                              _selectedFamilyInterests[index],
                              style: TextStyle(color: Colors.white),
                            ),
                            deleteIcon: Icon(CupertinoIcons.clear_circled,
                                color: Colors.white),
                            onDeleted: () {
                              _selectedFamilyInterests.removeAt(index);
                              _selectedFamilyInterestsValue -= 0.01;
                              --_counter;

                              setState((){});
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
        SizedBox(height: height / 100),
        Divider(
          thickness: 1,
          color: Colors.grey.withOpacity(0.5),
        ),
        _familyFilteredList.length != 0 ? SizedBox(
            height: height / 1.4,
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      width: width * 2,
                      child: Wrap(
                          spacing: 6.0,
                          runSpacing: 6.0,
                          children: List.generate(_familyFilteredList.length,
                              (index) {
                            return Material(
                              child: InkWell(
                                onTap: () {
                                  _selectedFamilyInterests.add(_familyFilteredList[index]);
                                  _selectedFamilyInterestsValue += 0.01;
                                  ++_counter;

                                  setState((){});
                                },
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                child: Chip(
                                  elevation: 5.0,
                                  visualDensity: VisualDensity.comfortable,
                                  padding: EdgeInsets.all(10),
                                  backgroundColor: _colors[index],
                                  shadowColor: Colors.grey,
                                  label: Text(
                                    _familyFilteredList[index],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          })),
                    )),
              ),
            )) : Container(
                padding: EdgeInsets.symmetric(vertical: height / 4, horizontal: width / 10),
                child: Text(
                  'По вашему запросу не найдено подходящего интереса. Вы можете добавить новый вручную',
                  maxLines: 2,
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
        )
      ],
    );
  }

  Widget sportInterestsGridView() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          padding: EdgeInsets.only(left: 10),
          width: width * 2,
          child: Wrap(
              spacing: 6.0,
              runSpacing: 6.0,
              verticalDirection: VerticalDirection.down,
              direction: Axis.horizontal,
              children: List.generate(
                  careerInterests.getCareerInterests().length, (index) {
                Color _colors = _randomColor.randomColor(
                    colorHue: ColorHue.custom(Range(200, 210)),
                    colorSaturation: ColorSaturation.highSaturation);
                return InkWell(
                  onTap: () => null,
                  splashColor: Colors.grey,
                  hoverColor: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  child: Chip(
                    padding: EdgeInsets.all(10),
                    backgroundColor: _colors,
                    shadowColor: Colors.grey,
                    label: Text(
                      careerInterests.getCareerInterests()[index],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              })),
        ));
  }

  Widget travelingInterestsGridView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: GridView.count(
          crossAxisCount: 7,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 8.0,
          children: List.generate(
              travelingInterests.getTravellingInterests().length, (index) {
            return Container(
              height: 17,
              child: Center(
                child: Text(
                  travelingInterests.getTravellingInterests()[index],
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          })),
    );
  }

  Widget generalInterestsGridView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: GridView.count(
          crossAxisCount: 7,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 8.0,
          children: List.generate(generalInterests.getGeneralInterests().length,
              (index) {
            return Container(
              height: 17,
              child: Center(
                child: Text(
                  generalInterests.getGeneralInterests()[index],
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          })),
    );
  }

  Widget popup18PlusAttentionWidget() {
    return Material(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35), topRight: Radius.circular(35)),
      child: Container(
        padding: EdgeInsets.only(top: 15),
        height: height / 3,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35), topRight: Radius.circular(35)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: width / 8),
                  Text('Раздел 18+',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(CupertinoIcons.clear_thick_circled),
                    color: Colors.grey.withOpacity(0.5),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.only(left: 15, right: 20),
              child: Text(
                'Этот раздел содержит материалы, которые могут носить деликатный характер. Желаете продолжить?',
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, color: Colors.grey),
              ),
            ),
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.only(top: height / 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 150,
                    height: 48,
                    child: Material(
                      borderRadius: BorderRadius.circular(11),
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: height * 0.10,
                          child: Center(
                              child: Text('Отмена',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 17))),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(color: Colors.grey, width: 0.5)),
                  ),
                  SizedBox(width: 12),
                  Container(
                      alignment: Alignment.center,
                      width: 150,
                      height: 48,
                      child: Material(
                        borderRadius: BorderRadius.circular(11),
                        color: Color.fromRGBO(145, 10, 251, 5),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: height * 0.10,
                            child: Center(
                                child: Text('Продолжить',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17))),
                          ),
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
