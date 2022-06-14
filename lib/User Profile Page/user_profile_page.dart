import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/API/uny_app_api.dart';
import 'package:uny_app/Chats%20Page/messages_page.dart';
import 'package:uny_app/Constants/constants.dart';
import 'package:uny_app/Data%20Models/Interests%20Data%20Model/interests_data_model.dart';
import 'package:uny_app/Data%20Models/Media%20Data%20Model/media_data_model.dart';
import 'package:uny_app/Data%20Models/User%20Data%20Model/all_user_data_model.dart';
import 'package:uny_app/Data%20Models/User%20Data%20Model/user_data_model.dart';
import 'package:uny_app/Photo%20Search%20Page/photo_search_page.dart';
import 'package:uny_app/Providers/user_data_provider.dart';
import 'package:uny_app/Providers/video_controller_provider.dart';
import 'package:uny_app/Token%20Data/token_data.dart';
import 'package:uny_app/User%20Profile%20Page/all_photos_page.dart';
import 'package:uny_app/User%20Profile%20Page/all_videos_page.dart';
import 'package:uny_app/User%20Profile%20Page/edit_interests_page.dart';
import 'package:uny_app/User%20Profile%20Page/profile_photos_page.dart';
import 'package:uny_app/User%20Profile%20Page/video_page.dart';
import 'package:uny_app/Video%20Search%20Page/video_search_page.dart';
import 'package:uny_app/Zodiac%20Signes/zodiac_signs.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../Settings Page/settings_page.dart';

