import 'dart:convert';
import 'dart:math';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/API/uny_app_api.dart';
import 'package:uny_app/Constants/constants.dart';
import 'package:uny_app/Data%20Models/Interests%20Data%20Model/interests_data_model.dart';
import 'package:uny_app/Data%20Models/Media%20Data%20Model/media_data_model.dart';
import 'package:uny_app/Data%20Models/Photo%20Search%20Data%20Model/photo_search_data_model.dart';
import 'package:uny_app/Interests%20Model/interests_db_model.dart';
import 'package:uny_app/Shared%20Preferences/shared_preferences.dart';
import 'package:uny_app/Token%20Data/token_data.dart';
import 'package:uny_app/Other%20Users%20Page/other_users_page.dart';
import 'package:uny_app/Video%20Search%20Page/interests_counter_provider.dart';
import 'package:uny_app/Zodiac%20Signs/zodiac_signs.dart';
import '../Video Search Page/filter_interests_page.dart';

class PhotoSearchPage extends StatefulWidget {
  @override
  _PhotoSearchPageState createState() => _PhotoSearchPageState();
}

class _PhotoSearchPageState extends State<PhotoSearchPage> {
  late String token;

  late double height;
  late double width;

  late FocusNode _startAgeFieldFocusNode;
  late FocusNode _endAgeFieldFocusNode;

  late TextEditingController _startAgeFieldTextController;
  late TextEditingController _endAgeFieldTextController;

  StateSetter? _indicatorsState;
  StateSetter? _usersListState;
  StateSetter? _secondaryUsersListState;

  bool _usersLoaded = false;
  bool _isSearching = false;

  Future<Response<PhotoSearchDataModel>>? _photoSearchFuture;

  List<Matches>? _matchedUsersList;
  List<Matches>? _secondaryUsersList;

  List<int>? _photosIndexes;

  bool _isManSelected = false;
  bool _isWomanSelected = false;
  bool _isAnotherSelected = false;

  bool _isSmaller18StartAgeField = false;
  bool _isGreater100StartAgeField = false;

  bool _isSmaller18EndAgeField = false;
  bool _isGreater100EndAgeField = false;

