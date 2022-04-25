import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uny_app/Interests%20Database/Database/database_object.dart';
import 'package:uny_app/Interests%20Database/interests_database.dart';
import 'package:uny_app/Interests%20Model/all_interests_model.dart';
import 'package:uny_app/Interests%20Model/career_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/family_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/general_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/sport_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/travelling_interests_db_model.dart';
import 'package:uny_app/Shared%20Preferences/shared_preferences.dart';

class FilterInterestsVideoPage extends StatefulWidget{

  @override
  _FilterInterestsVideoPage createState() => _FilterInterestsVideoPage();
}


class _FilterInterestsVideoPage extends State<FilterInterestsVideoPage>{

  late InterestsDatabase? db;

  late double height;
  late double width;

  bool _isSearching = false;

  bool _isAllSelected = false;
  bool _isFamilySelected = true;
  bool _isCareerSelected = false;
  bool _isSportSelected = false;
  bool _isTravelingSelected = false;
  bool _isGeneralSelected = false;

  Future<List<FamilyInterestsModel>>? _familyInterestsFuture;
  Future<List<CareerInterestsModel>>? _careerInterestsFuture;
  Future<List<SportInterestsModel>>? _sportInterestsFuture;
  Future<List<TravellingInterestsModel>>? _travellingInterestsFuture;
  Future<List<GeneralInterestsModel>>? _generalInterestsFuture;

  List<AllInterestsModel>? _allInterestsList = [];
  List<FamilyInterestsModel>? _familyInterestsList = [];
  List<CareerInterestsModel>? _careerInterestsList = [];
  List<SportInterestsModel>? _sportInterestsList = [];
  List<TravellingInterestsModel>? _travelingInterestsList = [];
  List<GeneralInterestsModel>? _generalInterestsList = [];

  List<AllInterestsModel>? _allInterestsFilteredList = [];
  List<FamilyInterestsModel>? _familyFilteredList = [];
  List<CareerInterestsModel>? _careerFilteredList = [];
  List<SportInterestsModel>? _sportFilteredList = [];
  List<TravellingInterestsModel>? _travelingFilteredList = [];
  List<GeneralInterestsModel>? _generalFilteredList = [];

  List<AllInterestsModel>? _selectedAllInterests = [];
  List<FamilyInterestsModel>? _selectedFamilyInterests = [];
  List<CareerInterestsModel>? _selectedCareerInterests = [];
  List<SportInterestsModel>? _selectedSportInterests = [];
  List<TravellingInterestsModel>? _selectedTravelingInterests = [];
  List<GeneralInterestsModel>? _selectedGeneralInterests = [];

  List<Widget>? _allInterestsWidgetList;
  List<Widget>? _familyInterestsWidgetList;
  List<Widget>? _careerInterestsWidgetList;
  List<Widget>? _sportInterestsWidgetList;
  List<Widget>? _travelingInterestsWidgetList;
  List<Widget>? _generalInterestsWidgetList;