class UserProfilePage extends StatefulWidget{

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>{

  late String token;

  late double height;
  late double width;

  final ImagePicker _picker = ImagePicker();
  
  final String _mainButtonAsset = 'assets/bnm_main_icon.svg';
  final String _chatButtonAsset = 'assets/chat_icon.svg';
  final String _profileButtonAsset = 'assets/user_profile_icon.svg';
  final String _videoSearchButtonAsset = 'assets/video_search_icon.svg';
  final String _optionsButtonAsset = 'assets/options_icon.svg';

  StateSetter? _bioState;

  Widget? _zodiacSignWidget;

  bool _showImageLoading = true;
  bool _showEditBioLoading = false;
  bool _showLoading = false;

  Future<Response<AllUserDataModel>>? _allUserDataModelFuture;

  AllUserDataModel? _allUserDataModel;

  MediaDataModel? _media;

  List<MediaModel>? _photos;
  List<MediaModel>? _videos;
  List<InterestsDataModel>? _interests;

  List<String>? _videoThumbnails = [];
  List<String>? _base64Videos = [];

  UserDataModel? _user;

  PageController? _pageController;

  int _bottomNavBarIndex = 1;
  int _symbolsLeft = 650;

  TextEditingController? bioTextController;
  FocusNode? bioTextFocusNode;

  String? bioValue = '';

  String? _aboutMe;

  @override
  void initState() {

    token = 'Bearer ' + TokenData.getUserToken();

    _allUserDataModelFuture = UnyAPI.create(Constants.ALL_USER_DATA_MODEL_CONVERTER_CONSTANT).getCurrentUser(token);

    bioTextFocusNode = FocusNode();
    bioTextController = TextEditingController();

    _pageController = PageController(
      initialPage: _bottomNavBarIndex
    );

    super.initState();
  }


  @override
  void dispose() {
    super.dispose();

    bioTextFocusNode!.dispose();
    bioTextController!.dispose();

    _pageController!.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
       return ResponsiveWrapper.builder (
           Scaffold(
             resizeToAvoidBottomInset: false,
             extendBodyBehindAppBar: true,
             appBar: AppBar(
               elevation: 0,
               automaticallyImplyLeading: false,
               systemOverlayStyle:
               (_bottomNavBarIndex == 0 && AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light) ||
               (_bottomNavBarIndex == 2 && AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light) ||
                   (_bottomNavBarIndex == 4 && AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light) ? SystemUiOverlayStyle.dark : null,
               backgroundColor: Colors.transparent,
               toolbarHeight: 0,
             ),
             body: PageView(
               physics: NeverScrollableScrollPhysics(),
               controller: _pageController,
               children: [
                 ChatsPage(),
                 Stack(
                   children: [
                     Container(
                       child: _allUserDataModel != null ? mainBody() : getUserData(),
                     ),
                     _showLoading ? Center(
                       heightFactor: 50,
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
                 ),
                 PhotoSearchPage(),
                 VideoSearchPage(),
                 SettingsPage(),
               ],
             ),
             bottomNavigationBar: Container(
               height: height / 10,
               child: BottomNavigationBar(
                 type: BottomNavigationBarType.fixed,
                 selectedItemColor: _bottomNavBarIndex == 0 && AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                                    ? Colors.white
                                    : _bottomNavBarIndex == 1 && AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                                    ? Colors.white
                                    : _bottomNavBarIndex == 2 && AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                                    ? Colors.white
                                    : _bottomNavBarIndex == 3
                                    ? Colors.white
                                    : _bottomNavBarIndex == 4 && AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                                    ? Colors.white : Color.fromRGBO(145, 10, 251, 5),
                 unselectedItemColor: Colors.grey,
                 backgroundColor: _bottomNavBarIndex == 0 && AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light
                                  ? Colors.white
                                  : _bottomNavBarIndex == 1 && AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light
                                  ? Colors.white
                                  : _bottomNavBarIndex == 2 && AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light
                                  ? Colors.white
                                  : _bottomNavBarIndex == 3
                                  ? Colors.black87
                                  : _bottomNavBarIndex == 4 && AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light
                                  ? Colors.white : null,
                 selectedFontSize: 10,
                 unselectedFontSize: 9,
                 currentIndex: _bottomNavBarIndex,
                 items: [
                   BottomNavigationBarItem(
                       label: 'Чаты',
                       icon: LayoutBuilder(
                         builder: (context, constraints) {
                           return Stack(
                             children: [
                               SvgPicture.asset(_chatButtonAsset, color: _bottomNavBarIndex == 0 && AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Color.fromRGBO(145, 10, 251, 5) : _bottomNavBarIndex != 0 ? Colors.grey : Colors.white, height: 20, width: 20),
                               Positioned(
                                 left: constraints.maxWidth / 2.2,
                                 bottom: 5,
                                 child:  Container(
                                   padding: EdgeInsets.all(1),
                                   decoration:  BoxDecoration(
                                     color: Colors.red,
                                     borderRadius: BorderRadius.circular(6),
                                   ),
                                   constraints: BoxConstraints(
                                     minWidth: 15,
                                     minHeight: 15,
                                   ),
                                   child: Text(
                                     '3',
                                     style: TextStyle(
                                       color: Colors.white,
                                       fontSize: 10,
                                     ),
                                     textAlign: TextAlign.center,
                                   ),
                                 ),
                               )
                             ],
                           );
                         },
                       )
                   ),
                   BottomNavigationBarItem(
                       label: 'Профиль',
                       icon: SvgPicture.asset(_profileButtonAsset, color: _bottomNavBarIndex == 1 && AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Color.fromRGBO(145, 10, 251, 5) : _bottomNavBarIndex != 1 ? Colors.grey : Colors.white)
                   ),
                   BottomNavigationBarItem(
                     label: '',
                     icon: SvgPicture.asset(_mainButtonAsset),
                   ),
                   BottomNavigationBarItem(
                       label: 'Видеопоиск',
                       icon: SvgPicture.asset(_videoSearchButtonAsset, color: _bottomNavBarIndex == 3 ? Colors.white : Colors.grey)
                   ),
                   BottomNavigationBarItem(
                       label: 'Ещё',
                       icon:  SvgPicture.asset(_optionsButtonAsset, color: _bottomNavBarIndex == 4 && AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Color.fromRGBO(145, 10, 251, 5) : _bottomNavBarIndex != 4 ? Colors.grey : Colors.white,)
                   )
                 ],
                 onTap: (index) {
                   setState(() {
                     _bottomNavBarIndex = index;
                   });
                   _pageController!.animateToPage(_bottomNavBarIndex, duration: Duration(milliseconds: 250), curve: Curves.fastOutSlowIn);
                 },
               )
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
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20)
                    ),
                    child: Container(
                        height: height / 4.8,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromRGBO(145, 10, 251, 5),
                                  Color.fromRGBO(29, 105, 218, 5)
                                ]
                            )
                        ),
                        child: Container (
                          padding: EdgeInsets.only(left: width / 20, top: height / 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Consumer<UserDataProvider>(
                                builder: (context, viewModel, child){
                                  return  Container(
                                    height: height / 9,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: 150,
                                          child: Text('${viewModel.userDataModel!.firstName} ${viewModel.userDataModel!.lastName}', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold), maxLines: 2)
                                        ),
                                        viewModel.userDataModel!.job != null
                                            ? Text(viewModel.userDataModel!.job, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16)) : Container()
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Center(
                                widthFactor: 0.2,
                                child: Container(
                                    child: Consumer<UserDataProvider>(
                                      builder: (context, viewModel, child) {
                                        MediaModel? mainPhoto = viewModel.mediaDataModel!.mainPhoto;
                                        return mainPhoto != null ? CachedNetworkImage(
                                          imageUrl: mainPhoto.url,
                                          fadeOutDuration: Duration(seconds: 0),
                                          fadeInDuration: Duration(seconds: 0),
                                          imageBuilder: (context, imageProvider) => Container(
                                            width: 100,
                                            height: 100,
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
                                        ) : Container(
                                          width: 100,
                                          height: 100,
                                          child: Center(
                                            child: Icon(Icons.account_circle_rounded, size: 85, color: Colors.grey),
                                          ),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle
                                          ),
                                        );
                                      },
                                    ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                padding: EdgeInsets.only(right: 10),
                                height: 100,
                                child: Column(
                                  children: [
                                    Container(height: 67),
                                    _zodiacSignWidget!
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                    ),
                  )
              ),
            ],
          ),
          SizedBox(height: height / 25),
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Мои интересы', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditInterestsPage()
                            )
                        );
                      },
                      child: Text('Редактировать', style: TextStyle(fontSize: 17, color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Color.fromRGBO(145, 10, 251, 5) : Colors.purpleAccent)),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, bottom: 5),
                    width: width * 2,
                    child: Consumer<UserDataProvider>(
                      builder: (context, viewModel, child){
                        _interests = viewModel.interestsDataModel;
                        return Wrap(
                            spacing: 7.0,
                            runSpacing: 9.0,
                            children: List.generate(_interests!.length, (index) {
                              return Material(
                                child: InkWell(
                                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Center(
                                        widthFactor: 1,
                                        child: Text(
                                          _interests![index].interest!,
                                          style: const TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(30)),
                                          color: Color(int.parse('0x' + _interests![index].color!)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color(int.parse('0x' + _interests![index].color!)).withOpacity(0.7),
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
                        );
                      },
                    )
                  )
                )
              )
            ],
          ),
          Container(
            height: 10,
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('О себе', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                Container(
                  height: 30,
                  width: 110,
                  child: InkWell(
                    onTap: () => openEditBioSheet(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.edit, color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Color.fromRGBO(145, 10, 251, 5) : Colors.purpleAccent, size: 20),
                        Text('Изменить', style: TextStyle(fontSize: 15))
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Colors.grey,
                          width: 0.5
                      )
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 15),
          StatefulBuilder(
            builder: (context, setState){
              _bioState = setState;
              return Container(
                height: 70,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            width: 500,
                            child: Text(
                              _aboutMe != null ? '$_aboutMe' : 'Напишите о себе',
                              style: TextStyle(fontSize: 15),
                              overflow: TextOverflow.fade,
                              maxLines: 3,
                            )
                        ),
                        Positioned(
                            top: 52,
                            right: 5,
                            child: InkWell(
                              onTap: () => showFullBio(),
                              child: Row(
                                children: [
                                  Text('Ещё', style: TextStyle(fontSize: 15, color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Color.fromRGBO(145, 10, 251, 5) : Colors.purpleAccent)),
                                  Icon(Icons.arrow_drop_down, color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Color.fromRGBO(145, 10, 251, 5) : Colors.purpleAccent)
                                ],
                              ),
                            )
                        )
                      ],
                    );
                  },
                ),
              );
            },
          ),
          SizedBox(height: 25),
          Divider(
            thickness: 8,
            color: Colors.grey.withOpacity(0.1),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Мои видео', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AllVideosPage())
                    );
                  },
                  child: Text('Все', style: TextStyle(color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Color.fromRGBO(145, 10, 251, 5) : Colors.purpleAccent, fontSize: 17)),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
              height: 200,
              padding: EdgeInsets.only(left: 20),
              child: Consumer<UserDataProvider>(
                builder: (context, viewModel, child){
                  _videos = viewModel.mediaDataModel!.otherPhotosList!.where((element) => element.type.toString().startsWith('video')).toList();
                  return GridView.count(
                    crossAxisCount: 1,
                    childAspectRatio: 16 / 8,
                    mainAxisSpacing: 10,
                    physics: const ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: List.generate(_videos!.length + 1, (index) {
                      if(index == 0){
                        return ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: Container(
                            height: height / 5,
                            width: width / 4.5,
                            color: Colors.grey.withOpacity(0.3),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.add_circled_solid, color: Colors.grey),
                                SizedBox(height: 3),
                                Text('Загрузить видео',
                                  style: TextStyle(fontSize: 15, color: Colors.grey),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        );
                      }else{
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VideoPage(videoIndex: index - 1)
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
                                  imageUrl: _videos![index - 1].thumbnail,
                                  fit: BoxFit.cover,
                                )
                            ),
                          ),
                        );
                      }
                    }),
                  );
                },
              )
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Фото', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                Container()
              ],
            ),
          ),
          SizedBox(height: 10),
          Consumer<UserDataProvider>(
            builder: (context, viewModel, child){
              _photos = viewModel.mediaDataModel!.otherPhotosList!.where((element) => (element.filter.toString().startsWith("-") && element.type.toString().startsWith("image"))).toList();
              return Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Container(
                    height: _photos!.length > 4 ? 200 : 100,
                    width: 430,
                    padding: EdgeInsets.only(left: 10),
                    child: GridView.count(
                      crossAxisCount:  _photos!.length > 5 ? 2 : 1,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 10,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: List.generate(_photos!.length + 1, (index){
                        if(index == 0){
                          return InkWell(
                            onTap: () => showBottomSheet(),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              child: Container(
                                color: Colors.grey.withOpacity(0.3),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(CupertinoIcons.add_circled_solid, color: Colors.grey),
                                    SizedBox(height: 3),
                                    Text('Загрузить фото',
                                      style: TextStyle(fontSize: 15, color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }else{
                          return InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllPhotosPage()
                                  )
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              child: Container(
                                child: Consumer<UserDataProvider>(
                                  builder: (context, viewModel, child){
                                    return CachedNetworkImage(
                                      imageUrl: _photos![index-1].url,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                    )
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget editBioWidget(BuildContext sheetContext) {
    bioTextController!.value = bioTextController!.value.copyWith(text: _aboutMe);
    return StatefulBuilder(
      builder: (context, bioState) {
        return Material(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 250),
            padding: EdgeInsets.only(top: 10),
            height: bioTextFocusNode!.hasFocus ? height / 1.3 : height / 1.8,
            decoration: BoxDecoration(
              color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark ? Colors.black12 : Colors.white,
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
                      Text('О себе', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(CupertinoIcons.clear_thick_circled),
                        color: Colors.grey.withOpacity(0.5),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 20),
                  child: Text(
                    'Напишите пару слов о себе и ваших постоянных увлечениях',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark ? Colors.white : Colors.grey),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                      controller: bioTextController,
                      focusNode: bioTextFocusNode,
                      cursorColor: Color.fromRGBO(145, 10, 251, 5),
                      style: TextStyle(color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark ? Colors.white : Colors.black),
                      textInputAction: TextInputAction.done,
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: 'Напишите о себе',
                        fillColor: Colors.grey.withOpacity(0.2),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder:  OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),

                      onTap: () {
                        Focus.of(sheetContext).requestFocus(bioTextFocusNode);
                      },

                      onChanged: (value) {
                        if(value.length > bioValue!.length){
                          bioState(() {
                            --_symbolsLeft;
                          });
                        }else{
                          bioState(() {
                            ++_symbolsLeft;
                          });
                        }

                        bioValue = value;
                      },

                      onEditingComplete: () {
                        bioTextFocusNode!.unfocus();
                      }
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      Text(
                        'Осталось ${_symbolsLeft} символов',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          alignment: Alignment.center,
                          width: 180,
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
                      ),
                      SizedBox(width: 12),
                      Flexible(
                        child: Container(
                            alignment: Alignment.center,
                            width: 180,
                            height: 48,
                            child: Material(
                              borderRadius: BorderRadius.circular(11),
                              color: Color.fromRGBO(145, 10, 251, 5),
                              child: InkWell(
                                onTap: () async {
                                  bioState((){
                                    _showEditBioLoading = true;
                                  });

                                  var data = {
                                    'about_me' : bioTextController!.text
                                  };

                                  await UnyAPI.create(Constants.SIMPLE_RESPONSE_CONVERTER).editAboutMe(token, data).whenComplete((){
                                    _showEditBioLoading = false;

                                    Navigator.pop(context);

                                    _bioState!((){
                                      _aboutMe = bioTextController!.text;
                                    });
                                  });
                                },
                                child: Container(
                                  height: height * 0.10,
                                  child: Center(
                                      child: _showEditBioLoading
                                          ? Container(
                                        height: 30,
                                        width: 30,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                          : Text('Сохранить',
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 17))
                                  ),
                                ),
                              ),
                            )
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  FutureBuilder<Response<AllUserDataModel>> getUserData() {
    return FutureBuilder<Response<AllUserDataModel>>(
      future: _allUserDataModelFuture,
      builder: (futureBuilderContext, snapshot) {
        while(snapshot.connectionState == ConnectionState.waiting){
          return Container();
        }


        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          _allUserDataModel = snapshot.data!.body;
          _user = _allUserDataModel!.user;

          _media = _allUserDataModel!.media!;
          _videos = _allUserDataModel!.media!.otherPhotosList!.where((element) => element.type.toString().startsWith('video')).toList();

          _interests = _allUserDataModel!.interests;

          _aboutMe = _user!.aboutMe;

          String birthDayString = _user!.dateOfBirth;
          int year = int.parse(birthDayString.split('-')[0]);
          int month = int.parse(birthDayString.split('-')[1]);
          int day = int.parse(birthDayString.split('-')[2]);

          DateTime birthDay = DateTime(year, month, day);

          _zodiacSignWidget = ZodiacSigns.getZodiacSign(birthDay, 1);

          Provider.of<UserDataProvider>(context, listen: false)
            ..setUserDataModel(_user)
            ..setMediaDataModel(_media)
            ..setInterestsDataModel(_interests);


          Provider.of<VideoControllerProvider>(context, listen: false).setMediaModel(_media!.otherPhotosList);

          return mainBody();
        }else{
          return Center(
            heightFactor: 10,
            child: Text('Error'),
          );
        }
      },
    );
  }

  void openEditBioSheet(){
    if(UniversalPlatform.isIOS){
      showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return editBioWidget(context);
          }
      );
    }else if(UniversalPlatform.isAndroid){
      showCupertinoModalPopup(
          context: context,
          builder: (context){
            return editBioWidget(context);
          }
      );
    }
  }

  void showFullBio() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            '$_aboutMe',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Закрыть', style: TextStyle(color: Color.fromRGBO(145, 10, 251, 5))),
            )
          ],
        );
      }
    );
  }

  void showBottomSheet() async {
    try{
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(onlyAll: true, type: RequestType.image);
      List<AssetEntity> media = await albums[0].getAssetListPaged(page: 0, size: 60);

      if(UniversalPlatform.isIOS){
        showCupertinoModalPopup(
            context: context,
            builder: (context) {
              return CupertinoActionSheet(
                actions: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: media.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    media[index].file.then((file) {
                                      _cropImage(file!.path);
                                    });
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8)),
                                    child: AssetEntityImage(
                                      media[index],
                                      isOriginal: false,
                                      thumbnailFormat: ThumbnailFormat.png,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                              ],
                            );
                          },
                        ),
                      ),
                      CupertinoActionSheetAction(
                        child: Text(
                            'Выбрать из библиотеки', textAlign: TextAlign.center),
                        onPressed: () async {
                          XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          _cropImage(image!.path);
                        },
                      )
                    ],
                  )
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
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: media.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    media[index].file.then((file) {
                                      _cropImage(file!.path);
                                    });
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8)),
                                    child: AssetEntityImage(
                                      media[index],
                                      isOriginal: false,
                                      thumbnailFormat: ThumbnailFormat.png,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                              ],
                            );
                          },
                        ),
                      ),
                      ListTile(
                        title: Text('Выбрать из библиотеки'),
                        onTap: () async {
                          XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          _cropImage(image!.path);
                        },
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
    }on RangeError catch(_){
      if(UniversalPlatform.isIOS){
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('Нет фото'),
                content: Center(
                  child: Text(
                      'У вас нет фотографий'),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text('Закрыть'),
                    isDestructiveAction: true,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
            }
        );
      }else if(UniversalPlatform.isAndroid){
        Widget _closeButton = TextButton(
            child: const Text(
                'Закрыть', style: TextStyle(color: Color.fromRGBO(145, 10, 251, 5))),
            onPressed: () {
              Navigator.pop(context);
            });

        AlertDialog dialog = AlertDialog(
            title: const Text('Нет фото'),
            content: const Text('У вас нет фотографий'),
            actions: [_closeButton]);

        showDialog(
            context: context,
            builder: (context) {
              return dialog;
            });
      }
    }
  }

  void _cropImage(String? filePath) async {

    setState((){
      _showLoading = true;
    });

    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath!,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Загрузить фото',
          toolbarColor: Color.fromRGBO(145, 10, 251, 5),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          hideBottomControls: true,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Загрузить фото',
          showCancelConfirmationDialog: true,
          cancelButtonTitle: 'Закрыть',
          doneButtonTitle: 'Сохранить',
          rotateButtonsHidden: true,
          aspectRatioPickerButtonHidden: true,
          rotateClockwiseButtonHidden: true,
          resetButtonHidden: true,
          rectX: 100,
          rectY: 100,
          aspectRatioLockEnabled: false,
        )
    );

    Uint8List bytes = croppedFile!.readAsBytesSync();

    String? mime = lookupMimeType(croppedFile.path);

    var data = {
      'media' : base64Encode(bytes),
      'mime' : mime,
      'filter' : '-'
    };
    
    await UnyAPI.create(Constants.SIMPLE_RESPONSE_CONVERTER).uploadMedia(token, data).whenComplete(() async {
      await UnyAPI.create(Constants.ALL_USER_DATA_MODEL_CONVERTER_CONSTANT).getCurrentUser(token).then((value){
        Provider.of<UserDataProvider>(context, listen: false).setMediaDataModel(value.body!.media);

        setState((){
          _showLoading = true;
        });

        Navigator.pop(context);
        Navigator.pop(context);
      });
    });
  }
}