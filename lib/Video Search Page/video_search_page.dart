import 'dart:convert';
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
import 'package:uny_app/Gifts%20Model/gifts_model.dart';
import 'package:uny_app/Interests%20Model/interests_db_model.dart';
import 'package:uny_app/Shared%20Preferences/shared_preferences.dart';
import 'package:uny_app/Token%20Data/token_data.dart';
import 'package:uny_app/Other%20Users%20Page/other_users_page.dart';
import 'package:uny_app/Video%20Search%20Page/filter_interests_page.dart';
import 'package:uny_app/Video%20Search%20Page/interests_counter_provider.dart';
import 'package:video_player/video_player.dart';



class VideoSearchPage extends StatefulWidget {
  const VideoSearchPage({Key? key}) : super(key: key);


  @override
  _VideoSearchPageState createState() => _VideoSearchPageState();
}

class _VideoSearchPageState extends State<VideoSearchPage> with TickerProviderStateMixin {

  late String token;

  late TabController _tabController;

  late FocusNode _startAgeFieldFocusNode;
  late FocusNode _endAgeFieldFocusNode;

  late TextEditingController _startAgeFieldTextController;
  late TextEditingController _endAgeFieldTextController;

  late double height;
  late double width;

  final List<String>? _videoUrls = [];

  final String _giftIcon = 'assets/gift_icon.svg';
  final String _reactionAsset = 'assets/video_search_reaction.svg';
  final String _shareAsset = 'assets/share_icon.svg';
  final String _unyLogo = 'assets/gift_page_uny_logo.svg';


  bool firstRun = true;

  int? _selectedGiftIndex;

  PageController? _pageController;

  AnimationController? controller;
  AnimationController? emojisAnimationController;

  VideoPlayerWidget? videoPlayerWidget;

  StateSetter? _reactionsState;

  Future<Response<PhotoSearchDataModel>>? _videoSearchFuture;

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

