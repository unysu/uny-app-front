import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/API/uny_app_api.dart';
import 'package:uny_app/Constants/constants.dart';
import 'package:uny_app/Data%20Models/Interests%20Data%20Model/interests_data_model.dart';
import 'package:uny_app/Data%20Models/Media%20Data%20Model/media_data_model.dart';
import 'package:uny_app/Data%20Models/Photo%20Search%20Data%20Model/photo_search_data_model.dart';
import 'package:uny_app/Gifts%20Model/gifts_model.dart';
import 'package:uny_app/Other%20Users%20Page/other_users_photo_viewer.dart';
import 'package:uny_app/Other%20Users%20Page/other_users_video_player.dart';
import 'package:uny_app/Report%20Page%20Android/report_page_android.dart';
import 'package:uny_app/Report%20Types/report_types.dart';
import 'package:uny_app/Token%20Data/token_data.dart';
import 'package:uny_app/Zodiac%20Signes/zodiac_signs.dart';

class OtherUsersPage extends StatefulWidget{
  
  Matches? user;

  OtherUsersPage({Key? key, required this.user}) : super(key: key);

  @override
  _OtherUsersPage createState() => _OtherUsersPage();
}

class _OtherUsersPage extends State<OtherUsersPage> with TickerProviderStateMixin{

  late String token;

  late double height;
  late double width;

  late TabController _tabController;

  late AnimationController emojisAnimationController;
  late AnimationController controller;

  final String _unyLogo = 'assets/gift_page_uny_logo.svg';

  FToast? _fToast;
  Reports? _reports;

  StateSetter? picsState;

  Matches? user;

  MediaModel? userProfilePhoto;
  List<MediaModel>? mainPhotos = [];
  List<MediaModel>? videos;
  List<MediaModel>? photos;

  int _currentPic = 1;

  int? _selectedGiftIndex;

  bool _isReactionButtonTapped = false;

  double _begin = 10.0;
  double _end = 0.0;

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
    super.initState();

    token = 'Bearer ' + TokenData.getUserToken();

    _fToast = FToast();

    user = widget.user;

    _tabController = TabController(length: 5, vsync: this);

    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    emojisAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    if(user!.media!.mainPhoto != null){
      userProfilePhoto = user!.media!.mainPhoto;
    }

    if(user!.media!.mainPhotosList != null){
      mainPhotos = user!.media!.mainPhotosList!;
    }

    if(userProfilePhoto != null){
      mainPhotos!.add(userProfilePhoto!);
    }