  @override
  void initState() {
    token = 'Bearer ' + TokenData.getUserToken();

    var data = {'only_above_percent': 0};

    _photoSearchFuture = UnyAPI.create(Constants.PHOTO_SEARCH_MODEL_CONVERTER)
        .getUserPhotoSearch(token, data);

    _startAgeFieldFocusNode = FocusNode();
    _endAgeFieldFocusNode = FocusNode();

    _startAgeFieldTextController = TextEditingController();
    _endAgeFieldTextController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _photoSearchFuture!.whenComplete(() {
        _usersLoaded = true;
        setState(() {});
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _startAgeFieldFocusNode.dispose();
    _endAgeFieldFocusNode.dispose();

    _startAgeFieldTextController.dispose();
    _endAgeFieldTextController.dispose();

    ShPreferences.clear();

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
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                toolbarHeight: height / 7,
                title: Padding(
                  padding: EdgeInsets.only(top: height / 30),
                  child: Column(
                    children: [
                      TextFormField(
                        cursorColor: Color.fromRGBO(145, 10, 251, 5),
                        textAlign: TextAlign.center,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: height / 50),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.1),
                          prefixIcon: _isSearching != true
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(CupertinoIcons.search,
                                        color: AdaptiveTheme.of(context).mode ==
                                                AdaptiveThemeMode.light
                                            ? Colors.grey
                                            : Colors.white),
                                    SizedBox(width: 10),
                                    Text('Поиск людей',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: AdaptiveTheme.of(context)
                                                        .mode ==
                                                    AdaptiveThemeMode.light
                                                ? Colors.grey
                                                : Colors.white))
                                  ],
                                )
                              : null,
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.1))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.1))),
                        ),
                        onFieldSubmitted: (value) async {
                          var data = {'name': value};

                          await UnyAPI.create(
                                  Constants.PHOTO_SEARCH_MODEL_CONVERTER)
                              .searchUserByName(token, data)
                              .then((value) {
                            _matchedUsersList = value.body!.matches;

                            _secondaryUsersList =
                                List.from(_matchedUsersList!.toList());

                            _secondaryUsersList!.sort((a, b) =>
                                int.parse(b.matchPercent.toString()).compareTo(
                                    int.parse(a.matchPercent.toString())));

                            _usersListState!(() {});
                            _secondaryUsersListState!(() {});
                          });
                        },
                        onChanged: (value) {
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
                    ],
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: _usersLoaded ? 80 : 20,
                      width: width,
                      padding: EdgeInsets.only(left: 10, bottom: 10),
                      child: _usersLoaded
                          ? StatefulBuilder(
                              builder: (context, setState) {
                                _secondaryUsersListState = setState;
                                return GridView.count(
                                  crossAxisCount: 1,
                                  mainAxisSpacing: 15,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: List.generate(
                                      _secondaryUsersList!.length, (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    OtherUsersPage(
                                                        user:
                                                            _secondaryUsersList![
                                                                index])));
                                      },
                                      child: Stack(
                                        children: [
                                          ClipOval(
                                            child: Container(
                                                child: _secondaryUsersList![
                                                                index]
                                                            .media!
                                                            .mainPhoto !=
                                                        null
                                                    ? CachedNetworkImage(
                                                        imageUrl:
                                                            _secondaryUsersList![
                                                                    index]
                                                                .media!
                                                                .mainPhoto!
                                                                .url,
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            image: DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.4),
                                                                spreadRadius:
                                                                    10,
                                                                blurRadius: 7,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        placeholder: (context,
                                                                url) =>
                                                            Shimmer.fromColors(
                                                          baseColor:
                                                              Colors.grey[300]!,
                                                          highlightColor:
                                                              Colors.white,
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: Colors
                                                                        .grey,
                                                                    shape: BoxShape
                                                                        .circle),
                                                          ),
                                                        ),
                                                      )
                                                    : ClipOval(
                                                        child: Container(
                                                          child: Center(
                                                            child: Icon(
                                                                Icons
                                                                    .account_circle_rounded,
                                                                size: 75,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle),
                                                        ),
                                                      )),
                                          ),
                                          _secondaryUsersList![index]
                                                      .media!
                                                      .mainPhoto !=
                                                  null
                                              ? Positioned(
                                                  child: ClipOval(
                                                  child: SizedBox(
                                                    height: 70,
                                                    width: 70,
                                                    child:
                                                        SimpleCircularProgressBar(
                                                      valueNotifier: ValueNotifier(
                                                          double.parse(
                                                              _secondaryUsersList![
                                                                      index]
                                                                  .matchPercent
                                                                  .toString())),
                                                      backColor:
                                                          Colors.grey[300]!,
                                                      animationDuration: 0,
                                                      backStrokeWidth: 10,
                                                      progressStrokeWidth: 10,
                                                      startAngle: 187,
                                                      progressColors: const [
                                                        Colors.red,
                                                        Colors.yellowAccent,
                                                        Colors.green
                                                      ],
                                                    ),
                                                  ),
                                                ))
                                              : Positioned(
                                                  left: 2,
                                                  top: 2,
                                                  child: ClipOval(
                                                    child: SizedBox(
                                                      height: 70,
                                                      width: 70,
                                                      child:
                                                          SimpleCircularProgressBar(
                                                        valueNotifier: ValueNotifier(
                                                            double.parse(
                                                                _secondaryUsersList![
                                                                        index]
                                                                    .matchPercent
                                                                    .toString())),
                                                        backColor:
                                                            Colors.grey[300]!,
                                                        animationDuration: 0,
                                                        backStrokeWidth: 10,
                                                        progressStrokeWidth: 10,
                                                        startAngle: 187,
                                                        progressColors: const [
                                                          Colors.red,
                                                          Colors.yellowAccent,
                                                          Colors.green
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                          Positioned.fill(
                                              bottom: 0,
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 6),
                                                  child: Text(
                                                      '${_secondaryUsersList![index].matchPercent} %',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                  decoration: BoxDecoration(
                                                    color: _secondaryUsersList![
                                                                    index]
                                                                .matchPercent <
                                                            49
                                                        ? Colors.red
                                                        : (_secondaryUsersList![
                                                                            index]
                                                                        .matchPercent >
                                                                    49 &&
                                                                _secondaryUsersList![
                                                                            index]
                                                                        .matchPercent <
                                                                    65)
                                                            ? Colors.orange
                                                            : (_secondaryUsersList![
                                                                            index]
                                                                        .matchPercent >
                                                                    65)
                                                                ? Colors.green
                                                                : null,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    );
                                  }),
                                );
                              },
                            )
                          : Container(),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Знакомства',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w500)),
                          GestureDetector(
                            onTap: () {
                              if (UniversalPlatform.isIOS) {
                                showCupertinoModalBottomSheet(
                                    context: context,
                                    duration: Duration(milliseconds: 250),
                                    topRadius: Radius.circular(25),
                                    builder: (context) {
                                      return DraggableScrollableSheet(
                                        initialChildSize:
                                            _startAgeFieldFocusNode.hasFocus ||
                                                    _endAgeFieldFocusNode
                                                        .hasFocus
                                                ? 0.9
                                                : 0.6,
                                        maxChildSize: 1,
                                        minChildSize: 0.6,
                                        expand: false,
                                        builder: (context, scrollController) {
                                          return SingleChildScrollView(
                                              controller: scrollController,
                                              physics: ClampingScrollPhysics(),
                                              child: showSearchFilterOptions());
                                        },
                                      );
                                    });
                              } else if (UniversalPlatform.isAndroid) {
                                showCupertinoModalBottomSheet(
                                    context: context,
                                    duration: Duration(milliseconds: 250),
                                    builder: (context) {
                                      return DraggableScrollableSheet(
                                        initialChildSize:
                                            _startAgeFieldFocusNode.hasFocus ||
                                                    _endAgeFieldFocusNode
                                                        .hasFocus
                                                ? 0.9
                                                : 0.6,
                                        maxChildSize: 1,
                                        minChildSize: 0.6,
                                        expand: false,
                                        builder: (context, scrollController) {
                                          return SingleChildScrollView(
                                              controller: scrollController,
                                              physics: ClampingScrollPhysics(),
                                              child: showSearchFilterOptions());
                                        },
                                      );
                                    });
                              }
                            },
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),
                              child: Container(
                                width: 120,
                                height: 35,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset('assets/settings.svg'),
                                    SizedBox(width: 5),
                                    Text('Фильтры',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: const [
                                  Color.fromRGBO(255, 0, 92, 10),
                                  Color.fromRGBO(255, 172, 47, 10),
                                ])),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    searchUsers()
                  ],
                ),
              )),
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

  FutureBuilder<Response<PhotoSearchDataModel>> searchUsers() {
    return FutureBuilder<Response<PhotoSearchDataModel>>(
      future: _photoSearchFuture,
      builder: (context, snapshot) {
        while (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            heightFactor: 20,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Color.fromRGBO(145, 10, 251, 5),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          _matchedUsersList = snapshot.data!.body!.matches;
          _secondaryUsersList = List.from(_matchedUsersList!.toList());

          _secondaryUsersList!.sort((a, b) =>
              int.parse(b.matchPercent.toString())
                  .compareTo(int.parse(a.matchPercent.toString())));

          _photosIndexes =
              List<int>.generate(_matchedUsersList!.length, (index) {
            return 1;
          });

          return Padding(
            padding: EdgeInsets.only(bottom: 95),
            child: mainBody(),
          );
        } else {
          return Center(
            heightFactor: 40,
            child: Text('Error while loading'),
          );
        }
      },
    );
  }

  Widget mainBody() {
    return StatefulBuilder(
      builder: (context, setState) {
        _usersListState = setState;
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey,
          ),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _matchedUsersList!.length,
          itemBuilder: (context, index) {
            Matches matchedUser = _matchedUsersList![index];

            int year =
                int.parse(matchedUser.dateOfBirth.toString().split('-')[0]);
            int month =
                int.parse(matchedUser.dateOfBirth.toString().split('-')[1]);
            int day =
                int.parse(matchedUser.dateOfBirth.toString().split('-')[1]);

            DateTime birthDay = DateTime(year, month, day);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            OtherUsersPage(user: matchedUser)));
              },
              child: Stack(
                children: [
                  SizedBox(
                    height: 720,
                    child: Stack(
                      children: [
                        Positioned(
                          child: SizedBox(
                            height: height * 0.5,
                            child: CarouselSlider(
                              options: CarouselOptions(
                                  height: height / 1.5,
                                  enlargeCenterPage: true,
                                  scrollPhysics: PageScrollPhysics(),
                                  viewportFraction: 1,
                                  enableInfiniteScroll: false,
                                  disableCenter: true,
                                  pageSnapping: true,
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged: (photoIndex, reason) {
                                    _indicatorsState!(() {
                                      _photosIndexes![index] = photoIndex + 1;
                                    });
                                  }),
                              items: matchedUser.media!.otherPhotosList != null
                                  ? List.generate(
                                      matchedUser.media!.otherPhotosList!
                                          .where((element) => element.type
                                              .toString()
                                              .startsWith('image'))
                                          .toList()
                                          .length, (index) {
                                      MediaModel photo = matchedUser
                                          .media!.otherPhotosList!
                                          .where((element) => element.type
                                              .toString()
                                              .startsWith('image'))
                                          .toList()[index];
                                      return CachedNetworkImage(
                                        imageUrl: photo.url,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white
                                                    .withOpacity(0.4),
                                                spreadRadius: 10,
                                                blurRadius: 7,
                                              ),
                                            ],
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.white,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                                  : [
                                      Container(
                                          child: Center(
                                        child: Text('Нет фотографий',
                                            style: TextStyle(fontSize: 20)),
                                      ))
                                    ],
                            ),
                          ),
                        ),
                        matchedUser.media!.mainPhotosList != null
                            ? StatefulBuilder(
                                builder: (context, setState) {
                                  _indicatorsState = setState;
                                  return Positioned(
                                      bottom: 300,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width / 2),
                                        child: Row(
                                          children: List.generate(
                                              matchedUser.media!.mainPhotosList!
                                                  .length, (index) {
                                            return Container(
                                              margin: EdgeInsets.all(3),
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                  color:
                                                      _photosIndexes![index] -
                                                                  1 ==
                                                              index
                                                          ? Colors.white
                                                          : Colors.white38,
                                                  shape: BoxShape.circle),
                                            );
                                          }),
                                        ),
                                      ));
                                },
                              )
                            : Container()
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 190,
                    right: 335,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 110,
                          width: 110,
                          child: matchedUser.media!.mainPhoto != null
                              ? CachedNetworkImage(
                                  imageUrl: matchedUser.media!.mainPhoto!.url,
                                  height: 110,
                                  width: 110,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.4),
                                          spreadRadius: 10,
                                          blurRadius: 7,
                                        ),
                                      ],
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.white,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          shape: BoxShape.circle),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 110,
                                  width: 110,
                                  child: Icon(Icons.account_circle_rounded,
                                      size: 110, color: Colors.grey),
                                ),
                        ),
                        Positioned(
                          top: 5,
                          left: 5,
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: SimpleCircularProgressBar(
                              valueNotifier: ValueNotifier(double.parse(
                                  matchedUser.matchPercent.toString())),
                              backColor: Colors.grey[300]!,
                              animationDuration: 0,
                              backStrokeWidth: 10,
                              progressStrokeWidth: 10,
                              startAngle: 187,
                              progressColors: const [
                                Colors.red,
                                Colors.yellowAccent,
                                Colors.green
                              ],
                            ),
                          ),
                        ),
                        Positioned.fill(
                            bottom: 0,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                child: Text('${matchedUser.matchPercent} %',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 19)),
                                decoration: BoxDecoration(
                                  color: matchedUser.matchPercent < 49
                                      ? Colors.red
                                      : (matchedUser.matchPercent > 49 &&
                                              matchedUser.matchPercent < 65)
                                          ? Colors.orange
                                          : (matchedUser.matchPercent > 65)
                                              ? Colors.green
                                              : null,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 190,
                      left: 120,
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                matchedUser.firstName +
                                    ' ' +
                                    matchedUser.lastName +
                                    ' ' +
                                    matchedUser.age.toString(),
                                style: TextStyle(fontSize: 25),
                              ),
                              SizedBox(height: 2),
                              Text('Job'),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                    height: 20,
                                    width: 20,
                                    child: Icon(Icons.home_rounded,
                                        color: Colors.white, size: 15),
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle),
                                  ),
                                  SizedBox(width: 5),
                                  Text(matchedUser.location),
                                  SizedBox(width: 20),
                                  Container(
                                    height: 20,
                                    width: 20,
                                    child: Icon(Icons.location_on,
                                        color: Colors.white, size: 15),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.topRight,
                                            colors: const [
                                              Color.fromRGBO(145, 10, 251, 10),
                                              Color.fromRGBO(217, 10, 251, 10)
                                            ])),
                                  ),
                                  SizedBox(width: 5),
                                  Text('${Random().nextInt(1000)} м'),
                                  SizedBox(width: 20),
                                  ZodiacSigns.getZodiacSign(birthDay, 0)
                                ],
                              )
                            ],
                          )
                        ],
                      )),
                  Positioned(
                    bottom: 75,
                    child: SizedBox(
                      height: 100,
                      width: width,
                      child: MasonryGridView.count(
                          padding: EdgeInsets.only(left: 10, bottom: 10),
                          crossAxisCount: 2,
                          crossAxisSpacing: 7,
                          mainAxisSpacing: 9,
                          scrollDirection: Axis.horizontal,
                          itemCount: matchedUser.interests!.length,
                          itemBuilder: (context, index) {
                            InterestsDataModel _interests =
                                matchedUser.interests![index];
                            return Material(
                              child: InkWell(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30)),
                                  child: Container(
                                    height: 40,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Center(
                                      widthFactor: 1,
                                      child: Text(
                                        _interests.interest!,
                                        style: const TextStyle(
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(30)),
                                        gradient: LinearGradient(colors: [
                                          Color(int.parse(
                                              '0x' + _interests.startColor!)),
                                          Color(int.parse(
                                              '0x' + _interests.endColor!)),
                                        ]),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color(int.parse('0x' +
                                                      _interests.startColor!))
                                                  .withOpacity(0.7),
                                              offset: const Offset(3, 3),
                                              blurRadius: 0,
                                              spreadRadius: 0)
                                        ]),
                                  )),
                            );
                          }),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Center(
                      widthFactor: 1.12,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: GestureDetector(
                            onTap: () async {},
                            child: Container(
                              width: 400,
                              height: 60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('🤝',
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.yellow)),
                                  SizedBox(width: 5),
                                  Text('Отправить подарок',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: const [
                                Color.fromRGBO(255, 0, 92, 10),
                                Color.fromRGBO(255, 172, 47, 10),
                              ])),
                            ),
                          )),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      child: Row(
                        children: [
                          Center(
                            widthFactor: 1.12,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              child: Container(
                                width: 400,
                                height: 60,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text('🤝',
                                        style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.yellow)),
                                    SizedBox(width: 5),
                                    Text('Отправить подарок',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: const [
                                  Color.fromRGBO(255, 0, 92, 10),
                                  Color.fromRGBO(255, 172, 47, 10),
                                ])),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget showSearchFilterOptions() {
    return StatefulBuilder(
      builder: (context1, dialogState) {
        return Material(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35), topRight: Radius.circular(35)),
            child: GestureDetector(
                child: Container(
                  height: height,
                  padding: EdgeInsets.symmetric(horizontal: width / 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () {
                                ShPreferences.clear();
                                dialogState(() {
                                  Provider.of<InterestsCounterProvider>(context,
                                          listen: false)
                                      .resetCounter();

                                  _isManSelected = false;
                                  _isWomanSelected = false;
                                  _isAnotherSelected = false;
                                });

                                _startAgeFieldTextController.clear();
                                _endAgeFieldTextController.clear();
                              },
                              child: Text(
                                'Сбросить',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(145, 10, 251, 5)),
                              ),
                            ),
                            SizedBox(width: 20),
                            Text('Фильтры',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                            SizedBox(width: 50),
                            IconButton(
                              icon: Icon(CupertinoIcons.clear_thick_circled),
                              color: Colors.grey.withOpacity(0.5),
                              onPressed: () => Navigator.pop(context),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text(
                              'Интересы',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              cursorColor: Color.fromRGBO(145, 10, 251, 5),
                              style: TextStyle(color: Colors.black),
                              textInputAction: TextInputAction.done,
                              readOnly: true,
                              decoration: InputDecoration(
                                fillColor: Colors.grey.withOpacity(0.3),
                                filled: true,
                                prefixIcon: Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/filter_prefix_icon.svg'),
                                    Text(
                                      'Выбрать интересы',
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.black),
                                    )
                                  ],
                                ),
                                suffixIcon: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 20,
                                      child: Center(child:
                                          Consumer<InterestsCounterProvider>(
                                        builder: (providerContext, viewModel,
                                            child) {
                                          return Text(
                                            '${viewModel.counter}',
                                            style:
                                                TextStyle(color: Colors.white),
                                          );
                                        },
                                      )),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: const [
                                                Color.fromRGBO(255, 83, 155, 5),
                                                Color.fromRGBO(237, 48, 48, 5)
                                              ])),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(CupertinoIcons.forward,
                                        color: Colors.grey),
                                    SizedBox(width: 10)
                                  ],
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onTap: () async {
                                await Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            FilterInterestsVideoPage()));
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Возраст',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Flexible(
                                  child: TextFormField(
                                    controller: _startAgeFieldTextController,
                                    cursorColor:
                                        Color.fromRGBO(145, 10, 251, 5),
                                    style: TextStyle(color: Colors.black),
                                    textInputAction: TextInputAction.done,
                                    focusNode: _startAgeFieldFocusNode,
                                    maxLength: 2,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                      hintText: 'От 18',
                                      counterText: "",
                                      fillColor: Colors.grey.withOpacity(0.3),
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: _isSmaller18StartAgeField ||
                                                    _isGreater100StartAgeField
                                                ? Colors.red
                                                : Colors.white),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: _isSmaller18StartAgeField ||
                                                    _isGreater100StartAgeField
                                                ? Colors.red
                                                : Colors.grey.withOpacity(0.5)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      if (int.parse(value) < 18) {
                                        dialogState(() {
                                          _isSmaller18StartAgeField = true;
                                        });
                                      } else if (int.parse(value) > 100) {
                                        dialogState(() {
                                          _isGreater100StartAgeField = true;
                                        });
                                      } else {
                                        dialogState(() {
                                          _isSmaller18StartAgeField = false;
                                          _isGreater100StartAgeField = false;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(width: width / 80),
                                Flexible(
                                  child: TextFormField(
                                    controller: _endAgeFieldTextController,
                                    cursorColor:
                                        Color.fromRGBO(145, 10, 251, 5),
                                    style: TextStyle(color: Colors.black),
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.number,
                                    maxLength: 2,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    focusNode: _endAgeFieldFocusNode,
                                    decoration: InputDecoration(
                                      hintText: 'До 35',
                                      counterText: "",
                                      fillColor: Colors.grey.withOpacity(0.3),
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: _isSmaller18EndAgeField ||
                                                    _isGreater100EndAgeField
                                                ? Colors.red
                                                : Colors.white),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: _isSmaller18EndAgeField ||
                                                    _isGreater100EndAgeField
                                                ? Colors.red
                                                : Colors.grey.withOpacity(0.5)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      if (int.parse(value) < 18) {
                                        dialogState(() {
                                          _isSmaller18EndAgeField = true;
                                        });
                                      } else if (int.parse(value) > 100) {
                                        dialogState(() {
                                          _isGreater100EndAgeField = true;
                                        });
                                      } else {
                                        dialogState(() {
                                          _isSmaller18EndAgeField = false;
                                          _isGreater100EndAgeField = false;
                                        });
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Пол',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    dialogState(() {
                                      _isManSelected = true;

                                      _isWomanSelected = false;
                                      _isAnotherSelected = false;
                                    });
                                  },
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  child: Container(
                                    height: 35,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Center(
                                        child: Text('Мужчина',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: _isManSelected
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold))),
                                    decoration: BoxDecoration(
                                        color: _isManSelected
                                            ? Color.fromRGBO(145, 10, 251, 5)
                                            : Colors.grey.withOpacity(0.2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        border: Border.all(
                                            color: _isManSelected
                                                ? Color.fromRGBO(
                                                    145, 10, 251, 5)
                                                : Colors.grey
                                                    .withOpacity(0.2))),
                                  ),
                                ),
                                SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    dialogState(() {
                                      _isWomanSelected = true;

                                      _isManSelected = false;
                                      _isAnotherSelected = false;
                                    });
                                  },
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  child: Container(
                                    height: 35,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Center(
                                        child: Text('Женщина',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: _isWomanSelected
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold))),
                                    decoration: BoxDecoration(
                                        color: _isWomanSelected
                                            ? Color.fromRGBO(145, 10, 251, 5)
                                            : Colors.grey.withOpacity(0.2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        border: Border.all(
                                            color: _isWomanSelected
                                                ? Color.fromRGBO(
                                                    145, 10, 251, 5)
                                                : Colors.grey
                                                    .withOpacity(0.2))),
                                  ),
                                ),
                                SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    dialogState(() {
                                      _isAnotherSelected = true;

                                      _isManSelected = false;
                                      _isWomanSelected = false;
                                    });
                                  },
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  child: Container(
                                    height: 35,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Center(
                                        child: Text('Другое',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: _isAnotherSelected
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold))),
                                    decoration: BoxDecoration(
                                        color: _isAnotherSelected
                                            ? Color.fromRGBO(145, 10, 251, 5)
                                            : Colors.grey.withOpacity(0.2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        border: Border.all(
                                            color:
                                                Colors.grey.withOpacity(0.2))),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height / 20),
                            InkWell(
                              onTap: _isSmaller18StartAgeField ||
                                      _isSmaller18EndAgeField ||
                                      _isGreater100StartAgeField ||
                                      _isGreater100EndAgeField
                                  ? null
                                  : () async {
                                      List<InterestsModel> interestsModelList =
                                          ShPreferences.getAllInterestsShPref();

                                      List<Map<String, String>>
                                          interestsMapList = [];

                                      for (var interest in interestsModelList) {
                                        Map<String, String> interestsMap = {};
                                        interestsMap.addAll({
                                          'type': interest.type.toString(),
                                          'interest': interest.name.toString()
                                        });

                                        interestsMapList.add(interestsMap);
                                      }

                                      Map<String, dynamic> data = {
                                        'gender': _isManSelected
                                            ? 'male'
                                            : _isWomanSelected
                                                ? 'female'
                                                : _isAnotherSelected
                                                    ? 'other'
                                                    : '',
                                        'interests':
                                            interestsModelList.isNotEmpty
                                                ? jsonEncode(interestsMapList)
                                                : ''
                                      };

                                      if (_startAgeFieldTextController
                                          .text.isNotEmpty) {
                                        data.addAll({
                                          'age_from': int.parse(
                                              _startAgeFieldTextController.text)
                                        });
                                      }

                                      if (_endAgeFieldTextController
                                          .text.isNotEmpty) {
                                        data.addAll({
                                          'age_to': int.parse(
                                              _endAgeFieldTextController.text)
                                        });
                                      }

                                      Response<FilterUserDataModel> response =
                                          await UnyAPI.create(Constants
                                                  .FILTER_USER_MODEL_CONVERTER)
                                              .filterUsers(token, data);
                                      if (response.body!.users != null) {
                                        _matchedUsersList =
                                            response.body!.users;

                                        _secondaryUsersList = List.from(
                                            _matchedUsersList!.toList());

                                        _secondaryUsersList!.sort((a, b) =>
                                            int.parse(b.matchPercent.toString())
                                                .compareTo(int.parse(a
                                                    .matchPercent
                                                    .toString())));
                                      } else {
                                        _matchedUsersList = [];
                                      }
                                      Navigator.pop(context);
                                      _usersListState!(() {});
                                      _secondaryUsersListState!(() {});
                                    },
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                child: Container(
                                    width: 400,
                                    height: 50,
                                    color: _isSmaller18StartAgeField ||
                                            _isSmaller18EndAgeField ||
                                            _isGreater100StartAgeField ||
                                            _isGreater100EndAgeField
                                        ? Colors.grey
                                        : Color.fromRGBO(145, 10, 251, 5),
                                    child: Center(
                                      child: Text('Показать результаты',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17)),
                                    )),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  if (_startAgeFieldFocusNode.hasFocus) {
                    _startAgeFieldFocusNode.unfocus();
                  } else if (_endAgeFieldFocusNode.hasFocus) {
                    _endAgeFieldFocusNode.unfocus();
                  }
                }));
      },
    );
  }
}
