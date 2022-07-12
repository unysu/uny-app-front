import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uny_app/API/uny_app_api.dart';
import 'package:uny_app/Constants/constants.dart';
import 'package:uny_app/Data%20Models/Interests%20Data%20Model/interests_data_model.dart';
import 'package:uny_app/Interests%20Database/Database/database_object.dart';
import 'package:uny_app/Interests%20Database/interests_database.dart';
import 'package:uny_app/Interests%20Model/interests_db_model.dart';
import 'package:uny_app/Providers/user_data_provider.dart';
import 'package:uny_app/Token%20Data/token_data.dart';


class EditInterestsPage extends StatefulWidget {

  @override
  _EditInterestsPage createState() => _EditInterestsPage();
}

class _EditInterestsPage extends State<EditInterestsPage> with SingleTickerProviderStateMixin{

  late String token;

  late InterestsDatabase? db;

  late double height;
  late double width;

  bool _isSearching = false;

  StateSetter? interestsState;

  TabController? _tabController;
  PageController? _pageViewController;

  final TextEditingController _searchController = TextEditingController();

  ScrollController? _allInterestsScrollController;
  ScrollController? _careerInterestsScrollController;
  ScrollController? _travelingInterestsScrollController;
  ScrollController? _generalInterestsScrollController;

  bool _showLoading = false;

  bool _isAllSelected = true;
  bool _isFamilySelected = false;
  bool _isCareerSelected = false;
  bool _isSportSelected = false;
  bool _isTravelingSelected = false;
  bool _isGeneralSelected = false;

  int allInterestsStart = 0;
  int familyInterestsStart = 0;
  int careerInterestsStart = 0;
  int sportInterestsStart = 0;
  int travelingInterestsStart = 0;
  int generalInterestsStart = 0;
  int end = 150;

  Future<List<InterestsModel>>? _allInterestsFuture;
  Future<List<InterestsModel>>? _familyInterestsFuture;
  Future<List<InterestsModel>>? _careerInterestsFuture;
  Future<List<InterestsModel>>? _sportInterestsFuture;
  Future<List<InterestsModel>>? _travellingInterestsFuture;
  Future<List<InterestsModel>>? _generalInterestsFuture;

  List<InterestsModel>? _allInterestsList = [];
  List<InterestsModel>? _allInterestsFilteredList = [];
  final List<InterestsModel>? _selectedAllInterests = [];

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

  List<InterestsDataModel>? _familyInterests;
  List<InterestsDataModel>? _careerInterests;
  List<InterestsDataModel>? _sportInterests;
  List<InterestsDataModel>? _travelingInterests;
  List<InterestsDataModel>? _generalInterests;

  final int _page = 0;

  final List<String>? _deletedInterests = [];