    if(user!.media!.otherPhotosList != null){
      videos = user!.media!.otherPhotosList!.where((element) => element.type.toString().startsWith('video')).toList();
      photos = user!.media!.otherPhotosList!.where((element) => element.type.toString().startsWith('image')).toList();
    }


    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _fToast!.init(context);
      _reports = Reports.init();
    });
  }


  @override
  void dispose() {

    controller.dispose();
    emojisAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        return GestureDetector(
          onTap: _isReactionButtonTapped ? (){
            setState(() {
              _isReactionButtonTapped = false;
            });

            controller.reverse();
            emojisAnimationController.reverse();

            animateBlur();
          } : null,
          child: Material(
            child: Stack(
              children: [
                Sizer(
                  builder: (context, orientation, deviceType) {
                    return ResponsiveWrapper.builder(
                      Scaffold(
                        body: NestedScrollView(
                            physics: BouncingScrollPhysics(),
                            headerSliverBuilder: (context, innerBoxIsScrolled) {
                              return
                                [
                                  SliverAppBar(
                                    backgroundColor: Colors.white,
                                    expandedHeight: 300,
                                    automaticallyImplyLeading: false,
                                    systemOverlayStyle: SystemUiOverlayStyle.light,
                                    toolbarHeight: mainPhotos!.length > 1 ? 120 : 90,
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.arrow_back, color: Colors.white),
                                                  onPressed: () => Navigator.pop(context),
                                                ),
                                                Container(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(height: 10),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '${user!.firstName} ' '${user!.lastName[0]}' ' ' '${user!.age}',
                                                            style: TextStyle(fontSize: 24, color: Colors.white),
                                                          ),
                                                          SizedBox(width: 10),
                                                          SizedBox(
                                                              height: 20,
                                                              width: 20,
                                                              child: ClipOval(
                                                                child: SvgPicture.asset('assets/russian_flag.svg'),
                                                              )
                                                          ),
                                                        ],
                                                      ),
                                                      user!.job != null ? Text('${user!.job}') : Container(),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 5,
                                                            height: 5,
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: Colors.green,

                                                            ),
                                                          ),
                                                          SizedBox(width: 5),
                                                          Text('В сети', style: TextStyle(fontSize: 12))
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                        ),
                                        Container(
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                                              child: Column(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.more_horiz),
                                                    onPressed: (){
                                                      showActionsSheet();
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child: SvgPicture.asset('assets/mail_icon.svg'),
                                                  )
                                                ],
                                              )
                                          ),
                                        )
                                      ],
                                    ),
                                    flexibleSpace: FlexibleSpaceBar(
                                      background: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(50),
                                          ),
                                          child: Stack(
                                            children: [
                                              Container(
                                                child: CarouselSlider(
                                                    options: CarouselOptions(
                                                        height: height / 1.5,
                                                        enlargeCenterPage: true,
                                                        scrollPhysics: PageScrollPhysics(),
                                                        viewportFraction: 1,
                                                        enableInfiniteScroll: false,
                                                        disableCenter: false,
                                                        pageSnapping: true,
                                                        enlargeStrategy: CenterPageEnlargeStrategy.scale,
                                                        scrollDirection: Axis.horizontal,
                                                        onPageChanged: (index, reason){
                                                          picsState!(() {
                                                            _currentPic = index + 1;
                                                          });
                                                        }
                                                    ),
                                                    items: List.generate(mainPhotos!.length, (index){
                                                      return CachedNetworkImage(
                                                        imageUrl: mainPhotos![index].url,
                                                        imageBuilder: (context, imageProvider) => Material(
                                                          elevation: 100,
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors.red,
                                                                image: DecorationImage(
                                                                    image: imageProvider,
                                                                    fit: BoxFit.cover
                                                                )
                                                            ),
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
                                                    })
                                                ),
                                              ),
                                              mainPhotos!.length > 1 ? StatefulBuilder(
                                                builder: (context, setState){
                                                  picsState = setState;
                                                  return Positioned(
                                                    top: height * 0.07,
                                                    left: 10,
                                                    right: 10,
                                                    child: SizedBox(
                                                      height: 8,
                                                      width: width,
                                                      child: Row(
                                                        children: List.generate(mainPhotos!.length, (index) {
                                                          return Expanded(
                                                            child: Container(
                                                              margin: EdgeInsets.all(3),
                                                              width: 100,
                                                              height: 5,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(20),
                                                                color: _currentPic - 1 == index ? Colors.white : Colors.grey,
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ) : Container()
                                            ],
                                          )
                                      ),
                                    ),
                                  ),
                                ];
                            },
                            body: MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: IgnorePointer(
                                  ignoring: _isReactionButtonTapped,
                                  child: mainBody(),
                                )
                            )
                        ),
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
                ),
                StatefulBuilder(
                  builder: (context, setState1){
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
                                          parent: emojisAnimationController,
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
              ],
            ),
          ),
        );
      },
    );
  }


  Widget mainBody(){
    return ListView(
      children: [
        Container(height: 10),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            child: Icon(Icons.home_rounded, color: Colors.white, size: 15),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: const [
                                    Color.fromRGBO(22, 126, 218, 10),
                                    Color.fromRGBO(98, 181, 255, 10),
                                  ]
                                )
                            ),
                          ),
                          SizedBox(width: 5),
                          Text('${user!.location}', style: TextStyle(fontSize: 17)),
                          SizedBox(width: 15),
                          Container(
                            height: 20,
                            width: 20,
                            child: Icon(Icons.location_on, color: Colors.white, size: 15),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.topRight,
                                    colors: const [
                                      Color.fromRGBO(145, 10, 251, 10),
                                      Color.fromRGBO(217, 10, 251, 10)
                                    ]
                                )
                            ),
                          ),
                          SizedBox(width: 5),
                          Text('${Random().nextInt(1000)} м'),
                          SizedBox(width: 15),
                          ZodiacSigns.getZodiacSign(DateTime(int.parse(user!.dateOfBirth.toString().split('-')[0]), int.parse(user!.dateOfBirth.toString().split('-')[1]), int.parse(user!.dateOfBirth.toString().split('-')[2])), 0)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height / 50),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            _isReactionButtonTapped = !_isReactionButtonTapped;
                          });

                          _isReactionButtonTapped
                              ? controller.forward()
                              : controller.reverse();
                          _isReactionButtonTapped ? emojisAnimationController
                              .forward() : emojisAnimationController.reverse();

                          animateBlur();
                        },
                        child: Container(
                          height: 40,
                          child: Center(
                            child: Text('Реакция', style: TextStyle(color: Colors.black)),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.deepOrange)
                          ),
                        ),
                      )
                    ),
                    SizedBox(width: 10),
                    Expanded(
                        child: GestureDetector(
                          onLongPress: (){
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
                                                  Tab(text: 'Легендарные'),
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
                                                                          color: Color.fromRGBO(253, 43, 93, 10),
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
                                                onTap: _selectedGiftIndex != null ? () {
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
                                                child: Material(
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
                          onTap: () async {
                            var data = {
                              'user_id' : user!.id
                            };

                            await UnyAPI.create(Constants.SIMPLE_RESPONSE_CONVERTER).startChat(token, data).whenComplete((){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Перейдите в раздел сообщения', style: TextStyle(fontWeight: FontWeight.bold))));
                            });
                          },
                          child: Container(
                            height: 40,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('🤝', style: TextStyle(fontSize: 30, color: Colors.yellow)),
                                  SizedBox(width: 5),
                                  Text('Отправить подарок', style: TextStyle(
                                      color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500))
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                    colors: const [
                                      Color.fromRGBO(255, 0, 92, 10),
                                      Color.fromRGBO(255, 172, 47, 10),
                                    ]
                                )
                            ),
                          ),
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(height: height / 40),
              SizedBox(
                  height: 100,
                  child: MasonryGridView.count(
                      padding: EdgeInsets.only(left: 10, bottom: 10),
                      crossAxisCount: 2,
                      crossAxisSpacing: 7,
                      mainAxisSpacing: 9,
                      scrollDirection: Axis.horizontal,
                      itemCount: user!.interests!.length,
                      itemBuilder: (context, index){
                        InterestsDataModel _interests = user!.interests![index];
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
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(int.parse('0x' + _interests.startColor)),
                                        Color(int.parse('0x' + _interests.endColor)),
                                      ]
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(int.parse('0x' + _interests.startColor!)).withOpacity(0.7),
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
                  )
              ),
              Container(
                child: Divider(
                  thickness: 1,
                ),
              ),
              user!.aboutMe != null ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: 500,
                  child: Text(
                    '${user!.aboutMe}',
                    style: TextStyle(fontSize: 15),
                    overflow: TextOverflow.fade,
                    maxLines: 4,
                  )
              ): Container(),
              SizedBox(height: 10),
              Divider(
                color: Colors.grey.withOpacity(0.1),
                thickness: 8,
              ),
              Container(
                padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Актуальные видео', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                height: 200,
                padding: EdgeInsets.only(left: 20, top: 10),
                child:  videos != null ? GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: 16 / 8,
                  mainAxisSpacing: 10,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: List.generate(videos!.length, (index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OtherUsersVideoPlayer(videoUrl: videos![index].url)
                            )
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: Container(
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.white,
                                child: Container(
                                  color: Colors.grey,
                                ),
                              ),
                              imageUrl: videos![index].thumbnail,
                              fit: BoxFit.cover,
                            )
                        ),
                      ),
                    );
                  }),
                ) : Container(
                  child: Center(
                    child: Text('Нет видео'),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Фото', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              photos != null ? SizedBox(
                  height: 250,
                  width: width,
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 10,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(top: 10, left: 20),
                    children: List.generate(photos!.length, (index){
                      return InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OtherUsersPhotoViewer(photos: photos)
                              )
                          );
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            child: CachedNetworkImage(
                              imageUrl: photos![index].url,
                              fit: BoxFit.cover,
                              imageBuilder: (context, imageProvider) => Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.white,
                                child: Container(
                                  color: Colors.grey,
                                ),
                              ),
                            )
                        ),
                      );
                    }),
                  )
              ) : SizedBox(
                height: 200,
                child: Center(
                  child: Text('Нет фото'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showActionsSheet(){
    if(UniversalPlatform.isIOS){
      showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () => Navigator.pop(context),
                  child: Row(
                    children: const [
                      Icon(CupertinoIcons.arrowshape_turn_up_right, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('Поделиться', style: TextStyle(color: Colors.blue)),
                    ],
                  )
                ),
                CupertinoActionSheetAction(
                  onPressed: () => Navigator.pop(context),
                  child: Row(
                    children: const [
                      Icon(CupertinoIcons.doc_on_doc, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('Скопировать ссылку', style: TextStyle(color: Colors.blue)),
                    ],
                  )
                ),
                CupertinoActionSheetAction(
                  onPressed: () => _showReportOptions(),
                  child: Row(
                    children: const [
                      Icon(Icons.error_outline, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('Пожаловаться', style: TextStyle(color: Colors.blue)),
                    ],
                  )
                ),
                CupertinoActionSheetAction(
                  child: Row(
                    children: const [
                      Icon(Icons.block_flipped, color: Colors.red),
                      SizedBox(width: 10),
                      Text('Заблокировать', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _showToast();
                  },
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.pop(context),
                child: Text('Отмена'),
              ),
            );
          }
      );
    }else if(UniversalPlatform.isAndroid){
      showModalBottomSheet(
          context: context,
          builder: (context){
            return Wrap(
              children: [
                Column(
                  children: [
                    ListTile(
                        title: Text('Поделиться'),
                        onTap: () => Navigator.pop(context),
                        leading: Icon(CupertinoIcons.arrowshape_turn_up_right),
                    ),
                    ListTile(
                        leading: Icon(CupertinoIcons.doc_on_doc),
                        title: Text('Скопировать ссылку'),
                        onTap: () => Navigator.pop(context)
                    ),
                    ListTile(
                        leading: Icon(Icons.error_outline),
                        title: Text('Пожаловаться'),
                        onTap: () => _showReportOptions()
                    ),
                    ListTile(
                        leading: Icon(Icons.block_flipped, color: Colors.red),
                        title: Text('Заблокировать', style: TextStyle(color: Colors.red)),
                        onTap: () {
                          Navigator.pop(context);
                          _showToast();
                        }
                    ),
                    ListTile(
                        title: Text('Отмена'),
                        onTap: () => Navigator.pop(context)
                    ),
                  ],
                )
              ],
            );
          }
      );
    }
  }

  void _showToast(){
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.black,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text("Пользователь заблокирован", style: TextStyle(color: Colors.white)),
          Icon(Icons.block_flipped, color: Colors.red),
        ],
      ),
    );

    _fToast!.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
    );
  }

  void _showReportOptions(){
    if(UniversalPlatform.isIOS){
      showCupertinoModalBottomSheet(
        context: context,
        enableDrag: true,
        topRadius: Radius.circular(25),
        duration: Duration(milliseconds: 300),
        elevation: 20,
        expand: true,
        builder: (context) {
          return Material(
            child: StatefulBuilder(
              builder: (context, setState){
                return SizedBox(
                    height: height,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 25, left: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Text('Отмена', style: TextStyle(fontSize: 17, color: Colors.red)),
                              ),
                              Text('Пожаловаться', style:
                              TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                              SizedBox(width: width / 5),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                          child: Text(
                            'Выберите причину жалобы',
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: width / 20),
                          width: width,
                          height: height * 0.78,
                          child: ListView(
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Спам',
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                    Transform.scale(
                                      scale: 1.2,
                                      child: Checkbox(
                                        value: _reports!.isSpam,
                                        onChanged: (value) {
                                          setState((){
                                            _reports!.isSpam = value!;
                                          });
                                        },
                                        shape: CircleBorder(),
                                        checkColor: Colors.white,
                                        side: BorderSide(
                                          color: Colors.grey,
                                        ),
                                        splashRadius: UniversalPlatform.isIOS ? 2 : null,
                                        activeColor: Color.fromRGBO(145, 10, 251, 5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Оскорбление',
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                    Transform.scale(
                                      scale: 1.2,
                                      child: Checkbox(
                                        value: _reports!.isAbuse,
                                        onChanged: (value) {
                                          setState((){
                                            _reports!.isAbuse = value!;
                                          });
                                        },
                                        shape: CircleBorder(),
                                        checkColor: Colors.white,
                                        side: BorderSide(
                                          color: Colors.grey,
                                        ),
                                        splashRadius: UniversalPlatform.isIOS ? 2 : null,
                                        activeColor: Color.fromRGBO(145, 10, 251, 5),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Материал для взрослых',
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                    Transform.scale(
                                      scale: 1.2,
                                      child: Checkbox(
                                        value: _reports!.isAdultContent,
                                        onChanged: (value) {
                                          setState((){
                                            _reports!.isAdultContent = value!;
                                          });
                                        },
                                        shape: CircleBorder(),
                                        checkColor: Colors.white,
                                        side: BorderSide(
                                          color: Colors.grey,
                                        ),
                                        splashRadius: UniversalPlatform.isIOS ? 2 : null,
                                        activeColor: Color.fromRGBO(145, 10, 251, 5),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Детская порнография',
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                    Transform.scale(
                                      scale: 1.2,
                                      child: Checkbox(
                                        value: _reports!.isChildPorn,
                                        onChanged: (value) {
                                          setState((){
                                            _reports!.isChildPorn = value!;
                                          });
                                        },
                                        shape: CircleBorder(),
                                        checkColor: Colors.white,
                                        side: BorderSide(
                                          color: Colors.grey,
                                        ),
                                        splashRadius: UniversalPlatform.isIOS ? 2 : null,
                                        activeColor: Color.fromRGBO(145, 10, 251, 5),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Пропаганда наркотиков',
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                    Transform.scale(
                                      scale: 1.2,
                                      child: Checkbox(
                                        value: _reports!.isDrugPropoganda,
                                        onChanged: (value) {
                                          setState((){
                                            _reports!.isDrugPropoganda = value!;
                                          });
                                        },
                                        shape: CircleBorder(),
                                        checkColor: Colors.white,
                                        side: BorderSide(
                                          color: Colors.grey,
                                        ),
                                        splashRadius: UniversalPlatform.isIOS ? 2 : null,
                                        activeColor: Color.fromRGBO(145, 10, 251, 5),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Жестокий и шокирующий контент',
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                    Transform.scale(
                                      scale: 1.2,
                                      child: Checkbox(
                                        value: _reports!.isViolentContent,
                                        onChanged: (value) {
                                          setState((){
                                            _reports!.isViolentContent = value!;
                                          });
                                        },
                                        shape: CircleBorder(),
                                        checkColor: Colors.white,
                                        side: BorderSide(
                                          color: Colors.grey,
                                        ),
                                        splashRadius: UniversalPlatform.isIOS ? 2 : null,
                                        activeColor: Color.fromRGBO(145, 10, 251, 5),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Призыв к травле',
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                    Transform.scale(
                                      scale: 1.2,
                                      child: Checkbox(
                                        value: _reports!.isCallForPersecution,
                                        onChanged: (value) {
                                          setState((){
                                            _reports!.isCallForPersecution = value!;
                                          });
                                        },
                                        shape: CircleBorder(),
                                        checkColor: Colors.white,
                                        side: BorderSide(
                                          color: Colors.grey,
                                        ),
                                        splashRadius: UniversalPlatform.isIOS ? 2 : null,
                                        activeColor: Color.fromRGBO(145, 10, 251, 5),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Призыв к суициду',
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                    Transform.scale(
                                      scale: 1.2,
                                      child: Checkbox(
                                        value: _reports!.isSuicideCall,
                                        onChanged: (value) {
                                          setState((){
                                            _reports!.isSuicideCall = value!;
                                          });
                                        },
                                        shape: CircleBorder(),
                                        checkColor: Colors.white,
                                        side: BorderSide(
                                          color: Colors.grey,
                                        ),
                                        splashRadius: UniversalPlatform.isIOS ? 2 : null,
                                        activeColor: Color.fromRGBO(145, 10, 251, 5),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Жестокое обращение с животными',
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                    Transform.scale(
                                      scale: 1.2,
                                      child: Checkbox(
                                        value: _reports!.isRudeToAnimals,
                                        onChanged: (value) {
                                          setState((){
                                            _reports!.isRudeToAnimals = value!;
                                          });
                                        },
                                        shape: CircleBorder(),
                                        checkColor: Colors.white,
                                        side: BorderSide(
                                          color: Colors.grey,
                                        ),
                                        splashRadius: UniversalPlatform.isIOS ? 2 : null,
                                        activeColor: Color.fromRGBO(145, 10, 251, 5),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Введение в заблуждение',
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                    Transform.scale(
                                      scale: 1.2,
                                      child: Checkbox(
                                        value: _reports!.isMisLeading,
                                        onChanged: (value) {
                                          setState((){
                                            _reports!.isMisLeading = value!;
                                          });
                                        },
                                        shape: CircleBorder(),
                                        checkColor: Colors.white,
                                        side: BorderSide(
                                          color: Colors.grey,
                                        ),
                                        splashRadius: UniversalPlatform.isIOS ? 2 : null,
                                        activeColor: Color.fromRGBO(145, 10, 251, 5),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Мошенничество',
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                    Transform.scale(
                                      scale: 1.2,
                                      child: Checkbox(
                                        value: _reports!.isFraud,
                                        onChanged: (value) {
                                          setState((){
                                            _reports!.isFraud = value!;
                                          });
                                        },
                                        shape: CircleBorder(),
                                        checkColor: Colors.white,
                                        side: BorderSide(
                                          color: Colors.grey,
                                        ),
                                        splashRadius: UniversalPlatform.isIOS ? 2 : null,
                                        activeColor: Color.fromRGBO(145, 10, 251, 5),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Экстремизм',
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                    Transform.scale(
                                      scale: 1.2,
                                      child: Checkbox(
                                        value: _reports!.isExtreme,
                                        onChanged: (value) {
                                          setState((){
                                            _reports!.isExtreme = value!;
                                          });
                                        },
                                        shape: CircleBorder(),
                                        checkColor: Colors.white,
                                        side: BorderSide(
                                          color: Colors.grey,
                                        ),
                                        splashRadius: UniversalPlatform.isIOS ? 2 : null,
                                        activeColor: Color.fromRGBO(145, 10, 251, 5),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Враждебные высказывания',
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                    Transform.scale(
                                      scale: 1.2,
                                      child: Checkbox(
                                        value: _reports!.isHostileRemark,
                                        onChanged: (value) {
                                          setState((){
                                            _reports!.isHostileRemark = value!;
                                          });
                                        },
                                        shape: CircleBorder(),
                                        checkColor: Colors.white,
                                        side: BorderSide(
                                          color: Colors.grey,
                                        ),
                                        splashRadius: UniversalPlatform.isIOS ? 2 : null,
                                        activeColor: Color.fromRGBO(145, 10, 251, 5),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: height / 30),
                              ClipRRect(
                                child: Container(
                                  height: 50,
                                  width: 200,
                                  child: Center(
                                    child: Text(
                                      'Пожаловаться',
                                      style: TextStyle(fontSize: 17, color: Colors.white),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(145, 10, 251, 5),
                                      borderRadius: BorderRadius.all(Radius.circular(11))
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                );
              },
            ),
          );
        }
      );
    }else if(UniversalPlatform.isAndroid){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReportPageAndroid())
      );
    }
  }

  void animateBlur() {
    setState(() {
      _begin == 10.0 ? _begin = 0.0 : _begin = 10.0;
      _end == 0.0 ? _end = 10.0 : _end = 0.0;
    });

    if(!_isReactionButtonTapped){
      _begin = 10.0;
      _end = 0.0;
    }
  }
}