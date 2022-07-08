import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:uny_app/Data%20Models/Photo%20Search%20Data%20Model/photo_search_data_model.dart';
import 'package:uny_app/Shared%20Preferences/shared_preferences.dart';
import 'package:uny_app/Token%20Data/token_data.dart';
import 'package:uny_app/Other%20Users%20Page/other_users_page.dart';
import 'package:uny_app/Video%20Search%20Page/filter_interests_page.dart';
import 'package:uny_app/Video%20Search%20Page/interests_counter_provider.dart';
import 'package:video_player/video_player.dart';



class VideoSearchPage extends StatefulWidget {

  @override
  _VideoSearchPageState createState() => _VideoSearchPageState();
}

class _VideoSearchPageState extends State<VideoSearchPage> with TickerProviderStateMixin {


  PageController? _pageController;

  List<String>? _videoUrls = [];

  AnimationController? controller;
  AnimationController? emojisAnimationController;

  StateSetter? _reactionsState;

  Future<Response<PhotoSearchDataModel>>? _videoSearchFuture;

  late String token;

  late TabController? _tabController;

  late FocusNode _startAgeFieldFocusNode;
  late FocusNode _endAgeFieldFocusNode;

  late TextEditingController _startAgeFieldTextController;
  late TextEditingController _endAgeFieldTextController;

  late double height;
  late double width;

  final String _giftIcon = 'assets/gift_icon.svg';
  final String _reactionAsset = 'assets/video_search_reaction.svg';
  final String _shareAsset = 'assets/share_icon.svg';
  final String _unyLogo = 'assets/gift_page_uny_logo.svg';

  List<Matches>? _matchedUsersList;
  List<Matches>? _usersWithVideo = [];

  bool _isReactionButtonTapped = false;
  bool _isManSelected = false;
  bool _isWomanSelected = false;
  bool _isAnotherSelected = false;

  double _begin = 10.0;
  double _end = 0.0;

  bool _isSmaller18StartAgeField = false;
  bool _isGreater100StartAgeField = false;

  bool _isSmaller18EndAgeField = false;
  bool _isGreater100EndAgeField = false;

  @override
  void initState() {

    token = 'Bearer ' + TokenData.getUserToken();

    _tabController = TabController(length: 4, vsync: this);

    _pageController = PageController();

    _startAgeFieldFocusNode = FocusNode();
    _endAgeFieldFocusNode = FocusNode();

    _startAgeFieldTextController = TextEditingController();
    _endAgeFieldTextController = TextEditingController();

    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    emojisAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    var data = {
      'only_above_percent' : 10
    };

    _videoSearchFuture = UnyAPI.create(Constants.PHOTO_SEARCH_MODEL_CONVERTER).getUserPhotoSearch(token, data);

    super.initState();
  }


