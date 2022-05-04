import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uny_app/Interests%20Database/Database/database_object.dart';
import 'package:uny_app/Interests%20Database/interests_database.dart';
import 'package:uny_app/Interests%20Model/all_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/career_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/family_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/general_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/sport_interests_db_model.dart';
import 'package:uny_app/Interests%20Model/travelling_interests_db_model.dart';

class EditInterestsPage extends StatefulWidget {

  @override
  _EditInterestsPage createState() => _EditInterestsPage();
}

class _EditInterestsPage extends State<EditInterestsPage> with SingleTickerProviderStateMixin{

  late InterestsDatabase? db;

  late double height;
  late double width;

  bool _isSearching = false;

  TabController? _tabController;
  PageController? _pageViewController;

  ScrollController? _allInterestsScrollController;
  ScrollController? _careerInterestsScrollController;
  ScrollController? _travelingInterestsScrollController;
  ScrollController? _generalInterestsScrollController;

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

  Future<List<AllInterestsModel>>? _allInterestsFuture;
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

  int _page = 0;

  @override
  void initState() {

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
          List<AllInterestsModel> allInterests = await db!.allInterestsDao.getAllInterestsByLimit(allInterestsStart.toString(), end.toString());
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
          List<CareerInterestsModel> allInterests = await db!.careerInterestsDao.getCareerInterestsByLimit(careerInterestsStart.toString(), end.toString());
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
          List<TravellingInterestsModel> allInterests = await db!.travelingInterestsDao.getTravelingInterestsByLimit(travelingInterestsStart.toString(), end.toString());
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
          List<GeneralInterestsModel> allInterests = await db!.generalInterestsDao.getGeneralInterestsByLimit(generalInterestsStart.toString(), end.toString());
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
    _allInterestsFuture = db!.allInterestsDao.getAllInterestsByLimit(allInterestsStart.toString(), end.toString()).then((value) => _allInterestsFilteredList = value);
    _familyInterestsFuture = db!.familyInterestsDao.getFamilyInterestsByLimit(familyInterestsStart.toString(), end.toString()).then((value) => _familyFilteredList = value);
    _careerInterestsFuture = db!.careerInterestsDao.getCareerInterestsByLimit(careerInterestsStart.toString(), end.toString()).then((value) => _careerFilteredList = value);
    _sportInterestsFuture = db!.sportInterestsDao.getSportInterestsByLimit(sportInterestsStart.toString(), end.toString()).then((value) => _sportFilteredList = value);
    _travellingInterestsFuture = db!.travelingInterestsDao.getTravelingInterestsByLimit(travelingInterestsStart.toString(), end.toString()).then((value) => _travelingFilteredList = value);
    _generalInterestsFuture = db!.generalInterestsDao.getGeneralInterestsByLimit(generalInterestsStart.toString(), end.toString()).then((value) => _generalFilteredList = value);

    super.initState();
  }

