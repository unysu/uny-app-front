
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uny_app/Interests%20Database/Database/database_object.dart';
import 'package:uny_app/Interests%20Database/interests_database.dart';
import 'package:uny_app/Interests%20Model/interests_db_model.dart';
import 'package:uny_app/Shared%20Preferences/shared_preferences.dart';
import 'package:uny_app/Video%20Search%20Page/interests_counter_provider.dart';

class FilterInterestsVideoPage extends StatefulWidget{

  @override
  _FilterInterestsVideoPage createState() => _FilterInterestsVideoPage();
}


class _FilterInterestsVideoPage extends State<FilterInterestsVideoPage>{

  final TextEditingController _searchController = TextEditingController();
  
  ScrollController? _allInterestsScrollController;
  ScrollController? _careerInterestsScrollController;
  ScrollController? _travelingInterestsScrollController;
  ScrollController? _generalInterestsScrollController;

  int allInterestsStart = 0;
  int familyInterestsStart = 0;
  int careerInterestsStart = 0;
  int sportInterestsStart = 0;
  int travelingInterestsStart = 0;
  int generalInterestsStart = 0;
  int end = 150;

  late InterestsDatabase? db;

  late double height;
  late double width;

  bool _isSearching = false;

  bool _isAllSelected = true;
  bool _isFamilySelected = false;
  bool _isCareerSelected = false;
  bool _isSportSelected = false;
  bool _isTravelingSelected = false;
  bool _isGeneralSelected = false;

  Future<List<InterestsModel>>? _allInterestsFuture;
  Future<List<InterestsModel>>? _familyInterestsFuture;
  Future<List<InterestsModel>>? _careerInterestsFuture;
  Future<List<InterestsModel>>? _sportInterestsFuture;
  Future<List<InterestsModel>>? _travellingInterestsFuture;
  Future<List<InterestsModel>>? _generalInterestsFuture;

  List<InterestsModel>? _allInterestsList = [];
  List<InterestsModel>? _allInterestsFilteredList = [];
  List<InterestsModel>? _selectedAllInterests = [];

  List<InterestsModel>? _familyInterestsList = [];
  List<InterestsModel>? _familyFilteredList = [];
  final List<InterestsModel>? _selectedFamilyInterests = [];

  List<InterestsModel>? _careerInterestsList = [];
  List<InterestsModel>? _careerFilteredList = [];
  final List<InterestsModel>? _selectedCareerInterests = [];

  List<InterestsModel>? _sportInterestsList = [];
  List<InterestsModel>? _sportFilteredList = [];
  final List<InterestsModel>? _selectedSportInterests = [];

  List<InterestsModel>? _travelingInterestsList = [];
  List<InterestsModel>? _travelingFilteredList = [];
  final List<InterestsModel>? _selectedTravelingInterests = [];

  List<InterestsModel>? _generalInterestsList = [];
  List<InterestsModel>? _generalFilteredList = [];
  final List<InterestsModel>? _selectedGeneralInterests = [];