  @override
  void dispose(){

    _pageController!.dispose();

    _startAgeFieldFocusNode.dispose();
    _endAgeFieldFocusNode.dispose();

    _startAgeFieldTextController.dispose();
    _endAgeFieldTextController.dispose();

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
              extendBodyBehindAppBar: true,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                backgroundColor: Colors.transparent,
                toolbarHeight: height / 5,
                centerTitle: true,
                title: TextFormField(
                    cursorColor: Color.fromRGBO(145, 10, 251, 5),
                    textAlign: TextAlign.center,
                    readOnly: true,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: height / 50),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.3),
                        prefixIcon: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.slider_horizontal_3,
                                color: Colors.white),
                            SizedBox(width: 10),
                            Text('Поиск по параметрам',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.white))
                          ],
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.1))),

                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.1)))
                    ),
                    onTap: () {
                      if (UniversalPlatform.isIOS) {
                        showCupertinoModalBottomSheet(
                            context: context,
                            duration: Duration(milliseconds: 250),
                            topRadius: Radius.circular(25),
                            builder: (context) {
                              return DraggableScrollableSheet(
                                initialChildSize: _startAgeFieldFocusNode.hasFocus || _endAgeFieldFocusNode.hasFocus ? 0.9 : 0.6,
                                maxChildSize: 1,
                                minChildSize: 0.6,
                                expand: false,
                                builder: (context, scrollController) {
                                  return SingleChildScrollView(
                                      controller: scrollController,
                                      physics: ClampingScrollPhysics(),
                                      child: showSearchFilterOptions()
                                  );
                                },
                              );
                            }
                        );
                      } else if (UniversalPlatform.isAndroid) {
                        showCupertinoModalBottomSheet(
                            context: context,
                            duration: Duration(milliseconds: 250),
                            builder: (context) {
                              return DraggableScrollableSheet(
                                initialChildSize: _startAgeFieldFocusNode.hasFocus || _endAgeFieldFocusNode.hasFocus ? 0.9 : 0.6,
                                maxChildSize: 1,
                                minChildSize: 0.6,
                                expand: false,
                                builder: (context, scrollController) {
                                  return SingleChildScrollView(
                                      controller: scrollController,
                                      physics: ClampingScrollPhysics(),
                                      child: showSearchFilterOptions()
                                  );
                                },
                              );
                            }
                        );
                      }
                    }
                ),
                actions: [
                  IconButton(
                      icon: Icon(Icons.more_horiz),
                      onPressed: () {
                        if (UniversalPlatform.isIOS) {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (context) {
                                return showVideoOptions();
                              }
                          );
                        } else if (UniversalPlatform.isAndroid) {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (context) {
                                return showVideoOptions();
                              }
                          );
                        }
                      }
                  ),
                ],
              ),
              body: Container(
                height: height,
                child: GestureDetector(
                  child: getMatches(),
                  onTap: () {
                    if (_isReactionButtonTapped == false) {
                      return;
                    }
                  },
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

  FutureBuilder<Response<PhotoSearchDataModel>> getMatches(){
    return FutureBuilder<Response<PhotoSearchDataModel>>(
      future: _videoSearchFuture,
      builder: (context, snapshot){
        while(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            heightFactor: 25,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Color.fromRGBO(145, 10, 251, 5),
            ),
          );
        }

        if(snapshot.connectionState == ConnectionState.done){
          _matchedUsersList = snapshot.data!.body!.matches;

          final list = [];

          for(int i = 0; i < _matchedUsersList!.length; i++){
            if(_matchedUsersList![i].media!.otherPhotosList != null){
              for(int j = 0; j < _matchedUsersList![i].media!.otherPhotosList!.length; j++){
                if(_matchedUsersList![i].media!.otherPhotosList![j].type.toString().startsWith('video')){
                  list.add(_matchedUsersList![i]);

                  _usersWithVideo = [...{...list}];
                }
              }
            }
          }


          for(int i = 0; i < _usersWithVideo!.length; ++i){
            _videoUrls!.add(_usersWithVideo![i].media!.otherPhotosList![0].url.toString());
          }

          return mainBody();
        }else{
          return Center(
            heightFactor: 40,
            child: Text('Error while loading'),
          );
        }
      },
    );
  }

  Widget mainBody() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          children: List.generate(_usersWithVideo!.length, (index){
            return Stack(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black,
                    child: VideoPlayerWidget(url: _videoUrls![index])
                ),
                StatefulBuilder(
                  builder: (context, setState){
                    _reactionsState = setState;
                    return Positioned(
                      top: height / 4.5,
                      width: 500,
                      child: _isReactionButtonTapped ? TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: _begin, end: _end),
                        duration: Duration(milliseconds: 250),
                        curve: Curves.easeIn,
                        builder: (_, value, __){
                          return BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: value,
                                sigmaY: value
                            ),
                            child: AnimatedSwitcher(
                                duration: Duration(milliseconds: 400),
                                transitionBuilder: (child, transition) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                        begin: Offset(0, 5),
                                        end: Offset.zero
                                    ).animate(
                                      CurvedAnimation(
                                          parent: emojisAnimationController!,
                                          curve: Curves.fastOutSlowIn),
                                    ),
                                    child: child,
                                  );
                                },
                                child: Container(
                                  height: height,
                                  child: Stack(
                                    clipBehavior: Clip.antiAlias,
                                    children: [
                                      Positioned(
                                        top: height / 2.7,
                                        left: width / 2,
                                        child: InkWell(
                                          child: Container(
                                            height: height / 12,
                                            width: width / 5,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage('assets/angry.png'),
                                                    fit: BoxFit.contain
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: height / 2.7,
                                        left: width / 3.5,
                                        child: InkWell(
                                          child: Container(
                                            height: height / 12,
                                            width: width / 5,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage('assets/surprised.png'),
                                                    fit: BoxFit.contain
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: height / 4,
                                        left: width / 2.46,
                                        child: InkWell(
                                          child: Container(
                                            height: height / 12,
                                            width: width / 6,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage('assets/wink.png'),
                                                    fit: BoxFit.contain
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: height / 4,
                                        left: width / 7,
                                        child: InkWell(
                                          child: Container(
                                            height: height / 12,
                                            width: width / 4,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage('assets/happy.png'),
                                                    fit: BoxFit.contain
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: height / 4,
                                        left: width / 1.7,
                                        child: InkWell(
                                          child: Container(
                                            height: height / 12,
                                            width: width / 4,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage('assets/fire.png'),
                                                    fit: BoxFit.contain
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: height / 7.5,
                                        left: width / 3.9,
                                        child: InkWell(
                                          child: Container(
                                            height: height / 12,
                                            width: width / 4,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage('assets/loved.png'),
                                                    fit: BoxFit.contain
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: height / 7.3,
                                        left: width / 2.1,
                                        child: InkWell(
                                          child: Container(
                                            height: height / 12,
                                            width: width / 4,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage('assets/crazy.png'),
                                                    fit: BoxFit.contain
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          top: height / 2.1,
                                          left: width / 3.8,
                                          child: Text(
                                            'Отправьте вашу реакцию',
                                            style: TextStyle(fontSize: 17, color: Colors.white),
                                          )
                                      ),
                                      Positioned(
                                          top: height / 1.9,
                                          left: width / 2.6,
                                          child: InkWell(
                                            onTap: (){
                                              setState(() {
                                                _isReactionButtonTapped = false;
                                              });

                                              controller!.reverse();
                                              emojisAnimationController!.reverse();

                                              animateBlur();
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 100,
                                              child: Center(
                                                child: Text(
                                                  'Закрыть',
                                                  style: TextStyle(fontSize: 17, color: Colors.white),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(0.3),
                                                  borderRadius: BorderRadius.all(Radius.circular(20))
                                              ),
                                            ),
                                          )
                                      )
                                    ],
                                  ),
                                )
                            ),
                          );
                        },
                      ) : Container(),
                    );
                  },
                ),
                Positioned(
                    top: height / 2.5,
                    left: width / 1.21,
                    child: Column(
                      children: [
                        AnimatedSwitcher(
                            duration: Duration(milliseconds: 250),
                            transitionBuilder: (child, transition) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                    begin: Offset.zero, end: Offset(3, 0)).animate(
                                  CurvedAnimation(
                                      parent: controller!,
                                      curve: Curves.fastOutSlowIn),
                                ),
                                child: child,
                              );
                            },
                            child: InkWell(
                                onTap: (){

                                  Provider.of<InterestsCounterProvider>(context, listen: false).setPlay(false);

                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => OtherUsersPage(user: _usersWithVideo![index])
                                    )
                                  ).whenComplete((){
                                    Provider.of<InterestsCounterProvider>(context, listen: false).setPlay(true);
                                  });
                                },
                                child: Stack(
                                  clipBehavior: Clip.antiAlias,
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        child: _usersWithVideo![index].media!.mainPhotosList != null ? CachedNetworkImage(
                                          imageUrl: _usersWithVideo![index].media!.mainPhotosList![0].url,
                                          imageBuilder: (context, imageProvider) => Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                            ),
                                          ),
                                          placeholder: (context, url) => Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.white,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ) : Container(
                                          child: Icon(Icons.account_circle_rounded, size: 60, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    _usersWithVideo![index].media!.mainPhotosList == null ? Positioned(
                                      top: 5,
                                      left: 5,
                                      child: ClipOval(
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          child: SimpleCircularProgressBar(
                                            valueNotifier: ValueNotifier(double.parse(_usersWithVideo![index].matchPercent.toString())),
                                            backColor: Colors.grey[300]!,
                                            animationDuration: 0,
                                            backStrokeWidth: 8,
                                            progressStrokeWidth: 8,
                                            startAngle: 187,
                                            progressColors: [
                                              Colors.red,
                                              Colors.yellowAccent,
                                              Colors.green
                                            ],
                                          ),
                                        ),
                                      )
                                    ) : Positioned(
                                      child: ClipOval(
                                        child: Container(
                                          height: 60,
                                          width: 60,
                                          child: SimpleCircularProgressBar(
                                            valueNotifier: ValueNotifier(double.parse(_usersWithVideo![index].matchPercent.toString())),
                                            backColor: Colors.grey[300]!,
                                            backStrokeWidth: 8,
                                            animationDuration: 0,
                                            progressStrokeWidth: 8,
                                            startAngle: 187,
                                            mergeMode: true,
                                            progressColors: [
                                              Colors.red,
                                              Colors.yellowAccent,
                                              Colors.green
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle
                                          ),
                                        ),
                                      )
                                    ),
                                    _usersWithVideo![index].media!.mainPhotosList != null ? Positioned(
                                      top: 43,
                                      left: 5,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Text('${_usersWithVideo![index].matchPercent} %', style: TextStyle(
                                            color: Colors.white)),
                                        decoration: BoxDecoration(
                                          color: _usersWithVideo![index].matchPercent < 49 ? Colors.red
                                              : (_usersWithVideo![index].matchPercent > 49 && _usersWithVideo![index].matchPercent < 65)
                                              ? Colors.orange : (_usersWithVideo![index].matchPercent > 65) ? Colors.green : null,
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                        ),
                                      ),
                                    ) : Positioned(
                                      top: 42,
                                      left: 8,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 6),
                                        child: Text('${_usersWithVideo![index].matchPercent} %', style: TextStyle(
                                            color: Colors.white)),
                                        decoration: BoxDecoration(
                                          color: _usersWithVideo![index].matchPercent < 49 ? Colors.red
                                              : (_usersWithVideo![index].matchPercent > 49 && _usersWithVideo![index].matchPercent < 65)
                                              ? Colors.orange : (_usersWithVideo![index].matchPercent > 65) ? Colors.green : null,
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            )
                        )
                      ],
                    )
                ),
                Positioned(
                    top: height / 2,
                    left: width / 1.21,
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 250),
                      transitionBuilder: (child, transition) {
                        return SlideTransition(
                          position: Tween<Offset>(begin: Offset.zero, end: Offset(3, 0))
                              .animate(
                            CurvedAnimation(
                                parent: controller!, curve: Curves.fastOutSlowIn),
                          ),
                          child: child,
                        );
                      },
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (context){
                                    return Material(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
                                      child: Container(
                                        padding: EdgeInsets.only(top: height / 80),
                                        height: height * 0.7,
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
                                                  Text('Отправить подарок',
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
                                            TabBar (
                                              controller: _tabController,
                                              unselectedLabelColor: Colors.grey,
                                              indicatorColor: Color.fromRGBO(145, 10, 251, 5),
                                              labelColor: Color.fromRGBO(145, 10, 251, 5),
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              physics: BouncingScrollPhysics(),
                                              isScrollable: true,
                                              tabs: [
                                                Tab(text: 'Обычные'),
                                                Tab(text: 'Необычные'),
                                                Tab(text: 'Редкие'),
                                                Tab(text: 'Эпические'),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Container(
                                              height: 70,
                                              child: Center(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text('Ваш баланс', style: TextStyle(color: Colors.grey, fontSize: 17)),
                                                      SizedBox(width: 10),
                                                      Text('12', style: TextStyle(fontSize: 17)),
                                                      SizedBox(width: 5),
                                                      SvgPicture.asset(_unyLogo, height: 17)
                                                    ],
                                                  )
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.withOpacity(0.2),
                                                  border: Border(
                                                      top: BorderSide(color: Colors.grey.withOpacity(0.5)),
                                                      bottom: BorderSide(color: Colors.grey.withOpacity(0.5))
                                                  )
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Container(
                                              height: 270,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(height: 30),
                                            ClipRRect(
                                              borderRadius: BorderRadius.all(Radius.circular(15)),
                                              child: Container(
                                                  width: 400,
                                                  height: 50,
                                                  color: Color.fromRGBO(145, 10, 251, 5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(width: 5),
                                                      Text('Отправить', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold))
                                                    ],
                                                  )
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                              );
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              child: Center(
                                child: SvgPicture.asset(_giftIcon),
                              ),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(255, 0, 92, 10),
                                        Color.fromRGBO(255, 172, 47, 10),
                                      ]
                                  )
                              ),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text('Подарок',
                              style: TextStyle(fontSize: 14, color: Colors.white))
                        ],
                      ),
                    )
                ),
                Positioned(
                    top: height / 1.59,
                    left: width / 1.21,
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 250),
                      transitionBuilder: (child, transition) {
                        return SlideTransition(
                          position: Tween<Offset>(begin: Offset.zero, end: Offset(3, 0))
                              .animate(
                            CurvedAnimation(
                                parent: controller!, curve: Curves.fastOutSlowIn),
                          ),
                          child: child,
                        );
                      },
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              _reactionsState!(() {
                                _isReactionButtonTapped = !_isReactionButtonTapped;
                              });

                              _isReactionButtonTapped
                                  ? controller!.forward()
                                  : controller!.reverse();
                              _isReactionButtonTapped ? emojisAnimationController!
                                  .forward() : emojisAnimationController!.reverse();

                              animateBlur();
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              child: Center(
                                child: SvgPicture.asset(_reactionAsset),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.7),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text('Реакция',
                              style: TextStyle(fontSize: 14, color: Colors.white))
                        ],
                      ),
                    )
                ),
                Positioned(
                    top: height / 1.33,
                    left: width / 1.25,
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 250),
                      transitionBuilder: (child, transition) {
                        return SlideTransition(
                          position: Tween<Offset>(begin: Offset.zero, end: Offset(3, 0))
                              .animate(
                            CurvedAnimation(parent: controller!, curve: Curves.fastOutSlowIn),
                          ),
                          child: child,
                        );
                      },
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => null,
                            child: Container(
                              height: 60,
                              width: 60,
                              child: Center(
                                child: SvgPicture.asset(_shareAsset),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.7),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text('Поделиться',
                              style: TextStyle(fontSize: 14, color: Colors.white))
                        ],
                      ),
                    )
                ),
                Positioned(
                    top: height / 1.15,
                    left: width / 20,
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 250),
                      transitionBuilder: (child, transition) {
                        return SlideTransition(
                          position: Tween<Offset>(begin: Offset.zero, end: Offset(0, 5))
                              .animate(
                            CurvedAnimation(
                                parent: controller!, curve: Curves.fastOutSlowIn),
                          ),
                          child: child,
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_usersWithVideo![index].firstName + ' ' + _usersWithVideo![index].lastName + ' ' + _usersWithVideo![index].age.toString(),
                              style: TextStyle(fontSize: 24, color: Colors.white)),
                          SizedBox(height: 10),
                          Container(
                            height: 100,
                            width: width,
                            child: MasonryGridView.count(
                                padding: EdgeInsets.only(bottom: 60),
                                crossAxisCount: 1,
                                crossAxisSpacing: 7,
                                mainAxisSpacing: 9,
                                scrollDirection: Axis.horizontal,
                                itemCount: _usersWithVideo![index].interests!.length,
                                itemBuilder: (context, indx){
                                  return Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                                        child: Container(
                                          height: 40,
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Center(
                                            widthFactor: 1,
                                            child: Text(
                                              _usersWithVideo![index].interests![indx].interest!,
                                              style: const TextStyle(color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(30)),
                                              color: Color(int.parse('0x' + _usersWithVideo![index].interests![indx].color!)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color(int.parse('0x' + _usersWithVideo![index].interests![indx].color!)).withOpacity(0.7),
                                                    offset: const Offset(3, 3),
                                                    blurRadius: 0,
                                                    spreadRadius: 0
                                                )
                                              ]
                                          ),
                                        )
                                    ),
                                  );
                                }
                            ),
                          )
                        ],
                      ),
                    )
                ),
              ],
            );
          }),
        )
    );
  }

  Widget showVideoOptions() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Material(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35), topRight: Radius.circular(35)),
        child: Container(
          height: height * 0.27,
          padding: EdgeInsets.only(top: 15),
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
                    Text('Действия', style:
                    TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(CupertinoIcons.clear_thick_circled),
                      color: Colors.grey.withOpacity(0.5),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              ),
              ListTile(
                  title: Text('Скрыть контент пользователя'),
                  leading: Icon(Icons.visibility_off_outlined),
                  trailing: Icon(Icons.arrow_forward_ios_rounded, size: 20),
                  onTap: () {

                  }
              ),
              ListTile(
                  title: Text('Пожаловаться'),
                  leading: Icon(Icons.error_outline),
                  trailing: Icon(Icons.arrow_forward_ios_rounded, size: 20),
                  onTap: () {

                  }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showSearchFilterOptions() {
    return StatefulBuilder(
      builder: (context1, setState) {
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
                    topLeft: Radius.circular(35), topRight: Radius.circular(35)),
              ),
              child: Column(
                children: [
                  SizedBox(height: 5),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: (){
                            ShPreferences.clear();
                            setState((){
                              Provider.of<InterestsCounterProvider>(context,listen: false).resetCounter();

                              _isManSelected = false;
                              _isWomanSelected = false;
                              _isAnotherSelected = false;
                            });

                            _startAgeFieldTextController.clear();
                            _endAgeFieldTextController.clear();
                          },
                          child: Text(
                            'Сбросить',
                            style: TextStyle(fontSize: 16, color: Color.fromRGBO(145, 10, 251, 5)),
                          ),
                        ),
                        SizedBox(width: 20),
                        Text('Фильтры', style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                          style: TextStyle(fontSize: 20,
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
                                SvgPicture.asset('assets/filter_prefix_icon.svg'),
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
                                  child: Center(
                                      child: Consumer<InterestsCounterProvider>(
                                        builder: (providerContext, viewModel, child){
                                          return Text(
                                            '${viewModel.counter}',
                                            style: TextStyle(color: Colors.white),
                                          );
                                        },
                                      )
                                  ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color.fromRGBO(255, 83, 155, 5),
                                            Color.fromRGBO(237, 48, 48, 5)
                                          ]
                                      )
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(CupertinoIcons.forward, color: Colors.grey),
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
                                    builder: (context) => FilterInterestsVideoPage()
                                )
                            );
                          },
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Возраст',
                          style: TextStyle(fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                controller: _startAgeFieldTextController,
                                cursorColor: Color.fromRGBO(145, 10, 251, 5),
                                style: TextStyle(color: Colors.black),
                                textInputAction: TextInputAction.done,
                                focusNode: _startAgeFieldFocusNode,
                                maxLength: 2,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: InputDecoration(
                                  hintText: 'От 18',
                                  counterText: "",
                                  fillColor: Colors.grey.withOpacity(0.3),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: _isSmaller18StartAgeField || _isGreater100StartAgeField ? Colors.red : Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: _isSmaller18StartAgeField || _isGreater100StartAgeField ? Colors.red : Colors.grey.withOpacity(0.5)),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onChanged: (value){
                                  if(int.parse(value) < 18){
                                    setState((){
                                      _isSmaller18StartAgeField = true;
                                    });
                                  }else if(int.parse(value) > 100){
                                    setState((){
                                      _isGreater100StartAgeField = true;
                                    });
                                  }else{
                                    setState((){
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
                                cursorColor: Color.fromRGBO(145, 10, 251, 5),
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
                                    borderSide: BorderSide(color: _isSmaller18EndAgeField || _isGreater100EndAgeField ? Colors.red : Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: _isSmaller18EndAgeField || _isGreater100EndAgeField ? Colors.red : Colors.grey.withOpacity(0.5)),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onChanged: (value){
                                  if(int.parse(value) < 18){
                                    setState((){
                                      _isSmaller18EndAgeField = true;
                                    });
                                  }else if(int.parse(value) > 100){
                                    setState((){
                                      _isGreater100EndAgeField = true;
                                    });
                                  }else{
                                    setState((){
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
                          style: TextStyle(fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isManSelected = !_isManSelected;
                                });
                              },
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              child: Container(
                                height: 35,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Center(child: Text('Мужчина',
                                    style: TextStyle(fontSize: 15,
                                        color: _isManSelected
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold))),
                                decoration: BoxDecoration(
                                    color: _isManSelected ? Color.fromRGBO(
                                        145, 10, 251, 5) : Colors.grey
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8)),
                                    border: Border.all(
                                        color: _isManSelected ? Color.fromRGBO(
                                            145, 10, 251, 5) : Colors.grey
                                            .withOpacity(0.2)
                                    )
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isWomanSelected = !_isWomanSelected;
                                });
                              },
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              child: Container(
                                height: 35,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Center(child: Text('Женщина',
                                    style: TextStyle(fontSize: 15,
                                        color: _isWomanSelected
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold))),
                                decoration: BoxDecoration(
                                    color: _isWomanSelected ? Color.fromRGBO(
                                        145, 10, 251, 5) : Colors.grey
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8)),
                                    border: Border.all(
                                        color: _isWomanSelected ? Color.fromRGBO(
                                            145, 10, 251, 5) : Colors.grey
                                            .withOpacity(0.2)
                                    )
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isAnotherSelected = !_isAnotherSelected;
                                });
                              },
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              child: Container(
                                height: 35,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Center(child: Text('Другое',
                                    style: TextStyle(fontSize: 15,
                                        color: _isAnotherSelected
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold))),
                                decoration: BoxDecoration(
                                    color: _isAnotherSelected ? Color.fromRGBO(
                                        145, 10, 251, 5) : Colors.grey
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8)),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2)
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height / 20),
                        InkWell(
                          onTap: _isSmaller18StartAgeField
                              || _isSmaller18EndAgeField
                              || _isGreater100StartAgeField
                              || _isGreater100EndAgeField ? null : () => null,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            child: Container(
                                width: 400,
                                height: 50,
                                color: _isSmaller18StartAgeField
                                    || _isSmaller18EndAgeField
                                    || _isGreater100StartAgeField
                                    || _isGreater100EndAgeField ? Colors.grey : Color.fromRGBO(145, 10, 251, 5),
                                child: Center(
                                  child: Text(
                                      'Показать результаты', style: TextStyle(
                                      color: Colors.white, fontSize: 17)),
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            onTap: (){
              if(_startAgeFieldFocusNode.hasFocus){
                _startAgeFieldFocusNode.unfocus();
              }else if(_endAgeFieldFocusNode.hasFocus){
                _endAgeFieldFocusNode.unfocus();
              }
            }
          )
        );
      },
    );
  }

  void animateBlur() {
    setState(() {
      _begin == 10.0 ? _begin = 0.0 : _begin = 10.0;
      _end == 0.0 ? _end = 10.0 : _end = 0.0;
    });
  }
}