  @override
  void initState() {

    token = 'Bearer ' + TokenData.getUserToken();

    _tabController = TabController(length: 2, vsync: this);

    _pageViewController = PageController(
        initialPage: _page
    );

    _allInterestsScrollController = ScrollController();
    _careerInterestsScrollController = ScrollController();
    _travelingInterestsScrollController = ScrollController();
    _generalInterestsScrollController = ScrollController();

    _allInterestsScrollController!.addListener(() async {
      if(_allInterestsScrollController!.position.atEdge) {
        if(_allInterestsFilteredList!.length < 6504){
          allInterestsStart += 150;
          List<InterestsModel> allInterests = await db!.interestsModelDao.getAllInterestsByLimit(allInterestsStart.toString(), end.toString());
          interestsState!(() {
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
          interestsState!(() {
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
          interestsState!(() {
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
          interestsState!(() {
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
    _sportInterestsFuture = db!.interestsModelDao.getSportInterestsByLimit().then((value) => _sportInterestsList = value).whenComplete(() => _sportFilteredList = List.from(_sportInterestsList!.toList()));
    _familyInterestsFuture = db!.interestsModelDao.getFamilyInterestsByLimit().then((value) => _familyInterestsList = value).whenComplete(() => _familyFilteredList = List.from(_familyInterestsList!.toList()));
    _allInterestsFuture = db!.interestsModelDao.getAllInterestsByLimit(allInterestsStart.toString(), end.toString()).then((value) => _allInterestsList = value).whenComplete(() => _allInterestsFilteredList = List.from(_allInterestsList!.toList()));
    _careerInterestsFuture = db!.interestsModelDao.getCareerInterestsByLimit(careerInterestsStart.toString(), end.toString()).then((value) => _careerInterestsList = value).whenComplete(() => _careerFilteredList = List.from(_careerInterestsList!.toList()));
    _travellingInterestsFuture = db!.interestsModelDao.getTravelingInterestsByLimit(travelingInterestsStart.toString(), end.toString()).then((value) => _travelingInterestsList = value).whenComplete(() => _travelingFilteredList = List.from(_travelingInterestsList!.toList()));
    _generalInterestsFuture = db!.interestsModelDao.getGeneralInterestsByLimit(generalInterestsStart.toString(), end.toString()).then((value) => _generalInterestsList = value).whenComplete(() => _generalFilteredList = List.from(_generalInterestsList!.toList()));


    _familyInterests = Provider.of<UserDataProvider>(context, listen: false).interestsDataModel!.where((element) => element.type == 'family').toList();
    _careerInterests = Provider.of<UserDataProvider>(context, listen: false).interestsDataModel!.where((element) => element.type == 'career').toList();
    _sportInterests = Provider.of<UserDataProvider>(context, listen: false).interestsDataModel!.where((element) => element.type == 'sport').toList();
    _travelingInterests = Provider.of<UserDataProvider>(context, listen: false).interestsDataModel!.where((element) => element.type == 'traveling').toList();
    _generalInterests = Provider.of<UserDataProvider>(context, listen: false).interestsDataModel!.where((element) => element.type == 'general').toList();

    for(int i = 0; i < _familyInterests!.length; i++){
      _selectedAllInterests!.add(InterestsModel.ForDB(_familyInterests![i].interest, _familyInterests![i].type, _familyInterests![i].color));

      _selectedFamilyInterests!.add(InterestsModel.ForDB(_familyInterests![i].interest, _familyInterests![i].type, _familyInterests![i].color));
    }

    for(int i = 0; i < _careerInterests!.length; i++){
      _selectedAllInterests!.add(InterestsModel.ForDB(_careerInterests![i].interest, _careerInterests![i].type, _careerInterests![i].color));

      _selectedCareerInterests!.add(InterestsModel.ForDB(_careerInterests![i].interest, _careerInterests![i].type, _careerInterests![i].color));
    }

    for(int i = 0; i < _sportInterests!.length; i++){
      _selectedAllInterests!.add(InterestsModel.ForDB(_sportInterests![i].interest, _sportInterests![i].type, _sportInterests![i].color));

      _selectedSportInterests!.add(InterestsModel.ForDB(_sportInterests![i].interest, _sportInterests![i].type, _sportInterests![i].color));
    }

    for(int i = 0; i < _travelingInterests!.length; i++){
      _selectedAllInterests!.add(InterestsModel.ForDB(_travelingInterests![i].interest, _travelingInterests![i].type, _travelingInterests![i].color));

      _selectedTravelingInterests!.add(InterestsModel.ForDB(_travelingInterests![i].interest, _travelingInterests![i].type, _travelingInterests![i].color));
    }

    for(int i = 0; i < _generalInterests!.length; i++){
      _selectedAllInterests!.add(InterestsModel.ForDB(_generalInterests![i].interest, _generalInterests![i].type, _generalInterests![i].color));

      _selectedGeneralInterests!.add(InterestsModel.ForDB(_generalInterests![i].interest, _generalInterests![i].type, _generalInterests![i].color));
    }

    super.initState();
  }

  @override
  void dispose() {
    _allInterestsScrollController!.dispose();
    _careerInterestsScrollController!.dispose();
    _travelingInterestsScrollController!.dispose();
    _generalInterestsScrollController!.dispose();
    _pageViewController!.dispose();
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
                  onPressed: () => updateInterests()
                ),
                title: Container(
                  height: height / 23,
                  padding: EdgeInsets.only(right: width / 20),
                  child: TextFormField(
                    cursorColor: Color.fromRGBO(145, 10, 251, 5),
                    controller: _searchController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: height / 50),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      prefixIcon: _isSearching != true ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(CupertinoIcons.search, color: Colors.grey),
                          Text('Поиск интересов',
                              style: TextStyle(
                                  fontSize: 17, color: Colors.grey))
                        ],
                      ): null,
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
                bottom: TabBar (
                  controller: _tabController,
                  indicatorColor: Color.fromRGBO(145, 10, 251, 5),
                  labelColor: Color.fromRGBO(145, 10, 251, 5),
                  unselectedLabelColor: Colors.grey,
                  padding: EdgeInsets.symmetric(horizontal: width / 7),
                  tabs: const [
                    Tab(
                        text: 'Мои интересы'
                    ),
                    Tab(
                      text: 'Рекомендуемые',
                    )
                  ],
                  onTap: (pageIndex){
                    _pageViewController!.animateToPage(pageIndex, duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
                  },
                ),
              ),
              body: StatefulBuilder(
                builder: (context, setState){
                  interestsState = setState;
                  return mainBody();
                },
              )
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Divider(
          thickness: 5,
        ),
        Expanded(
          child: PageView(
            controller: _pageViewController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Container(
                child: Wrap(
                  children: [
                    StatefulBuilder(
                      builder: (context, setState){
                        interestsState = setState;
                        return Column(
                          children: [
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
                            Stack(
                              children: [
                                Container(
                                    child: _isAllSelected
                                        ? allInterestsFutureBuilder()
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
                                _showLoading ? Center(
                                  heightFactor: 4,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                      height: 80,
                                      width: 80,
                                      color: Colors.black.withOpacity(0.7),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ) : Container()
                              ],
                            )
                          ],
                        );
                      },
                    )
                  ],
                )
              ),
              Padding(
                  padding: EdgeInsets.only(top: height / 100, left: width / 20),
                  child: Text('В тренде', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold))
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
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

                                      switch(_allInterestsFilteredList![index].type){
                                        case 'family':
                                          _selectedFamilyInterests!.add(_allInterestsFilteredList![index]);

                                          _familyFilteredList!.removeWhere((element) => element.name!.startsWith(_allInterestsFilteredList![index].name.toString()));
                                          break;
                                        case 'career':
                                          _selectedCareerInterests!.add(_allInterestsFilteredList![index]);

                                          _careerFilteredList!.removeWhere((element) => element.name!.startsWith(_allInterestsFilteredList![index].name.toString()));
                                          break;
                                        case 'sport':
                                          _selectedSportInterests!.add(_allInterestsFilteredList![index]);

                                          _sportFilteredList!.removeWhere((element) => element.name!.startsWith(_allInterestsFilteredList![index].name.toString()));
                                          break;
                                        case 'traveling':
                                          _selectedTravelingInterests!.add(_allInterestsFilteredList![index]);

                                          _travelingFilteredList!.removeWhere((element) => element.name!.startsWith(_allInterestsFilteredList![index].name.toString()));
                                          break;
                                        case 'general':
                                          _selectedGeneralInterests!.add(_allInterestsFilteredList![index]);

                                          _generalFilteredList!.removeWhere((element) => element.name!.startsWith(_allInterestsFilteredList![index].name.toString()));
                                          break;
                                      }

                                      _allInterestsFilteredList!.removeAt(index);

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
                                          color: Color(int.parse('0x' + _allInterestsFilteredList![index].color!)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color(int.parse('0x' + _allInterestsFilteredList![index].color!)).withOpacity(0.7),
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
  }

  Widget familyInterestsGridView() {
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
                                          color: Color(int.parse('0x' + _familyFilteredList![index].color!)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.green[800]!,
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
  }

  Widget careerInterestsGridView(){
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
                                              color: Color(int.parse('0x' + _careerFilteredList![index].color!)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.blue[600]!,
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
  }

  Widget sportInterestsGridView() {
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
                                              color: Color(int.parse('0x' + _sportFilteredList![index].color!)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.blue[600]!,
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
  }

  Widget travelingInterestsGridView() {
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
                                              color: Color(int.parse('0x' + _travelingFilteredList![index].color!)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.orange[800]!,
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
  }

  Widget generalInterestsGridView() {
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
                                              color: Color(int.parse('0x' + _generalFilteredList![index].color!)),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.deepPurple,
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
                                  _selectedFamilyInterests!.removeWhere((element) => element.name!.startsWith(_selectedAllInterests![index].name!));

                                  _familyFilteredList = List.from(_familyInterestsList!.toList());
                                  break;
                                case 'career':
                                  _selectedCareerInterests!.removeWhere((element) => element.name!.startsWith(_selectedAllInterests![index].name!));

                                  _careerFilteredList = List.from(_careerInterestsList!.toList());
                                  break;
                                case 'sport':
                                  _selectedSportInterests!.removeWhere((element) => element.name!.startsWith(_selectedAllInterests![index].name!));

                                  _sportFilteredList = List.from(_sportInterestsList!.toList());
                                  break;
                                case 'traveling':
                                  _selectedTravelingInterests!.removeWhere((element) => element.name!.startsWith(_selectedAllInterests![index].name!));

                                  _travelingFilteredList = List.from(_travelingInterestsList!.toList());
                                  break;
                                case 'general':
                                  _selectedGeneralInterests!.removeWhere((element) => element.name!.startsWith(_selectedAllInterests![index].name!));

                                  _generalFilteredList = List.from(_generalInterestsList!.toList());
                                  break;
                              }

                              _deletedInterests!.add(_selectedAllInterests![index].name!);

                              _selectedAllInterests!.removeAt(index);

                              _allInterestsFilteredList = List.from(_allInterestsList!.toList());

                              setState((){});
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      color: Color(int.parse('0x' + _selectedAllInterests![index].color!)),
                      boxShadow: [
                        BoxShadow(
                            color: Color(int.parse('0x' + _selectedAllInterests![index].color!)).withOpacity(0.7),
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

                              _deletedInterests!.add(_selectedFamilyInterests![index].name!);

                              _selectedFamilyInterests!.removeAt(index);

                              _familyFilteredList = List.from(_familyInterestsList!.toList());

                              setState((){});
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      color: Color(int.parse('0x' + _selectedFamilyInterests![index].color!)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.green[800]!,
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

                              _deletedInterests!.add(_selectedCareerInterests![index].name!);

                              _selectedCareerInterests!.removeAt(index);

                              _careerFilteredList = List.from(_careerInterestsList!.toList());

                              setState((){});
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      color: Color(int.parse('0x' + _selectedCareerInterests![index].color!)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.blue[600]!,
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

                              _deletedInterests!.add(_selectedSportInterests![index].name!);

                              _selectedSportInterests!.removeAt(index);

                              _sportFilteredList = List.from(_sportInterestsList!.toList());

                              setState((){});
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      color: Color(int.parse('0x' + _selectedSportInterests![index].color!)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.blue[600]!,
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

                              _deletedInterests!.add(_selectedTravelingInterests![index].name!);

                              _selectedTravelingInterests!.removeAt(index);

                              _travelingFilteredList = List.from(_travelingInterestsList!.toList());

                              setState((){});
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      color: Color(int.parse('0x' + _selectedTravelingInterests![index].color!)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.orange[800]!,
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

                              _deletedInterests!.add(_selectedGeneralInterests![index].name!);

                              _selectedGeneralInterests!.removeAt(index);

                              _generalFilteredList = List.from(_generalInterestsList!.toList());

                              setState((){});
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      color: Color(int.parse('0x' + _selectedGeneralInterests![index].color!)),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.deepPurple,
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


  void updateInterests() async {

    Map<String, String> newInterestsMap = {};

    List<Map<String, String>> newInterestsList = [];

    setState((){
      _showLoading = true;
    });

    for(int i = 0; i < _selectedAllInterests!.length; i++){
      newInterestsMap = {};

      newInterestsMap.addAll({
        'type' : '${_selectedAllInterests![i].type}',
        'interest' : '${_selectedAllInterests![i].name}',
        'color' : '${_selectedAllInterests![i].color}'
      });

      newInterestsList.add(newInterestsMap);
    }
    

    var removeData = {
      'interests' : jsonEncode(_deletedInterests)
    };

    var newInterestsData = {
      'interests' : jsonEncode(newInterestsList)
    };


    await UnyAPI.create(Constants.SIMPLE_RESPONSE_CONVERTER).addInterests(token, newInterestsData);

    await UnyAPI.create(Constants.INTERESTS_MODEL_CONVERTER).removeInterests(token, removeData).then((value){
      Provider.of<UserDataProvider>(context, listen: false).setInterestsDataModel(value.body!.interests);

      Navigator.pop(context);
    });

  }

}