  @override
  void initState() {

    _allInterestsScrollController = ScrollController();
    _careerInterestsScrollController = ScrollController();
    _travelingInterestsScrollController = ScrollController();
    _generalInterestsScrollController = ScrollController();

    _allInterestsScrollController!.addListener(() async {
      if(_allInterestsScrollController!.position.atEdge) {
        if(_allInterestsFilteredList!.length < 6504){
          allInterestsStart += 150;
          List<InterestsModel> allInterests = await db!.interestsModelDao.getAllInterestsByLimit(allInterestsStart.toString(), end.toString());
          setState(() {
            _allInterestsFilteredList!.addAll(allInterests);
          });
        }else if(_allInterestsFilteredList!.length == 6504){
          return;
        }else{
          return;
        }
      }
    });

    _careerInterestsScrollController!.addListener(() async {
      if(_careerInterestsScrollController!.position.atEdge) {
        if(_careerFilteredList!.length < 1619){
          careerInterestsStart += 150;
          List<InterestsModel> allInterests = await db!.interestsModelDao.getCareerInterestsByLimit(careerInterestsStart.toString(), end.toString());
          setState(() {
            _careerFilteredList!.addAll(allInterests);
          });
        }else if(_careerFilteredList!.length == 1619){
          return;
        }else{
          return;
        }
      }
    });

    _travelingInterestsScrollController!.addListener(() async {
      if(_travelingInterestsScrollController!.position.atEdge) {
        if(_travelingFilteredList!.length < 1415){
          travelingInterestsStart += 150;
          List<InterestsModel> allInterests = await db!.interestsModelDao.getTravelingInterestsByLimit(travelingInterestsStart.toString(), end.toString());
          setState(() {
            _travelingFilteredList!.addAll(allInterests);
          });
        }else if(_travelingFilteredList!.length == 1415){
          return;
        }else{
          return;
        }
      }
    });

    _generalInterestsScrollController!.addListener(() async {
      if(_generalInterestsScrollController!.position.atEdge) {
        if(_generalFilteredList!.length < 3446){
          generalInterestsStart += 80;
          List<InterestsModel> allInterests = await db!.interestsModelDao.getGeneralInterestsByLimit(generalInterestsStart.toString(), end.toString());
          setState(() {
            _generalFilteredList!.addAll(allInterests);
          });
        }else if(_generalFilteredList!.length == 3446){
          return;
        }else{
          return;
        }
      }
    });

    
     db = DatabaseObject.getDb;
    _sportInterestsFuture = db!.interestsModelDao.getSportInterestsByLimit().then((value) => _sportFilteredList = value);
    _familyInterestsFuture = db!.interestsModelDao.getFamilyInterestsByLimit().then((value) => _familyFilteredList = value);
    _allInterestsFuture = db!.interestsModelDao.getAllInterestsByLimit(allInterestsStart.toString(), end.toString()).then((value) => _allInterestsFilteredList = value);
    _careerInterestsFuture = db!.interestsModelDao.getCareerInterestsByLimit(careerInterestsStart.toString(), end.toString()).then((value) => _careerFilteredList = value);
    _travellingInterestsFuture = db!.interestsModelDao.getTravelingInterestsByLimit(travelingInterestsStart.toString(), end.toString()).then((value) => _travelingFilteredList = value);
    _generalInterestsFuture = db!.interestsModelDao.getGeneralInterestsByLimit(generalInterestsStart.toString(), end.toString()).then((value) => _generalFilteredList = value);


    if(ShPreferences.getAllInterestsShPref().isNotEmpty){
      _selectedAllInterests = ShPreferences.getAllInterestsShPref();
    }

    super.initState();
  }

