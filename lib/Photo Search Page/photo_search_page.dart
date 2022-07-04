import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:uny_app/API/uny_app_api.dart';
import 'package:uny_app/Constants/constants.dart';
import 'package:uny_app/Data%20Models/Interests%20Data%20Model/interests_data_model.dart';
import 'package:uny_app/Data%20Models/Media%20Data%20Model/media_data_model.dart';
import 'package:uny_app/Data%20Models/Photo%20Search%20Data%20Model/photo_search_data_model.dart';
import 'package:uny_app/Token%20Data/token_data.dart';
import 'package:uny_app/Other%20Users%20Page/other_users_page.dart';
import 'package:uny_app/Zodiac%20Signes/zodiac_signs.dart';

class PhotoSearchPage extends StatefulWidget{

  @override
  _PhotoSearchPageState createState() => _PhotoSearchPageState();
}

class _PhotoSearchPageState extends State<PhotoSearchPage>{

  late String token;

  late double height;
  late double width;

  StateSetter? _indicatorsState;

  bool _isSearching = false;

  Future<Response<PhotoSearchDataModel>>? _photoSearchFuture;

  List<Matches>? _matchedUsersList;

  List<int>? _photosIndexes;

  int? _upperUsersCount;

  @override
  void initState(){
    token = 'Bearer ' + TokenData.getUserToken();

    var data = {
      'only_above_percent' : 20
    };

    _photoSearchFuture = UnyAPI.create(Constants.PHOTO_SEARCH_MODEL_CONVERTER).getUserPhotoSearch(token, data);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
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
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: height / 50),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.1),
                          prefixIcon: _isSearching != true
                              ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.search, color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Colors.grey : Colors.white),
                              SizedBox(width: 10),
                              Text('Поиск людей',
                                  style: TextStyle(
                                      fontSize: 17, color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Colors.grey : Colors.white))
                            ],
                          ) : null,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide(color: Colors.grey.withOpacity(0.1))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide(color: Colors.grey.withOpacity(0.1))),
                        ),
                        onChanged: (value){
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
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Знакомства', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            child: Container(
                              width: 120,
                              height: 35,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/settings.svg'),
                                  SizedBox(width: 5),
                                  Text('Фильтры', style: TextStyle(
                                      color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))
                                ],
                              ),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(255, 0, 92, 10),
                                        Color.fromRGBO(255, 172, 47, 10),
                                      ]
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    searchUsers()
                  ],
                ),
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

  FutureBuilder<Response<PhotoSearchDataModel>> searchUsers(){
    return FutureBuilder<Response<PhotoSearchDataModel>>(
      future:  _photoSearchFuture,
      builder: (context, snapshot){
        while(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            heightFactor: 20,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Color.fromRGBO(145, 10, 251, 5),
            ),
          );
        }


        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          _matchedUsersList = snapshot.data!.body!.matches;

          _photosIndexes = List<int>.generate(_matchedUsersList!.length, (index){
            return 1;
          });

          _upperUsersCount = ((_matchedUsersList!.length * 10) / 100).ceil();

          return Padding(
            padding: EdgeInsets.only(bottom: 95),
            child: mainBody(),
          );
        }else{
          return Center(
            heightFactor: 40,
            child: Text('Error while loading'),
          );
        }
      },
    );
  }

  Widget mainBody(){
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey,
      ),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _matchedUsersList!.length,
      itemBuilder: (context, index) {
        Matches matchedUser = _matchedUsersList![index];

        int year = int.parse(matchedUser.dateOfBirth.toString().split('-')[0]);
        int month = int.parse(matchedUser.dateOfBirth.toString().split('-')[1]);
        int day = int.parse(matchedUser.dateOfBirth.toString().split('-')[1]);

        DateTime birthDay = DateTime(year, month, day);

        return GestureDetector(
          onTap: () async {
             Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OtherUsersPage(user: matchedUser))
            );
          },
          child: Stack(
            children: [
              Container(
                height: 720,
                child: Stack(
                  children: [
                    Positioned(
                      child: Container(
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
                              onPageChanged: (photoIndex, reason){
                                _indicatorsState!(() {
                                  _photosIndexes![index] = photoIndex + 1;
                                });
                              }
                          ),
                          items: matchedUser.media!.mainPhotosList != null ? List.generate(matchedUser.media!.mainPhotosList!.length, (index) {
                            MediaModel photo = matchedUser.media!.mainPhotosList![index];
                            return CachedNetworkImage(
                              imageUrl: photo.url,
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.4),
                                      spreadRadius: 10,
                                      blurRadius: 7,
                                    ),
                                  ],
                                ),
                              ),
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.white,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          }) : [
                            Container(
                                child: Center(
                                  child: Text('Нет фотографий', style: TextStyle(fontSize: 20)),
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                    matchedUser.media!.mainPhotosList != null ? StatefulBuilder(
                      builder: (context, setState){
                        _indicatorsState = setState;
                        return Positioned(
                            bottom: 300,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: width / 2),
                              child: Row(
                                children: List.generate(matchedUser.media!.mainPhotosList!.length, (index) {
                                  return Container(
                                    margin: EdgeInsets.all(3),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                        color: _photosIndexes![index] - 1 == index ? Colors.white : Colors.white38,
                                        shape: BoxShape.circle),
                                  );
                                }),
                              ),
                            )
                        );
                      },
                    ) : Container()
                  ],
                ),
              ),
              Positioned(
                bottom: 190,
                right: 335,
                child: Stack(
                  children: [
                    Container(
                      height: 110,
                      width: 110,
                      child: matchedUser.media!.mainPhoto != null ? CachedNetworkImage(
                        imageUrl: matchedUser.media!.mainPhoto!.url,
                        height: 110,
                        width: 110,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.4),
                                spreadRadius: 10,
                                blurRadius: 7,
                              ),
                            ],
                          ),
                        ),
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle
                            ),
                          ),
                        ),
                      ) : Container(
                        height: 110,
                        width: 110,
                        child: Icon(Icons.account_circle_rounded, size: 110, color: Colors.grey),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      left: 5,
                      child: Container(
                        height: 100,
                        width: 100,
                        child: SimpleCircularProgressBar(
                          valueNotifier: ValueNotifier(double.parse(matchedUser.matchPercent.toString())),
                          backColor: Colors.grey[300]!,
                          animationDuration: 0,
                          backStrokeWidth: 10,
                          progressStrokeWidth: 10,
                          startAngle: 200,
                          progressColors: [
                            Colors.red,
                            Colors.yellowAccent,
                            Colors.green
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 28,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        child: Text('${matchedUser.matchPercent} %', style: TextStyle(
                            color: Colors.white, fontSize: 19)),
                        decoration: BoxDecoration(
                          color: matchedUser.matchPercent < 49 ? Colors.red
                              : (matchedUser.matchPercent > 49 && matchedUser.matchPercent < 65)
                              ? Colors.orange : (matchedUser.matchPercent > 65) ? Colors.green : null,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                    )
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
                            matchedUser.firstName + ' ' + matchedUser.lastName + ' ' + matchedUser.age.toString(),
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(height: 2),
                          Text(
                              'Job'
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                child: Icon(Icons.home_rounded, color: Colors.white, size: 15),
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(matchedUser.location),
                              SizedBox(width: 20),
                              Container(
                                height: 20,
                                width: 20,
                                child: Icon(Icons.location_on, color: Colors.white, size: 15),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.topRight,
                                        colors: [
                                          Color.fromRGBO(145, 10, 251, 10),
                                          Color.fromRGBO(217, 10, 251, 10)
                                        ]
                                    )
                                ),
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
                  )
              ),
              Positioned(
                  bottom: 75,
                  child: Container(
                    height: 100,
                    width: width,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                            padding: EdgeInsets.only(left: 10, bottom: 5),
                            width: width * 3,
                            child: Wrap(
                                spacing: 7.0,
                                runSpacing: 9.0,
                                direction: Axis.horizontal,
                                children: List.generate(matchedUser.interests!.length, (index) {
                                  InterestsDataModel _interests = matchedUser.interests![index];
                                  return Material(
                                    child: InkWell(
                                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                                        child: Container(
                                          height: 40,
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Center(
                                            widthFactor: 1,
                                            child: Text(
                                              _interests.interest!,
                                              style: const TextStyle(color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(30)),
                                              color: Color(int.parse('0x' + _interests.color!)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color(int.parse('0x' + _interests.color!)).withOpacity(0.7),
                                                    offset: const Offset(3, 3),
                                                    blurRadius: 0,
                                                    spreadRadius: 0
                                                )
                                              ]
                                          ),
                                        )
                                    ),
                                  );
                                })
                            )
                        )
                    ),
                  )
              ),
              Positioned(
                bottom: 0,
                child: Center(
                  widthFactor: 1.12,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: GestureDetector(
                      onTap: () async {

                      },
                      child: Container(
                        width: 400,
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('🤝', style: TextStyle(fontSize: 30, color: Colors.yellow)),
                            SizedBox(width: 5),
                            Text('Отправить подарок', style: TextStyle(
                                color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold))
                          ],
                        ),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(255, 0, 92, 10),
                                  Color.fromRGBO(255, 172, 47, 10),
                                ]
                            )
                        ),
                      ),
                    )
                  ),
                ),
              ),
              Positioned(
                  bottom: 0,
                  child: Row(
                    children: [
                      Center(
                        widthFactor: 1.12,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: Container(
                            width: 400,
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('🤝', style: TextStyle(fontSize: 30, color: Colors.yellow)),
                                SizedBox(width: 5),
                                Text('Отправить подарок', style: TextStyle(
                                    color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold))
                              ],
                            ),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Color.fromRGBO(255, 0, 92, 10),
                                      Color.fromRGBO(255, 172, 47, 10),
                                    ]
                                )
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ],
          ),
        );
      },
    );
  }
}