class VideoPlayerWidget extends StatefulWidget {

  final String? url;

  @override
  _VideoPlayerState createState() => _VideoPlayerState();


  VideoPlayerWidget({Key? key, this.url}) : super(key: key);
}


class _VideoPlayerState extends State<VideoPlayerWidget>{

  ValueNotifier<VideoPlayerValue?> currentPosition = ValueNotifier(null);

  late VideoPlayerController controller;
  late Future<void> futureController;

  StateSetter? _videoState;

  bool _showIcon = false;

  initVideo() {
    controller = VideoPlayerController.network(widget.url!, videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false));
    futureController = controller.initialize();
  }


  @override
  void initState(){
    super.initState();

    initVideo();
    controller.addListener(() {
      if (controller.value.isInitialized) {
        currentPosition.value = controller.value;
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureController,
      builder: (context, snapshot){
        while(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            heightFactor: 25,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Color.fromRGBO(145, 10, 251, 5),
            ),
          );
        }

        if(snapshot.connectionState == ConnectionState.done){

          controller.setLooping(true);
          controller.play();

          return GestureDetector(
            onTap: (){
              if(controller.value.isPlaying){
                _videoState!((){
                  controller.pause();
                  _showIcon = true;
                });
              }else{
                _videoState!((){
                  controller.play();
                  _showIcon = false;
                });
              }
            },
            child: Consumer<InterestsCounterProvider>(
              builder: (context, viewModel, child){
                if(!viewModel.isPlaying){
                  controller.pause();
                }else{
                  if(!_showIcon){
                    controller.play();
                  }
                };
                return Center(
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox.expand(
                              child: AspectRatio(
                                aspectRatio: controller.value.aspectRatio,
                                child: VideoPlayer(controller),
                              )
                          ),
                        ),
                        StatefulBuilder(
                          builder: (context, setState){
                            _videoState = setState;
                            return Center(
                                child: AnimatedOpacity(
                                  opacity: _showIcon ? 1.0 : 0.0,
                                  duration: Duration(milliseconds: 150),
                                  child: IconButton(
                                      icon: Icon(CupertinoIcons.play_fill, size: 60, color: Colors.white),
                                      onPressed: (){
                                        controller.play();

                                        setState((){
                                          _showIcon = false;
                                        });
                                      }
                                  ),
                                )
                            );
                          },
                        )
                      ],
                    )
                );
              },
            )
          );
        }else{
          return Center(
            child: Text('Error'),
          );
        }
      },
    );
  }
}