  @override
  void dispose() {

    ShPreferences.setAllInterests(_selectedAllInterests);

    _searchController.dispose();

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
                    Navigator.pop(context);
                  }
              ),
              title: Container(
                height: height / 23,
                padding: EdgeInsets.only(right: width / 20),
                child: TextFormField(
                  controller: _searchController,
                  cursorColor: Color.fromRGBO(145, 10, 251, 5),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: height / 50),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.1),
                    prefixIcon: _isSearching != true ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
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

                  onChanged: (value) async {
                    if(_isAllSelected){
                      _allInterestsFilteredList = _allInterestsList!.where((interest) => interest.name!.toLowerCase().startsWith(value.toLowerCase())).toList();
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


                    if (value.isEmpty) {
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
          maxWidth: 800,
          minWidth: 450,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: MOBILE),
          ],
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
                ? familyInterestsGridView()
                : _isCareerSelected
                ? careerInterestsGridView()
                : _isSportSelected
                ? sportInterestsGridView()
                : _isTravelingSelected
                ? travelingInterestsGridView()
                : _isGeneralSelected
                ? generalInterestsGridView()
                : null
        ),
      ],
    );
  }

  FutureBuilder<List<InterestsModel>> allInterestsFutureBuilder(){
    return FutureBuilder<List<InterestsModel>>(
      future: _allInterestsFuture,
      builder: (context, snapshot) {
        while(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
              child: CircularProgressIndicator(color: Colors.green)
          );
        }

        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          _allInterestsList = List.from(snapshot.data!.toList());

          return allInterestsGridView();
        }else{
          return Center(
            child: Text('Error'),
          );
        }
      },
    );
  }

  FutureBuilder<List<InterestsModel>> familyInterestsFutureBuilder(){
    return FutureBuilder<List<InterestsModel>>(
      future: _familyInterestsFuture,
      builder: (context, snapshot) {
        while(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
              child: CircularProgressIndicator(color: Colors.green)
          );
        }

        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          _familyInterestsList = List.from(snapshot.data!.toList());

          return familyInterestsGridView();
        }else{
          return Center(
            child: Text('Error'),
          );
        }
      },
    );
  }

  FutureBuilder<List<InterestsModel>> careerInterestsFutureBuilder(){
    return FutureBuilder<List<InterestsModel>>(
      future: _careerInterestsFuture,
      builder: (context, snapshot) {

        while(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
              child: CircularProgressIndicator(color: Colors.lightBlueAccent)
          );
        }
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          _careerInterestsList = List.from(snapshot.data!.toList());

          return careerInterestsGridView();
        }else{
          return Center(
            child: Text('Error'),
          );
        }
      },
    );
  }

  FutureBuilder<List<InterestsModel>> sportInterestsFutureBuilder(){
    return FutureBuilder<List<InterestsModel>>(
      future: _sportInterestsFuture,
      builder: (context, snapshot) {
        while(snapshot.connectionState == ConnectionState.waiting){
          return Center(
              child: CircularProgressIndicator(color: Colors.blue[800])
          );
        }

        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          _sportInterestsList = List.from(snapshot.data!.toList());

          return sportInterestsGridView();
        }else{
          return Center(
            child: Text('Error'),
          );
        }
      },
    );
  }

  FutureBuilder<List<InterestsModel>> travellingInterestsFutureBuilder(){
    return FutureBuilder<List<InterestsModel>>(
      future: _travellingInterestsFuture,
      builder: (context, snapshot) {
        while(snapshot.connectionState == ConnectionState.waiting){
          return Center(
              child: CircularProgressIndicator(color: Colors.deepOrange)
          );
        }

        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          _travelingInterestsList = List.from(snapshot.data!.toList());

          return travelingInterestsGridView();
        }else{
          return Center(
            child: Text('Error'),
          );
        }
      },
    );
  }

  FutureBuilder<List<InterestsModel>> generalInterestsFutureBuilder(){
    return FutureBuilder<List<InterestsModel>>(
      future: _generalInterestsFuture,
      builder: (context, snapshot) {
        while(snapshot.connectionState == ConnectionState.waiting){
          return Center(
              child: CircularProgressIndicator(color: Colors.purpleAccent)
          );
        }
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          _generalInterestsList = List.from(snapshot.data!.toList());

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
    if(_allInterestsList!.isNotEmpty){
      return Column(
        children: [
          Divider(
            thickness: 1,
          ),
          _allInterestsFilteredList!.isNotEmpty ? SizedBox(
              height: height / 1.21,
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  controller: _allInterestsScrollController,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        width: width / 0.5,
                        child: Wrap(
                            spacing: 7.0,
                            runSpacing: 9.0,
                            children: List.generate(_allInterestsFilteredList!.length, (index) {
                              return Material(
                                child: InkWell(
                                    onTap: () {
                                      _selectedAllInterests!.add(_allInterestsFilteredList![index]);

                                      _allInterestsFilteredList!.removeAt(index);

                                      Provider.of<InterestsCounterProvider>(context, listen: false).incrementCounter();

                                      setState(() {
                                        _isSearching = false;
                                        _searchController.clear();
                                      });
                                    },
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Center(
                                        widthFactor: 1,
                                        child: Text(
                                          _allInterestsFilteredList![index].name!,
                                          style: const TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(30)),
                                          gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Color(int.parse('0x' + _allInterestsFilteredList![index].startColor!)),
                                                Color(int.parse('0x' + _allInterestsFilteredList![index].endColor!))
                                              ]
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color(int.parse('0x' + _allInterestsFilteredList![index].startColor!)).withOpacity(0.7),
                                                offset: Offset(3, 3),
                                                blurRadius: 0,
                                                spreadRadius: 0
                                            )
                                          ]
                                      ),
                                    )
                                ),
                              );
                            })
                        ),
                      )),
                ),
              )) : AnimatedPadding(
              duration: const Duration(milliseconds: 150),
              padding: EdgeInsets.symmetric(
                  vertical:  height / 5,
                  horizontal: width / 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
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
    }else{
      return allInterestsFutureBuilder();
    }
  }

  Widget familyInterestsGridView() {
    if(_familyInterestsList!.isNotEmpty){
      return Column(
        children: [
          Divider(
            thickness: 1,
          ),
          _familyFilteredList!.isNotEmpty ? SizedBox(
              height: height / 1.21,
              child: SafeArea (
                top: false,
                child: SingleChildScrollView (
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView (
                      scrollDirection: Axis.horizontal,
                      child: Container (
                        padding: EdgeInsets.only(left: 10),
                        width: width / 0.5,
                        child: Wrap(
                            spacing: 8.0,
                            runSpacing: 10.0,
                            children: List.generate(_familyFilteredList!.length, (index) {
                              return Material(
                                child: InkWell(
                                    onTap: () {
                                      _selectedAllInterests!.add(_familyFilteredList![index]);

                                      _selectedFamilyInterests!.add(_familyFilteredList![index]);

                                      _familyFilteredList!.removeAt(index);

                                      Provider.of<InterestsCounterProvider>(context,listen: false).incrementCounter();

                                      setState(() {
                                        _isSearching = false;
                                        _searchController.clear();
                                      });
                                    },
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Center(
                                        widthFactor: 1,
                                        child: Text(
                                          _familyFilteredList![index].name!,
                                          style: const TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(30)),
                                          gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Color(int.parse('0x' + _familyFilteredList![index].startColor!)),
                                                Color(int.parse('0x' + _familyFilteredList![index].endColor!))
                                              ]
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color(int.parse('0x' + _familyFilteredList![index].startColor!)).withOpacity(0.7),
                                                offset: Offset(3, 3),
                                                blurRadius: 0,
                                                spreadRadius: 0
                                            )
                                          ]
                                      ),
                                    )
                                ),
                              );
                            })
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
                children: const [
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
    }else{
      return familyInterestsFutureBuilder();
    }
  }

  Widget careerInterestsGridView(){
    if(_careerInterestsList!.isNotEmpty){
      return Column(
        children: [
          Divider(
            thickness: 1,
          ),
          _careerFilteredList!.isNotEmpty ? SizedBox(
              height: height / 1.21,
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  controller: _careerInterestsScrollController,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        width: width / 0.5,
                        child: Wrap(
                            spacing: 8.0,
                            runSpacing: 10.0,
                            children: List.generate(_careerFilteredList!.length,
                                    (index) {
                                  return Material(
                                    child: InkWell(
                                        onTap: () {
                                          _selectedAllInterests!.add(_careerFilteredList![index]);

                                          _selectedCareerInterests!.add(_careerFilteredList![index]);

                                          _careerFilteredList!.removeAt(index);

                                          Provider.of<InterestsCounterProvider>(context,listen: false).incrementCounter();

                                          setState(() {
                                            _isSearching = false;
                                            _searchController.clear();
                                          });
                                        },
                                        borderRadius: BorderRadius.all(Radius.circular(30)),
                                        child: Container(
                                          height: 40,
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Center(
                                            widthFactor: 1,
                                            child: Text(
                                              _careerFilteredList![index].name!,
                                              style: const TextStyle(color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(30)),
                                              gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [
                                                    Color(int.parse('0x' + _careerFilteredList![index].startColor!)),
                                                    Color(int.parse('0x' + _careerFilteredList![index].endColor!))
                                                  ]
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color(int.parse('0x' + _careerFilteredList![index].startColor!)).withOpacity(0.7),
                                                    offset: Offset(3, 3),
                                                    blurRadius: 0,
                                                    spreadRadius: 0
                                                )
                                              ]
                                          ),
                                        )
                                    ),
                                  );
                                })
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
                children: const [
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
    }else{
      return careerInterestsFutureBuilder();
    }
  }

  Widget sportInterestsGridView() {
    if(_sportInterestsList!.isNotEmpty){
      return Column(
        children: [
          Divider(
            thickness: 1,
          ),
          _sportFilteredList!.isNotEmpty ? SizedBox(
              height: height / 1.21,
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        width: width / 0.5,
                        child: Wrap(
                            spacing: 8.0,
                            runSpacing: 10.0,
                            children: List.generate(_sportFilteredList!.length,
                                    (index) {
                                  return Material(
                                    child: InkWell(
                                        onTap: () {
                                          _selectedAllInterests!.add(_sportFilteredList![index]);

                                          _selectedSportInterests!.add(_sportFilteredList![index]);

                                          _sportFilteredList!.removeAt(index);

                                          Provider.of<InterestsCounterProvider>(context,listen: false).incrementCounter();

                                          setState(() {
                                            _isSearching = false;
                                            _searchController.clear();
                                          });
                                        },
                                        borderRadius: BorderRadius.all(Radius.circular(30)),
                                        child: Container(
                                          height: 40,
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Center(
                                            widthFactor: 1,
                                            child: Text(
                                              _sportFilteredList![index].name!,
                                              style: const TextStyle(color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(30)),
                                              gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [
                                                    Color(int.parse('0x' + _sportFilteredList![index].startColor!)),
                                                    Color(int.parse('0x' + _sportFilteredList![index].endColor!))
                                                  ]
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color(int.parse('0x' + _sportFilteredList![index].startColor!)).withOpacity(0.7),
                                                    offset: Offset(3, 3),
                                                    blurRadius: 0,
                                                    spreadRadius: 0
                                                )
                                              ]
                                          ),
                                        )
                                    ),
                                  );
                                })
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
                children: const [
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
    }else{
      return sportInterestsFutureBuilder();
    }
  }

  Widget travelingInterestsGridView() {
    if(_travelingInterestsList!.isNotEmpty){
      return Column(
        children: [
          Divider(
            thickness: 1,
          ),
          _travelingFilteredList!.isNotEmpty ? SizedBox(
              height: height / 1.21,
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  controller: _travelingInterestsScrollController,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        width: width / 0.5,
                        child: Wrap(
                            spacing: 8.0,
                            runSpacing: 10.0,
                            children: List.generate(_travelingFilteredList!.length,
                                    (index) {
                                  return Material(
                                    child: InkWell(
                                        onTap: () {
                                          _selectedAllInterests!.add(_travelingFilteredList![index]);

                                          _selectedTravelingInterests!.add(_travelingFilteredList![index]);

                                          _travelingFilteredList!.removeAt(index);

                                          Provider.of<InterestsCounterProvider>(context,listen: false).incrementCounter();

                                          setState(() {
                                            _isSearching = false;
                                            _searchController.clear();
                                          });
                                        },
                                        borderRadius: BorderRadius.all(Radius.circular(30)),
                                        child: Container(
                                          height: 40,
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Center(
                                            widthFactor: 1,
                                            child: Text(
                                              _travelingFilteredList![index].name!,
                                              style: const TextStyle(color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(30)),
                                              gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [
                                                    Color(int.parse('0x' + _travelingFilteredList![index].startColor!)),
                                                    Color(int.parse('0x' + _travelingFilteredList![index].endColor!))
                                                  ]
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color(int.parse('0x' + _travelingFilteredList![index].startColor!)).withOpacity(0.7),
                                                    offset: Offset(3, 3),
                                                    blurRadius: 0,
                                                    spreadRadius: 0
                                                )
                                              ]
                                          ),
                                        )
                                    ),
                                  );
                                })
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
                children: const [
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
    }else{
      return travellingInterestsFutureBuilder();
    }
  }

  Widget generalInterestsGridView() {
    if(_generalInterestsList!.isNotEmpty){
      return Column(
        children: [
          Divider(
            thickness: 1,
          ),
          _generalFilteredList!.isNotEmpty ? SizedBox(
              height: height / 1.21,
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  controller: _generalInterestsScrollController,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        width: width / 0.5,
                        child: Wrap(
                            spacing: 8.0,
                            runSpacing: 10.0,
                            children: List.generate(_generalFilteredList!.length,
                                    (index) {
                                  return Material(
                                    child: InkWell(
                                        onTap: () {
                                          _selectedAllInterests!.add(_generalFilteredList![index]);

                                          _selectedGeneralInterests!.add(_generalFilteredList![index]);

                                          _generalFilteredList!.removeAt(index);

                                          Provider.of<InterestsCounterProvider>(context,listen: false).incrementCounter();

                                          setState(() {
                                            _isSearching = false;
                                            _searchController.clear();
                                          });
                                        },
                                        borderRadius: BorderRadius.all(Radius.circular(30)),
                                        child: Container(
                                          height: 40,
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Center(
                                            widthFactor: 1,
                                            child: Text(
                                              _generalFilteredList![index].name!,
                                              style: const TextStyle(color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(30)),
                                              gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [
                                                    Color(int.parse('0x' + _generalFilteredList![index].startColor!)),
                                                    Color(int.parse('0x' + _generalFilteredList![index].endColor!))
                                                  ]
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color(int.parse('0x' + _generalFilteredList![index].startColor!)).withOpacity(0.7),
                                                    offset: Offset(3, 3),
                                                    blurRadius: 0,
                                                    spreadRadius: 0
                                                )
                                              ]
                                          ),
                                        )
                                    ),
                                  );
                                })
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
                children: const [
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
    }else{
      return generalInterestsFutureBuilder();
    }
  }



  Widget allSelectedInterests(){
    return _selectedAllInterests!.isEmpty
        ? Container() : Container(
        width: width * 2,
        height: 50,
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: List.generate(_selectedAllInterests!.length, (index) {
              return Material(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 10),
                  child: IntrinsicWidth(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectedAllInterests![index].name!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: IconButton(
                            icon: const Icon(CupertinoIcons.clear_circled, color: Colors.white),
                            onPressed: (){

                              switch(_selectedAllInterests![index].type){
                                case 'family':
                                  _selectedFamilyInterests!.remove(_selectedAllInterests![index]);

                                  _familyFilteredList = List.from(_familyInterestsList!.toList());
                                  break;
                                case 'career':
                                  _selectedCareerInterests!.remove(_selectedAllInterests![index]);

                                  _careerFilteredList = List.from(_careerInterestsList!.toList());
                                  break;
                                case 'sport':
                                  _selectedSportInterests!.remove(_selectedAllInterests![index]);

                                  _sportFilteredList = List.from(_sportInterestsList!.toList());
                                  break;
                                case 'traveling':
                                  _selectedTravelingInterests!.remove(_selectedAllInterests![index]);

                                  _travelingFilteredList = List.from(_travelingInterestsList!.toList());
                                  break;
                                case 'general':
                                  _selectedGeneralInterests!.remove(_selectedAllInterests![index]);

                                  _generalFilteredList = List.from(_generalInterestsList!.toList());
                                  break;
                              }

                              _selectedAllInterests!.removeAt(index);

                              _allInterestsFilteredList = List.from(_allInterestsList!.toList());


                              Provider.of<InterestsCounterProvider>(context,listen: false).decrementCounter();

                              setState((){});
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(int.parse('0x' + _selectedAllInterests![index].startColor!)),
                            Color(int.parse('0x' + _selectedAllInterests![index].endColor!))
                          ]
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Color(int.parse('0x' + _selectedAllInterests![index].startColor!)).withOpacity(0.7),
                            offset: const Offset(3, 3),
                            blurRadius: 0,
                            spreadRadius: 0
                        )
                      ]
                  ),
                ),
              );
            }).reversed.toList(),
          ),
        )
    );
  }

  Widget familySelectedInterests(){
    return _selectedFamilyInterests!.isEmpty
        ? Container() : Container(
        width: width * 2,
        height: 50,
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: List.generate(_selectedFamilyInterests!.length, (index) {
              return Material(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 10),
                  child: IntrinsicWidth(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectedFamilyInterests![index].name!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: IconButton(
                            icon: const Icon(CupertinoIcons.clear_circled, color: Colors.white),
                            onPressed: (){
                              _selectedAllInterests!.removeWhere((element) => element.name.toString().startsWith(_selectedFamilyInterests![index].name.toString()));

                              _selectedFamilyInterests!.removeAt(index);

                              _familyFilteredList = List.from(_familyInterestsList!.toList());

                              Provider.of<InterestsCounterProvider>(context,listen: false).decrementCounter();

                              setState((){});
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(int.parse('0x' + _selectedFamilyInterests![index].startColor!)),
                            Color(int.parse('0x' + _selectedFamilyInterests![index].endColor!))
                          ]
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Color(int.parse('0x' + _selectedFamilyInterests![index].startColor!)).withOpacity(0.7),
                            offset: const Offset(3, 3),
                            blurRadius: 0,
                            spreadRadius: 0
                        )
                      ]
                  ),
                ),
              );
            }).reversed.toList(),
          ),
        )
    );
  }

  Widget careerSelectedInterests(){
    return _selectedCareerInterests!.isEmpty
        ? Container(): Container(
        width: width * 2,
        height: 50,
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: List.generate(_selectedCareerInterests!.length, (index) {
              return Material(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 10),
                  child: IntrinsicWidth(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectedCareerInterests![index].name!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: IconButton(
                            icon: const Icon(CupertinoIcons.clear_circled, color: Colors.white),
                            onPressed: (){
                              _selectedAllInterests!.removeWhere((element) => element.name.toString().startsWith(_selectedCareerInterests![index].name.toString()));

                              _selectedCareerInterests!.removeAt(index);

                              _careerFilteredList = List.from(_careerInterestsList!.toList());

                              Provider.of<InterestsCounterProvider>(context,listen: false).decrementCounter();

                              setState((){});
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(int.parse('0x' + _selectedCareerInterests![index].startColor!)),
                            Color(int.parse('0x' + _selectedCareerInterests![index].endColor!))
                          ]
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Color(int.parse('0x' + _selectedCareerInterests![index].startColor!)).withOpacity(0.7),
                            offset: const Offset(3, 3),
                            blurRadius: 0,
                            spreadRadius: 0
                        )
                      ]
                  ),
                ),
              );
            }).reversed.toList(),
          ),
        )
    );
  }

  Widget sportSelectedInterests(){
    return _selectedSportInterests!.isEmpty
        ? Container(): Container(
        width: width * 2,
        height: 50,
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: List.generate(_selectedSportInterests!.length, (index) {
              return Material(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 10),
                  child: IntrinsicWidth(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectedSportInterests![index].name!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: IconButton(
                            icon: const Icon(CupertinoIcons.clear_circled, color: Colors.white),
                            onPressed: (){
                              _selectedAllInterests!.removeWhere((element) => element.name.toString().startsWith(_selectedSportInterests![index].name.toString()));

                              _selectedSportInterests!.removeAt(index);

                              _sportFilteredList = List.from(_sportInterestsList!.toList());

                              Provider.of<InterestsCounterProvider>(context,listen: false).decrementCounter();

                              setState((){});
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(int.parse('0x' + _selectedSportInterests![index].startColor!)),
                            Color(int.parse('0x' + _selectedSportInterests![index].endColor!))
                          ]
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Color(int.parse('0x' + _selectedSportInterests![index].startColor!)).withOpacity(0.7),
                            offset: const Offset(3, 3),
                            blurRadius: 0,
                            spreadRadius: 0
                        )
                      ]
                  ),
                ),
              );
            }).reversed.toList(),
          ),
        )
    );
  }

  Widget travelingSelectedInterests(){
    return _selectedTravelingInterests!.isEmpty
        ? Container(): Container(
        width: width * 2,
        height: 50,
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: List.generate(_selectedTravelingInterests!.length, (index) {
              return Material(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 10),
                  child: IntrinsicWidth(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectedTravelingInterests![index].name!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: IconButton(
                            icon: const Icon(CupertinoIcons.clear_circled, color: Colors.white),
                            onPressed: (){
                              _selectedAllInterests!.removeWhere((element) => element.name.toString().startsWith(_selectedTravelingInterests![index].name.toString()));

                              _selectedTravelingInterests!.removeAt(index);

                              _travelingFilteredList = List.from(_travelingInterestsList!.toList());

                              Provider.of<InterestsCounterProvider>(context,listen: false).decrementCounter();

                              setState((){});
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(int.parse('0x' + _selectedTravelingInterests![index].startColor!)),
                            Color(int.parse('0x' + _selectedTravelingInterests![index].endColor!))
                          ]
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Color(int.parse('0x' + _selectedTravelingInterests![index].startColor!)).withOpacity(0.7),
                            offset: const Offset(3, 3),
                            blurRadius: 0,
                            spreadRadius: 0
                        )
                      ]
                  ),
                ),
              );
            }).reversed.toList(),
          ),
        )
    );
  }

  Widget generalSelectedInterests(){
    return _selectedGeneralInterests!.isEmpty
        ? Container() : Container(
        width: width * 2,
        height: 50,
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: List.generate(_selectedGeneralInterests!.length, (index) {
              return Material(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 10),
                  child: IntrinsicWidth(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectedGeneralInterests![index].name!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: IconButton(
                            icon: const Icon(CupertinoIcons.clear_circled, color: Colors.white),
                            onPressed: (){
                              _selectedAllInterests!.removeWhere((element) => element.name.toString().startsWith(_selectedGeneralInterests![index].name.toString()));

                              _selectedGeneralInterests!.removeAt(index);

                              _generalFilteredList = List.from(_generalInterestsList!.toList());

                              Provider.of<InterestsCounterProvider>(context,listen: false).decrementCounter();

                              setState((){});
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(int.parse('0x' + _selectedGeneralInterests![index].startColor!)),
                            Color(int.parse('0x' + _selectedGeneralInterests![index].endColor!))
                          ]
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Color(int.parse('0x' + _selectedGeneralInterests![index].startColor!)).withOpacity(0.7),
                            offset: Offset(3, 3),
                            blurRadius: 0,
                            spreadRadius: 0
                        )
                      ]
                  ),
                ),
              );
            }).reversed.toList(),
          ),
        )
    );
  }
}