  @override
  void dispose() {
    _allInterestsScrollController!.dispose();
    _careerInterestsScrollController!.dispose();
    _travelingInterestsScrollController!.dispose();
    _generalInterestsScrollController!.dispose();
    _pageViewController!.dispose();
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
               onPressed: () => Navigator.pop(context),
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
               tabs: [
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


  FutureBuilder<List<AllInterestsModel>> allInterestsFutureBuilder(){
    return FutureBuilder<List<AllInterestsModel>>(
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
    if(_allInterestsList!.length != 0){
      return Column(
        children: [
          Divider(
            thickness: 1,
          ),
          _allInterestsFilteredList!.length != 0 ? SizedBox(
              height: height / 1.21,
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  controller: _allInterestsScrollController,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container (
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

                                      setState(() {});
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
    }else{
      return allInterestsFutureBuilder();
    }
  }

  Widget familyInterestsGridView() {
    if(_familyInterestsList!.length != 0){
      return Column(
        children: [
          Divider(
            thickness: 1,
          ),
          _familyFilteredList!.length != 0 ? SizedBox(
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
                                      _selectedFamilyInterests!.add(_familyFilteredList![index]);

                                      _familyFilteredList!.removeAt(index);

                                      setState(() {});
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
    }else{
      return familyInterestsFutureBuilder();
    }
  }

  Widget careerInterestsGridView(){
    if(_careerInterestsList!.length != 0){
      return Column(
        children: [
          Divider(
            thickness: 1,
          ),
          _careerFilteredList!.length != 0 ? SizedBox(
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
                                          _selectedCareerInterests!.add(_careerFilteredList![index]);

                                          _careerFilteredList!.removeAt(index);

                                          setState((){});
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
    }else{
      return careerInterestsFutureBuilder();
    }
  }

  Widget sportInterestsGridView() {
    if(_sportInterestsList!.length != 0){
      return Column(
        children: [
          Divider(
            thickness: 1,
          ),
          _sportFilteredList!.length != 0 ? SizedBox(
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
                                          _selectedSportInterests!.add(_sportFilteredList![index]);

                                          _sportFilteredList!.removeAt(index);

                                          setState((){});
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
    }else{
      return sportInterestsFutureBuilder();
    }
  }

  Widget travelingInterestsGridView() {
    if(_travelingInterestsList!.length != 0){
      return Column(
        children: [
          Divider(
            thickness: 1,
          ),
          _travelingFilteredList!.length != 0 ? SizedBox(
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
                                          _selectedTravelingInterests!.add(_travelingFilteredList![index]);

                                          _travelingFilteredList!.removeAt(index);

                                          setState((){});
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
    }else{
      return travellingInterestsFutureBuilder();
    }
  }

  Widget generalInterestsGridView() {
    if(_generalInterestsList!.length != 0){
      return Column(
        children: [
          Divider(
            thickness: 1,
          ),
          _generalFilteredList!.length != 0 ? SizedBox(
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
                                          _selectedGeneralInterests!.add(_generalFilteredList![index]);

                                          _generalFilteredList!.removeAt(index);

                                          setState((){});
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
                                              boxShadow: [
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

                              int indx = _allInterestsList!.indexOf(_selectedAllInterests![index]);
                              _allInterestsFilteredList!.insert(indx, _selectedAllInterests![index]);

                              _selectedAllInterests!.removeAt(index);
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
    return _selectedFamilyInterests!.length == 0
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

                              int indx = _familyInterestsList!.indexOf(_selectedFamilyInterests![index]);
                              _familyFilteredList!.insert(indx, _selectedFamilyInterests![index]);

                              _selectedFamilyInterests!.removeAt(index);

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
    return _selectedCareerInterests!.length == 0
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
                              int indx = _careerInterestsList!.indexOf(_selectedCareerInterests![index]);
                              _careerFilteredList!.insert(indx, _selectedCareerInterests![index]);

                              _selectedCareerInterests!.removeAt(index);

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
    return _selectedSportInterests!.length == 0
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
                              int indx = _sportInterestsList!.indexOf(_selectedSportInterests![index]);
                              _sportFilteredList!.insert(indx, _selectedSportInterests![index]);

                              _selectedSportInterests!.removeAt(index);

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
    return _selectedTravelingInterests!.length == 0
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
                              int indx = _travelingInterestsList!.indexOf(_selectedTravelingInterests![index]);
                              _travelingFilteredList!.insert(indx, _selectedTravelingInterests![index]);

                              _selectedTravelingInterests!.removeAt(index);
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
    return _selectedGeneralInterests!.length == 0
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
                              int indx = _generalInterestsList!.indexOf(_selectedGeneralInterests![index]);
                              _generalFilteredList!.insert(indx, _selectedGeneralInterests![index]);

                              _selectedGeneralInterests!.removeAt(index);

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
                      boxShadow: [
                        BoxShadow(
                            color: Colors.deepPurple,
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

}