  List<GiftModel> giftsList = [
    GiftModel(
        image: 'assets/gifts/bikini_bottom.png',
        name: 'Bikini Bottom',
        price: '25',
        type: 'vip'
    ),
    GiftModel(
        image: 'assets/gifts/bounty_bar.png',
        name: 'Bounty Bar',
        price: '1.3',
        type: ''
    ),
    GiftModel(
        image: 'assets/gifts/bouquet.png',
        name: 'Bouquet',
        price: '2.2',
        type: ''
    ),
    GiftModel(
        image: 'assets/gifts/cookie_boopie.png',
        name: 'Cookie Boopie',
        price: '2.2',
        type: ''
    ),
    GiftModel(
        image: 'assets/gifts/ice_mice.png',
        name: 'Ice Mice',
        price: '1.5',
        type: 'new'
    ),
    GiftModel(
        image: 'assets/gifts/no_comments.png',
        name: 'No comments',
        price: '2.2',
        type: ''
    ),
    GiftModel(
        image: 'assets/gifts/ratman.png',
        name: 'Ratman',
        price: '0',
        type: ''
    ),
    GiftModel(
        image: 'assets/gifts/rich_watch.png',
        name: 'Rich Watch',
        price: '20',
        type: ''
    )
  ];

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
      'only_above_percent' : 0
    };

    _videoSearchFuture = UnyAPI.create(Constants.PHOTO_SEARCH_MODEL_CONVERTER).getUserPhotoSearch(token, data);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      firstRun = false;
    });

    super.initState();
  }


  @override
  void dispose(){

    _pageController!.dispose();

    _startAgeFieldFocusNode.dispose();
    _endAgeFieldFocusNode.dispose();

    _startAgeFieldTextController.dispose();
    _endAgeFieldTextController.dispose();

    emojisAnimationController!.dispose();
    controller!.dispose();

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
                title: SizedBox(
                  height: 40,
                  child: TextFormField(
                      cursorColor: Color.fromRGBO(145, 10, 251, 5),
                      textAlign: TextAlign.center,
                      readOnly: true,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: height / 50),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.3),
                          prefixIcon: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(CupertinoIcons.search,
                                  color: Colors.white),
                              SizedBox(width: 10),
                              Text('Поиск по интересам',
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
                )
              ),
              body: SizedBox(
                height: height,
                child: GestureDetector(
                  child: firstRun ? getMatches() : mainBody(),
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
            _videoUrls!.add(_usersWithVideo![i].media!.otherPhotosList!.where((element) => element.type.toString().startsWith('video')).first.url.toString());
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
            videoPlayerWidget = VideoPlayerWidget(url: _videoUrls![index]);
            return Stack(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black,
                    child: videoPlayerWidget
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
                                child: SizedBox(
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
                                      child: SizedBox(
                                        height: 60,
                                        width: 60,
                                        child: _usersWithVideo![index].media!.mainPhoto != null ? CachedNetworkImage(
                                          imageUrl: _usersWithVideo![index].media!.mainPhoto!.url,
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
                                    _usersWithVideo![index].media!.mainPhoto == null ? Positioned(
                                        top: 5,
                                        left: 5,
                                        child: ClipOval(
                                          child: SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: SimpleCircularProgressBar(
                                              valueNotifier: ValueNotifier(double.parse(_usersWithVideo![index].matchPercent.toString())),
                                              backColor: Colors.grey[300]!,
                                              animationDuration: 0,
                                              backStrokeWidth: 8,
                                              progressStrokeWidth: 8,
                                              startAngle: 187,
                                              progressColors: const [
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
                                                progressColors: const [
                                                  Colors.red,
                                                  Colors.yellowAccent,
                                                  Colors.green
                                                ]
                                            ),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle
                                            ),
                                          ),
                                        )
                                    ),
                                    _usersWithVideo![index].media!.mainPhoto != null ? Positioned.fill(
                                        top: 43,
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
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
                                        )
                                    ) : Positioned.fill(
                                        top: 42,
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
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
                                        )
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
                                    return StatefulBuilder(
                                      builder: (context, setState){
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
                                                TabBar(
                                                  controller: _tabController,
                                                  unselectedLabelColor: Colors.grey,
                                                  indicatorColor: Color.fromRGBO(145, 10, 251, 5),
                                                  labelColor: Color.fromRGBO(145, 10, 251, 5),
                                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                                  physics: BouncingScrollPhysics(),
                                                  isScrollable: true,
                                                  tabs: const [
                                                    Tab(text: 'Обычные'),
                                                    Tab(text: 'Необычные'),
                                                    Tab(text: 'Редкие'),
                                                    Tab(text: 'Эпические'),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Container(
                                                  height: 60,
                                                  child: Center(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text('Ваш баланс', style: TextStyle(color: Colors.grey, fontSize: 17)),
                                                          SizedBox(width: 10),
                                                          Text('12', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
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
                                                SizedBox(height: 20),
                                                Container(
                                                  height: 270,
                                                  padding: EdgeInsets.only(left: 10),
                                                  child: TabBarView(
                                                    controller: _tabController,
                                                    children: [
                                                      SizedBox(
                                                        child: GridView.count(
                                                            crossAxisCount: 2,
                                                            crossAxisSpacing: 4,
                                                            mainAxisSpacing: 4,
                                                            shrinkWrap: true,
                                                            scrollDirection: Axis.horizontal,
                                                            children: List.generate(giftsList.length, (index){
                                                              return GestureDetector(
                                                                onTap: (){
                                                                  setState((){
                                                                    _selectedGiftIndex = index;
                                                                  });
                                                                },
                                                                child: Stack(
                                                                  children: [
                                                                    AnimatedContainer(
                                                                      height: 150,
                                                                      width: 150,
                                                                      duration: Duration(milliseconds: 150),
                                                                      curve: Curves.easeIn,
                                                                      child: Center(
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              Image.asset(giftsList[index].image!, scale: 4),
                                                                              SizedBox(height: 10),
                                                                              Text(giftsList[index].name!, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    giftsList[index].price == '0'
                                                                                        ? 'Бесплатно'
                                                                                        : giftsList[index].price!,
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(145, 10, 251, 5)),
                                                                                  ),
                                                                                  SizedBox(width: 5),
                                                                                  giftsList[index].price != '0' ? SvgPicture.asset(_unyLogo, height: 10) : Container()
                                                                                ],
                                                                              )
                                                                            ],
                                                                          )
                                                                      ),
                                                                      decoration: BoxDecoration(
                                                                          color: _selectedGiftIndex == index ? Colors.grey.withOpacity(0.3) : Colors.transparent,
                                                                          borderRadius: BorderRadius.circular(20)
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      top: 15,
                                                                      left: 15,
                                                                      child: ClipOval(
                                                                        child: Container(
                                                                          height: 10,
                                                                          width: 10,
                                                                          color: Colors.grey.withOpacity(0.5),
                                                                        ),
                                                                      ),
                                                                    ),

                                                                    giftsList[index].type == 'new'
                                                                        ? Positioned(
                                                                      top: 10,
                                                                      right: 10,
                                                                      child: Container(
                                                                        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                                                                        child: Center(
                                                                            child: Text('NEW', style: TextStyle(fontSize: 8, color: Colors.white))
                                                                        ),
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.red,
                                                                            borderRadius: BorderRadius.all(Radius.circular(20))
                                                                        ),
                                                                      ),
                                                                    ) : giftsList[index].type == 'vip'
                                                                        ? Positioned(
                                                                      top: 10,
                                                                      right: 10,
                                                                      child: Container(
                                                                        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                                                                        child: Center(
                                                                            child: Text('VIP', style: TextStyle(fontSize: 8, color: Colors.white))
                                                                        ),
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.black,
                                                                            borderRadius: BorderRadius.all(Radius.circular(20))
                                                                        ),
                                                                      ),
                                                                    ) : SizedBox()
                                                                  ],
                                                                ),
                                                              );
                                                            })
                                                        ),
                                                      ),
                                                      SizedBox(height: 100, width: 100),
                                                      SizedBox(height: 100, width: 100),
                                                      SizedBox(height: 100, width: 100)
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 50),
                                                GestureDetector(
                                                  onTap: _selectedGiftIndex != null ? (){
                                                    showCupertinoModalBottomSheet(
                                                        context: context,
                                                        enableDrag: true,
                                                        duration: Duration(milliseconds: 250),
                                                        topRadius: Radius.circular(30),
                                                        builder: (context){
                                                          return GestureDetector(
                                                            onTap: (){
                                                              FocusManager.instance.primaryFocus?.unfocus();
                                                            },
                                                            child: Material(
                                                              child: StatefulBuilder(
                                                                builder: (context, setState){
                                                                  return Column(
                                                                    children: [
                                                                      Container(
                                                                        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                                                                        child: Row(
                                                                          children: [
                                                                            TextButton(
                                                                              onPressed: () => Navigator.pop(context),
                                                                              child: Text('Отмена', style: TextStyle(color: Color.fromRGBO(253, 43, 93, 10), fontSize: 17)),
                                                                            ),
                                                                            Container(width: width / 6),
                                                                            Text('Подарок', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                                                                            Container(width: width / 6)
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(height: 50),
                                                                      Material(
                                                                          elevation: 5,
                                                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                                                          child: Stack(
                                                                            children: [
                                                                              Container(
                                                                                height: 200,
                                                                                width: 200,
                                                                                child: Center(
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        Image.asset(giftsList[_selectedGiftIndex!].image!, scale: 2),
                                                                                        SizedBox(height: 20),
                                                                                        Text(giftsList[_selectedGiftIndex!].name!, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20)),
                                                                                        SizedBox(height: 10),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: [
                                                                                            Text(
                                                                                              giftsList[_selectedGiftIndex!].price == '0'
                                                                                                  ? 'Бесплатно'
                                                                                                  : giftsList[_selectedGiftIndex!].price!,
                                                                                              style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(145, 10, 251, 5), fontSize: 16),
                                                                                            ),
                                                                                            SizedBox(width: 10),
                                                                                            giftsList[_selectedGiftIndex!].price != '0' ? SvgPicture.asset(_unyLogo, height: 14) : Container()
                                                                                          ],
                                                                                        )
                                                                                      ],
                                                                                    )
                                                                                ),
                                                                                decoration: BoxDecoration(
                                                                                    color: Colors.white,
                                                                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                                                                ),
                                                                              ),
                                                                              Positioned(
                                                                                top: 15,
                                                                                left: 15,
                                                                                child: ClipOval(
                                                                                  child: Container(
                                                                                    height: 15,
                                                                                    width: 15,
                                                                                    color: Colors.grey.withOpacity(0.5),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              giftsList[_selectedGiftIndex!].type == 'new'
                                                                                  ? Positioned(
                                                                                top: 10,
                                                                                right: 10,
                                                                                child: Container(
                                                                                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                                                                  child: Center(
                                                                                      child: Text('NEW', style: TextStyle(fontSize: 13, color: Colors.white))
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                      color: Color.fromRGBO(253, 43, 93, 10),
                                                                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                                                                  ),
                                                                                ),
                                                                              ) : giftsList[_selectedGiftIndex!].type == 'vip'
                                                                                  ? Positioned(
                                                                                top: 10,
                                                                                right: 10,
                                                                                child: Container(
                                                                                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                                                                  child: Center(
                                                                                      child: Text('VIP', style: TextStyle(fontSize: 13, color: Colors.white))
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                      color: Colors.black,
                                                                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                                                                  ),
                                                                                ),
                                                                              ) : SizedBox()
                                                                            ],
                                                                          )
                                                                      ),
                                                                      SizedBox(height: 30),
                                                                      Container(
                                                                        height: 130,
                                                                        margin: EdgeInsets.only(left: 20, right: 20),
                                                                        child: TextFormField(
                                                                          maxLines: 15,
                                                                          cursorColor: Colors.black.withOpacity(0.4),
                                                                          textInputAction: TextInputAction.done,
                                                                          decoration: InputDecoration(
                                                                            hintText: 'Сообщение',
                                                                            fillColor: Colors.grey.withOpacity(0.2),
                                                                            filled: true,
                                                                            border: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(20),
                                                                                borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))
                                                                            ),
                                                                            focusedBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(20),
                                                                                borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))
                                                                            ),
                                                                            enabledBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(20),
                                                                                borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(height: height / 4),
                                                                      Container(
                                                                          child: Column(
                                                                            children: [
                                                                              Divider(color: Colors.grey),
                                                                              Center(
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Text('Ваш баланс 12', style: TextStyle(color: Colors.grey)),
                                                                                      SizedBox(width: 5),
                                                                                      SvgPicture.asset(_unyLogo, color: Colors.grey)
                                                                                    ],
                                                                                  )
                                                                              ),
                                                                              SizedBox(height: 20),
                                                                              Material(
                                                                                elevation: 10,
                                                                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                                child: ClipRRect(
                                                                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                                  child: Container(
                                                                                    width: 400,
                                                                                    height: 50,
                                                                                    color: Color.fromRGBO(145, 10, 251, 5),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        SizedBox(width: 5),
                                                                                        Text('Отправить за ${giftsList[_selectedGiftIndex!].price}', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                                                                                        SizedBox(width: 5),
                                                                                        Container(
                                                                                          child: SvgPicture.asset(_unyLogo, color: Colors.white),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                          )
                                                                      )
                                                                    ],
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                    );
                                                  } : null,
                                                  child:  Material(
                                                    elevation: 5,
                                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                      child: Container(
                                                        width: 400,
                                                        height: 50,
                                                        color: _selectedGiftIndex != null ? Color.fromRGBO(145, 10, 251, 5) : Colors.grey,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: const [
                                                            SizedBox(width: 5),
                                                            Text('Отправить', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
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
                                      colors: const [
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
                            onTap: null,
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
                          SizedBox(
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
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Color(int.parse('0x' + _usersWithVideo![index].interests![indx].startColor!)),
                                                    Color(int.parse('0x' + _usersWithVideo![index].interests![indx].endColor!)),
                                                  ]
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color(int.parse('0x' + _usersWithVideo![index].interests![indx].startColor!)).withOpacity(0.7),
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
      builder: (context, dialogState) {
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
                            dialogState((){
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
                                          colors: const [
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
                                    dialogState((){
                                      _isSmaller18StartAgeField = true;
                                    });
                                  }else if(int.parse(value) > 100){
                                    dialogState((){
                                      _isGreater100StartAgeField = true;
                                    });
                                  }else{
                                    dialogState((){
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
                                    dialogState((){
                                      _isSmaller18EndAgeField = true;
                                    });
                                  }else if(int.parse(value) > 100){
                                    dialogState((){
                                      _isGreater100EndAgeField = true;
                                    });
                                  }else{
                                    dialogState((){
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
                                dialogState(() {
                                  _isManSelected = true;

                                  _isWomanSelected = false;
                                  _isAnotherSelected = false;
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
                                dialogState(() {
                                  _isWomanSelected = true;

                                  _isManSelected = false;
                                  _isAnotherSelected = false;
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
                                dialogState(() {
                                  _isAnotherSelected = true;

                                  _isManSelected = false;
                                  _isWomanSelected = false;
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
                              || _isGreater100EndAgeField ? null : () async {

                            List<InterestsModel> interestsModelList = ShPreferences.getAllInterestsShPref();

                            List<Map<String, String>> interestsMapList = [];

                            for(var interest in interestsModelList){
                              Map<String, String> interestsMap = {};
                              interestsMap.addAll({
                                'type' : interest.type.toString(),
                                'interest' : interest.name.toString()
                              });

                              interestsMapList.add(interestsMap);
                            }

                            Map<String, dynamic> data = {
                              'gender' : _isManSelected ? 'male' : _isWomanSelected ? 'female' : _isAnotherSelected ? 'other' : '',
                              'interests' : interestsModelList.isNotEmpty ? jsonEncode(interestsMapList) : ''
                            };

                            if(_startAgeFieldTextController.text.isNotEmpty){
                              data.addAll({
                                'age_from' : int.parse(_startAgeFieldTextController.text)
                              });
                            }

                            if(_endAgeFieldTextController.text.isNotEmpty){
                              data.addAll({
                                'age_to' : int.parse(_endAgeFieldTextController.text)
                              });
                            }

                            Response<FilterUserDataModel> response = await UnyAPI.create(Constants.FILTER_USER_MODEL_CONVERTER).filterUsers(token, data);
                            _matchedUsersList!.clear();
                            _usersWithVideo!.clear();
                            _videoUrls!.clear();
                            if(response.body!.users != null){
                              _matchedUsersList = response.body!.users;

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
                                _videoUrls!.add(_usersWithVideo![i].media!.otherPhotosList!.where((element) => element.type.toString().startsWith('video')).first.url.toString());
                              }
                            }else{
                              _matchedUsersList = [];
                            }
                            Navigator.pop(context);
                            videoPlayerWidget = null;
                            setState((){});
                          },
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



  const VideoPlayerWidget({Key? key, this.url}) : super(key: key);
}


class _VideoPlayerState extends State<VideoPlayerWidget>{

  ValueNotifier<VideoPlayerValue?> currentPosition = ValueNotifier(null);

  late VideoPlayerController controller;
  late Future<void> futureController;

  StateSetter? _videoState;

  bool _showIcon = false;
  bool firstRun = true;

  initVideo() {
    controller = VideoPlayerController.network(widget.url!, videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false));
    futureController = controller.initialize();
  }


  @override
  void initState(){
    initVideo();
    controller.addListener(() {
      if (controller.value.isInitialized) {
        currentPosition.value = controller.value;
      }
    });

    firstRun = false;
    super.initState();
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

          if(!firstRun){
            controller.dispose();
            initVideo();

            controller.addListener(() {
              if (controller.value.isInitialized) {
                currentPosition.value = controller.value;
              }
            });
          }

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
                  }
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