  @override
  void initState() {
    db = DatabaseObject.getDb;

    _familyInterestsFuture = db!.familyInterestsDao.getFamilyInterests().then((value) => _familyFilteredList = value);
    _careerInterestsFuture = db!.careerInterestsDao.getCareerInterests().then((value) => _careerFilteredList = value);
    _sportInterestsFuture = db!.sportInterestsDao.getSportInterests().then((value) => _sportFilteredList = value);
    _travellingInterestsFuture = db!.travelingInterestsDao.getTravelingInterests().then((value) => _travelingFilteredList = value);
    _generalInterestsFuture = db!.generalInterestsDao.getGeneralInterests().then((value) => _generalFilteredList = value);


    if(ShPreferences.getAllInterestsShPref() != null){
      _selectedAllInterests = ShPreferences.getAllInterestsShPref();
    }

    if(ShPreferences.getFamilyInterestsShPref() != null){
      _selectedFamilyInterests = ShPreferences.getFamilyInterestsShPref();
    }

    if(ShPreferences.getCareerInterestsShPref() != null){
      _selectedCareerInterests = ShPreferences.getCareerInterestsShPref();
    }

    if(ShPreferences.getSportInterestsShPref() != null){
      _selectedSportInterests = ShPreferences.getSportInterestsShPref();
    }

    if(ShPreferences.getTravelingInterestsShPref() != null){
      _selectedTravelingInterests = ShPreferences.getTravelingInterestsShPref();
    }

    if(ShPreferences.getGeneralInterestsShPref() != null){
      _selectedGeneralInterests = ShPreferences.getGeneralInterestsShPref();
    }

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      List<FamilyInterestsModel> familyInterests = await db!.familyInterestsDao.getFamilyInterests();
      List<CareerInterestsModel> careerInterests = await db!.careerInterestsDao.getCareerInterests();
      List<SportInterestsModel> sportInterests = await db!.sportInterestsDao.getSportInterests();
      List<TravellingInterestsModel> travelingInterests =  await db!.travelingInterestsDao.getTravelingInterests();
      List<GeneralInterestsModel> generalInterests = await db!.generalInterestsDao.getGeneralInterests();

      Map<String, String> familyInterestsMap = Map.fromIterable(familyInterests,
          key: (interest) => interest.name,
          value: (interest) => interest.color);

      Map<String, String> careerInterestsMap = Map.fromIterable(careerInterests,
          key: (interest) => interest.name,
          value: (interest) => interest.color);

      Map<String, String> sportInterestsMap = Map.fromIterable(sportInterests,
          key: (interest) => interest.name,
          value: (interest) => interest.color);

      Map<String, String> travelingInterestsMap = Map.fromIterable(travelingInterests,
          key: (interest) => interest.name,
          value: (interest) => interest.color);

      Map<String, String> generalInterestsMap = Map.fromIterable(generalInterests,
          key: (interest) => interest.name,
          value: (interest) => interest.color);

      Map<String, String> allInterestsMap = {};
      allInterestsMap.addAll(familyInterestsMap);
      allInterestsMap.addAll(careerInterestsMap);
      allInterestsMap.addAll(sportInterestsMap);
      allInterestsMap.addAll(travelingInterestsMap);
      allInterestsMap.addAll(generalInterestsMap);

      allInterestsMap.forEach((name, color) {
        _allInterestsList!.add(AllInterestsModel(name, color));
      });

      _allInterestsFilteredList = _allInterestsList!..shuffle();
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _allInterestsWidgetList = List.generate(_allInterestsFilteredList!.length, (index) {
      return Material(
        child: InkWell(
          onTap: () {
            _selectedAllInterests!.add(_allInterestsFilteredList![index]);
            setState(() {});
          },
          borderRadius:
          BorderRadius.all(Radius.circular(30)),
          child: Chip(
            visualDensity: VisualDensity.comfortable,
            padding: EdgeInsets.all(10),
            backgroundColor: Color(int.parse('0x' + _allInterestsFilteredList![index].color!)),
            shadowColor: Colors.grey,
            label: Text(
              _allInterestsFilteredList![index].name!,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {

    ShPreferences.setAllInterests(_selectedAllInterests);
    ShPreferences.setFamilyInterests(_selectedFamilyInterests);
    ShPreferences.setCareerInterests(_selectedCareerInterests);
    ShPreferences.setSportInterests(_selectedSportInterests);
    ShPreferences.setTravelingInterests(_selectedTravelingInterests);
    ShPreferences.setGeneralInterests(_selectedGeneralInterests);

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        return ResponsiveWrapper.builder(
            Scaffold(
              appBar: AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.grey),
                  onPressed: (){
                    int count = _selectedAllInterests!.length + _selectedFamilyInterests!.length
                        + _selectedCareerInterests!.length
                        + _selectedSportInterests!.length
                        + _selectedTravelingInterests!.length
                        + _selectedGeneralInterests!.length;

                    Navigator.pop(context, count);
                  }
                ),
                title: Container(
                  height: height / 23,
                  padding: EdgeInsets.only(right: width / 20),
                  child: TextFormField(
                    cursorColor: Color.fromRGBO(145, 10, 251, 5),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: height / 50),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      prefixIcon: _isSearching != true ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.search, color: Colors.grey),
                          Text('Поиск интересов', style: TextStyle(fontSize: 17, color: Colors.grey))
                        ],
                      ) : null,
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

                    onChanged: (value){
                      if(_isAllSelected){
                        _allInterestsFilteredList = _allInterestsFilteredList!.where((interest) => interest.name!.toLowerCase().startsWith(value.toLowerCase())).toList();
                      } else if(_isFamilySelected){
                        _familyFilteredList = _familyInterestsList!.where((interest) => interest.name!.toLowerCase().startsWith(value.toLowerCase())).toList();
                      }else if(_isCareerSelected){
                        _careerFilteredList = _careerInterestsList!.where((interest) => interest.name!.toLowerCase().startsWith(value.toLowerCase())).toList();
                      }else if(_isSportSelected){
                        _sportFilteredList = _sportInterestsList!.where((interest) => interest.name!.toLowerCase().startsWith(value.toLowerCase())).toList();
                      }else if(_isTravelingSelected){
                        _travelingFilteredList = _travelingInterestsList!.where((interest) => interest.name!.toLowerCase().startsWith(value.toLowerCase())).toList();
                      }else{
                        _generalFilteredList = _generalInterestsList!.where((interest) => interest.name!.toLowerCase().startsWith(value.toLowerCase())).toList();
                      }

                      setState(() {});


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
            )
        );
      },
    );
  }


  Widget mainBody() {
    return Wrap(
      children: [
        Padding(
            padding: EdgeInsets.only(top: height / 50, left: width / 20),
            child: Text('Выберите категорию', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold))
        ),
        Padding(
            padding: EdgeInsets.only(top: height / 40, left: width / 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  InkWell(
                    onTap: (){
                      setState(() {
                        _isAllSelected = true;

                        _isFamilySelected = false;
                        _isCareerSelected = false;
                        _isSportSelected = false;
                        _isTravelingSelected = false;
                        _isGeneralSelected = false;
                      });
                    },
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Container(
                      height: 35,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(child: Text('Все', style: TextStyle(fontSize: 15, color: Colors.black))),
                      decoration: BoxDecoration(
                          color: _isAllSelected ? Colors.purpleAccent.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: _isAllSelected ? Colors.purpleAccent : Colors.grey.withOpacity(0.2)
                          )
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isFamilySelected = true;

                        _isAllSelected = false;
                        _isCareerSelected = false;
                        _isSportSelected = false;
                        _isTravelingSelected = false;
                        _isGeneralSelected = false;
                      });
                    },
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Container(
                      height: 35,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(child: Text('Семья', style: TextStyle(fontSize: 15, color: _isFamilySelected ? Colors.white : Colors.black))),
                      decoration: BoxDecoration(
                          color:  _isFamilySelected ? Colors.green : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: _isFamilySelected ? Colors.green : Colors.grey.withOpacity(0.2)
                          )
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isCareerSelected = true;

                        _isFamilySelected = false;
                        _isAllSelected = false;
                        _isSportSelected = false;
                        _isTravelingSelected = false;
                        _isGeneralSelected = false;
                      });
                    },
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Container(
                      height: 35,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(child: Text('Карьера', style: TextStyle(fontSize: 15, color: _isCareerSelected ? Colors.white : Colors.black))),
                      decoration: BoxDecoration(
                          color: _isCareerSelected ? Colors.lightBlueAccent : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: _isCareerSelected ? Colors.lightBlueAccent : Colors.grey.withOpacity(0.2)
                          )
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isSportSelected = true;

                        _isCareerSelected = false;
                        _isFamilySelected = false;
                        _isAllSelected = false;
                        _isTravelingSelected = false;
                        _isGeneralSelected = false;
                      });
                    },
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Container(
                      height: 35,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(child: Text('Спорт', style: TextStyle(fontSize: 15, color: _isSportSelected ? Colors.white : Colors.black))),
                      decoration: BoxDecoration(
                          color: _isSportSelected ? Colors.blueAccent : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: _isSportSelected ? Colors.blueAccent : Colors.grey.withOpacity(0.2)
                          )
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isTravelingSelected = true;

                        _isSportSelected = false;
                        _isCareerSelected = false;
                        _isFamilySelected = false;
                        _isAllSelected = false;
                        _isGeneralSelected = false;
                      });
                    },
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Container(
                      height: 35,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(child: Text('Путешествия', style: TextStyle(fontSize: 15, color: _isTravelingSelected ? Colors.white : Colors.black))),
                      decoration: BoxDecoration(
                          color: _isTravelingSelected ? Colors.deepOrangeAccent : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: _isTravelingSelected ? Colors.deepOrangeAccent : Colors.grey.withOpacity(0.2)
                          )
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isGeneralSelected = true;

                        _isTravelingSelected = false;
                        _isSportSelected = false;
                        _isCareerSelected = false;
                        _isFamilySelected = false;
                        _isAllSelected = false;
                      });
                    },
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Container(
                      height: 35,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(child: Text('Общее', style: TextStyle(fontSize: 15, color: _isGeneralSelected ? Colors.white : Colors.black))),
                      decoration: BoxDecoration(
                          color: _isGeneralSelected ? Color.fromRGBO(145, 10, 251, 5) : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: _isGeneralSelected ? Color.fromRGBO(145, 10, 251, 5) : Colors.grey.withOpacity(0.2)
                          )
                      ),
                    ),
                  ),
                ],
              ),
            )
        ),
        SizedBox(height:  10),
        Padding(
          padding: EdgeInsets.only(top: height / 50),
          child: Divider(
            thickness: 10,
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
        SizedBox(height: height / 20),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: _isAllSelected
              ?  allSelectedInterests()
              : _isFamilySelected
              ? familySelectedInterests()
              : _isCareerSelected
              ? careerSelectedInterests()
              : _isSportSelected
              ? sportSelectedInterests()
              : _isTravelingSelected
              ? travelingSelectedInterests()
              : _isGeneralSelected
              ? generalSelectedInterests()
              : null
        ),
        Container(
            child: _isAllSelected
                   ? allInterestsGridView()
                   : _isFamilySelected
                   ? familyInterestsFutureBuilder()
                   : _isCareerSelected
                   ? careerInterestsFutureBuilder()
                   : _isSportSelected
                   ? sportInterestsFutureBuilder()
                   : _isTravelingSelected
                   ? travellingInterestsFutureBuilder()
                   : _isGeneralSelected
                   ? generalInterestsFutureBuilder()
                   : null
        ),
      ],
    );
  }

  FutureBuilder<List<FamilyInterestsModel>> familyInterestsFutureBuilder(){
    return FutureBuilder<List<FamilyInterestsModel>>(
      future: _familyInterestsFuture,
      builder: (context, snapshot) {
        while(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
              child: CircularProgressIndicator(color: Colors.green)
          );
        }

        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          _familyInterestsList = snapshot.data;

          _familyInterestsWidgetList = List.generate(_familyFilteredList!.length, (index) {
            return Material(
              child: InkWell(
                onTap: () {
                  _selectedFamilyInterests!.add(_familyFilteredList![index]);
                  setState(() {});
                },
                borderRadius:
                BorderRadius.all(Radius.circular(30)),
                child: Chip(
                  visualDensity: VisualDensity.comfortable,
                  padding: EdgeInsets.all(10),
                  backgroundColor: Color(int.parse('0x' + _familyFilteredList![index].color!)),
                  shadowColor: Colors.grey,
                  label: Text(
                    _familyFilteredList![index].name!,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          });

          return familyInterestsGridView();
        }else{
          return Center(
            child: Text('Error'),
          );
        }
      },
    );
  }

  FutureBuilder<List<CareerInterestsModel>> careerInterestsFutureBuilder(){
    return FutureBuilder<List<CareerInterestsModel>>(
      future: _careerInterestsFuture,
      builder: (context, snapshot) {

        while(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
              child: CircularProgressIndicator(color: Colors.lightBlueAccent)
          );
        }
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){

          _careerInterestsList = snapshot.data;

          _careerInterestsWidgetList = List.generate(_careerFilteredList!.length,
                  (index) {
                return Material(
                  child: InkWell(
                    onTap: () {
                      _selectedCareerInterests!.add(_careerFilteredList![index]);
                      setState((){});
                    },
                    borderRadius:
                    BorderRadius.all(Radius.circular(30)),
                    child: Chip(
                      visualDensity: VisualDensity.comfortable,
                      padding: EdgeInsets.all(10),
                      backgroundColor: Color(int.parse('0x' + _careerFilteredList![index].color!)),
                      shadowColor: Colors.grey,
                      label: Text(
                        _careerFilteredList![index].name!,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              });

          return careerInterestsGridView();
        }else{
          return Center(
            child: Text('Error'),
          );
        }
      },
    );
  }

  FutureBuilder<List<SportInterestsModel>> sportInterestsFutureBuilder(){
    return FutureBuilder<List<SportInterestsModel>>(
      future: _sportInterestsFuture,
      builder: (context, snapshot) {
        while(snapshot.connectionState == ConnectionState.waiting){
          return Center(
              child: CircularProgressIndicator(color: Colors.blue[800])
          );
        }

        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          _sportInterestsList = snapshot.data;

          _sportInterestsWidgetList = List.generate(_sportFilteredList!.length,
                  (index) {
                return Material(
                  child: InkWell(
                    onTap: () {
                      _selectedSportInterests!.add(_sportFilteredList![index]);

                      setState((){});
                    },
                    borderRadius:
                    BorderRadius.all(Radius.circular(30)),
                    child: Chip(
                      visualDensity: VisualDensity.comfortable,
                      padding: EdgeInsets.all(10),
                      backgroundColor: Color(int.parse('0x' + _sportFilteredList![index].color!)),
                      shadowColor: Colors.grey,
                      label: Text(
                        _sportFilteredList![index].name!,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              });

          return sportInterestsGridView();
        }else{
          return Center(
            child: Text('Error'),
          );
        }
      },
    );
  }

  FutureBuilder<List<TravellingInterestsModel>> travellingInterestsFutureBuilder(){
    return FutureBuilder<List<TravellingInterestsModel>>(
      future: _travellingInterestsFuture,
      builder: (context, snapshot) {
        while(snapshot.connectionState == ConnectionState.waiting){
          return Center(
              child: CircularProgressIndicator(color: Colors.deepOrange)
          );
        }

        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          _travelingInterestsList = snapshot.data;

          _travelingInterestsWidgetList = List.generate(_travelingFilteredList!.length,
                  (index) {
                return Material(
                  child: InkWell(
                    onTap: () {
                      _selectedTravelingInterests!.add(_travelingFilteredList![index]);

                      setState((){});
                    },
                    borderRadius:
                    BorderRadius.all(Radius.circular(30)),
                    child: Chip(
                      visualDensity: VisualDensity.comfortable,
                      padding: EdgeInsets.all(10),
                      backgroundColor: Color(int.parse('0x' + _travelingFilteredList![index].color!)),
                      shadowColor: Colors.grey,
                      label: Text(
                        _travelingFilteredList![index].name!,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              });

          return travelingInterestsGridView();
        }else{
          return Center(
            child: Text('Error'),
          );
        }
      },
    );
  }

  FutureBuilder<List<GeneralInterestsModel>> generalInterestsFutureBuilder(){
    return FutureBuilder<List<GeneralInterestsModel>>(
      future: _generalInterestsFuture,
      builder: (context, snapshot) {
        while(snapshot.connectionState == ConnectionState.waiting){
          return Center(
              child: CircularProgressIndicator(color: Colors.purpleAccent)
          );
        }
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          _generalInterestsList = snapshot.data;

          _generalInterestsWidgetList = List.generate(_generalFilteredList!.length,
                  (index) {
                return Material(
                  child: InkWell(
                    onTap: () {
                      _selectedGeneralInterests!.add(_generalFilteredList![index]);

                      setState((){});
                    },
                    borderRadius:
                    BorderRadius.all(Radius.circular(30)),
                    child: Chip(
                      visualDensity: VisualDensity.comfortable,
                      padding: EdgeInsets.all(10),
                      backgroundColor: Color(int.parse('0x' + _generalFilteredList![index].color!)),
                      shadowColor: Colors.grey,
                      label: Text(
                        _generalFilteredList![index].name!,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              });

          return generalInterestsGridView();
        }else{
          return Center(
            child: Text('Error'),
          );
        }
      },
    );
  }

  Widget allInterestsGridView() {
    didChangeDependencies();
    return Column(
      children: [
        Divider(
          thickness: 1,
        ),
        _allInterestsFilteredList!.length != 0 ? SizedBox(
            height: height / 1.35,
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container (
                      padding: EdgeInsets.only(left: 10),
                      width: width * 2,
                      child: Wrap(
                          spacing: 6.0,
                          runSpacing: 6.0,
                          children: _allInterestsWidgetList!
                      ),
                    )),
              ),
            )) : AnimatedPadding(
            duration: Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(
                vertical:  height / 5,
                horizontal: width / 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'По вашему запросу не найдено подходящего интереса',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            )
        )
      ],
    );
  }

  Widget familyInterestsGridView() {
    return Column(
      children: [
        Divider(
          thickness: 1,
        ),
        _familyFilteredList!.length != 0 ? SizedBox(
            height: height / 1.35,
            child: SafeArea (
              top: false,
              child: SingleChildScrollView (
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView (
                    scrollDirection: Axis.horizontal,
                    child: Container (
                      padding: EdgeInsets.only(left: 10),
                      width: width * 2,
                      child: Wrap(
                          spacing: 6.0,
                          runSpacing: 6.0,
                          children: _familyInterestsWidgetList!
                      ),
                    )),
              ),
            )) : AnimatedPadding(
            duration: Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(
                vertical:  height / 5,
                horizontal: width / 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'По вашему запросу не найдено подходящего интереса',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            )
        )
      ],
    );
  }

  Widget careerInterestsGridView(){
    return Column(
      children: [
        Divider(
          thickness: 1,
        ),
        _careerFilteredList!.length != 0 ? SizedBox(
            height: height / 1.35,
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
                          children: _careerInterestsWidgetList!
                      ),
                    )),
              ),
            )) : AnimatedPadding(
            duration: Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(
                vertical:  height / 5,
                horizontal: width / 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'По вашему запросу не найдено подходящего интереса. Вы можете добавить новый вручную',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            )
        )
      ],
    );
  }

  Widget sportInterestsGridView() {
    return Column(
      children: [
        Divider(
          thickness: 1,
        ),
        _sportFilteredList!.length != 0 ? SizedBox(
            height: height / 1.35,
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
                          children: _sportInterestsWidgetList!
                      ),
                    )),
              ),
            )) : AnimatedPadding(
            duration: Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(
                vertical:  height / 5,
                horizontal: width / 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'По вашему запросу не найдено подходящего интереса. Вы можете добавить новый вручную',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            )
        )
      ],
    );
  }

  Widget travelingInterestsGridView() {
    return Column(
      children: [
        Divider(
          thickness: 1,
        ),
        _travelingFilteredList!.length != 0 ? SizedBox(
            height: height / 1.35,
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
                          children: _travelingInterestsWidgetList!
                      ),
                    )),
              ),
            )) : AnimatedPadding(
            duration: Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(
                vertical:  height / 5,
                horizontal: width / 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'По вашему запросу не найдено подходящего интереса. Вы можете добавить новый вручную',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            )
        )
      ],
    );
  }

  Widget generalInterestsGridView() {
    return Column(
      children: [
        Divider(
          thickness: 1,
        ),
        _generalFilteredList!.length != 0 ? SizedBox(
            height: height / 1.35,
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
                          children: _generalInterestsWidgetList!
                      ),
                    )),
              ),
            )) : AnimatedPadding(
            duration: Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(
                vertical:  height / 5,
                horizontal: width / 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'По вашему запросу не найдено подходящего интереса. Вы можете добавить новый вручную',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            )
        )
      ],
    );
  }



  Widget allSelectedInterests(){
    return _selectedAllInterests!.length == 0
        ? Container() : SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: Wrap(
          spacing: 6.0,
          runSpacing: 6.0,
          children: List.generate(_selectedAllInterests!.length, (index) {
            return Material(
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: Chip(
                  labelPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                  visualDensity: VisualDensity.comfortable,
                  padding: EdgeInsets.all(6),
                  backgroundColor: Color(int.parse('0x' + _allInterestsFilteredList![index].color!)),
                  shadowColor: Colors.grey,
                  label: Text(
                    _selectedAllInterests![index].name!,
                    style: TextStyle(color: Colors.white),
                  ),
                  deleteIcon: Icon(CupertinoIcons.clear_circled,
                      color: Colors.white),
                  onDeleted: () {
                    _selectedAllInterests!.removeAt(index);
                    setState((){});
                  },
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget familySelectedInterests(){
    return _selectedAllInterests!.length == 0
        ? Container() : SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: Wrap(
          spacing: 6.0,
          runSpacing: 6.0,
          children: List.generate(_selectedAllInterests!.length, (index) {
            return Material(
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: Chip(
                  labelPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                  visualDensity: VisualDensity.comfortable,
                  padding: EdgeInsets.all(6),
                  backgroundColor: Color(int.parse('0x' + _allInterestsFilteredList![index].color!)),
                  shadowColor: Colors.grey,
                  label: Text(
                    _selectedAllInterests![index].name!,
                    style: TextStyle(color: Colors.white),
                  ),
                  deleteIcon: Icon(CupertinoIcons.clear_circled,
                      color: Colors.white),
                  onDeleted: () {
                    _selectedAllInterests!.removeAt(index);
                    setState((){});
                  },
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget careerSelectedInterests(){
    return _selectedCareerInterests!.length == 0
        ? Container(): SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: EdgeInsets.only(bottom: 5),
        child: Wrap(
          spacing: 6.0,
          runSpacing: 6.0,
          children: List.generate(_selectedCareerInterests!.length, (index) {
            return Material(
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: Chip(
                  labelPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                  visualDensity: VisualDensity.comfortable,
                  padding: EdgeInsets.all(10),
                  backgroundColor: Color(int.parse('0x' + _selectedCareerInterests![index].color!)),
                  shadowColor: Colors.grey,
                  label: Text(
                    _selectedCareerInterests![index].name!,
                    style: TextStyle(color: Colors.white),
                  ),
                  deleteIcon: Icon(CupertinoIcons.clear_circled,
                      color: Colors.white),
                  onDeleted: () {
                    _selectedCareerInterests!.removeAt(index);
                    setState((){});
                  },
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget sportSelectedInterests(){
    return _selectedSportInterests!.length == 0
        ? Container(): SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: EdgeInsets.only(bottom: 5),
        child: Wrap(
          spacing: 6.0,
          runSpacing: 6.0,
          children: List.generate(_selectedSportInterests!.length, (index) {
            return Material(
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: Chip(
                  labelPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                  visualDensity: VisualDensity.comfortable,
                  padding: EdgeInsets.all(10),
                  backgroundColor: Color(int.parse('0x' + _selectedSportInterests![index].color!)),
                  shadowColor: Colors.grey,
                  label: Text(
                    _selectedSportInterests![index].name!,
                    style: TextStyle(color: Colors.white),
                  ),
                  deleteIcon: Icon(CupertinoIcons.clear_circled,
                      color: Colors.white),
                  onDeleted: () {
                    _selectedSportInterests!.removeAt(index);

                    setState((){});
                  },
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget travelingSelectedInterests(){
    return _selectedTravelingInterests!.length == 0
        ? Container(): SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: EdgeInsets.only(bottom: 5),
        child: Wrap(
          spacing: 6.0,
          runSpacing: 6.0,
          children: List.generate(_selectedTravelingInterests!.length, (index) {
            return Material(
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: Chip(
                  labelPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                  visualDensity: VisualDensity.comfortable,
                  padding: EdgeInsets.all(10),
                  backgroundColor: Color(int.parse('0x' + _selectedTravelingInterests![index].color!)),
                  shadowColor: Colors.grey,
                  label: Text(
                    _selectedTravelingInterests![index].name!,
                    style: TextStyle(color: Colors.white),
                  ),
                  deleteIcon: Icon(CupertinoIcons.clear_circled,
                      color: Colors.white),
                  onDeleted: () {
                    _selectedTravelingInterests!.removeAt(index);

                    setState((){});
                  },
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget generalSelectedInterests(){
    return _selectedGeneralInterests!.length == 0
        ? Container() : SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: EdgeInsets.only(bottom: 5),
        child: Wrap(
          spacing: 6.0,
          runSpacing: 6.0,
          children: List.generate(_selectedGeneralInterests!.length, (index) {
            return Material(
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: Chip(
                  labelPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                  visualDensity: VisualDensity.comfortable,
                  padding: EdgeInsets.all(10),
                  backgroundColor: Color(int.parse('0x' + _selectedGeneralInterests![index].color!)),
                  shadowColor: Colors.grey,
                  label: Text(
                    _selectedGeneralInterests![index].name!,
                    style: TextStyle(color: Colors.white),
                  ),
                  deleteIcon: Icon(CupertinoIcons.clear_circled,
                      color: Colors.white),
                  onDeleted: () {
                    _selectedGeneralInterests!.removeAt(index);
                    setState((){});
                  },
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}