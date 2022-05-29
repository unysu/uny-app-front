import 'dart:async';
import 'dart:convert';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/API/uny_app_api.dart';
import 'package:uny_app/Chats%20Page/messages_page.dart';
import 'package:uny_app/Constants/constants.dart';
import 'package:uny_app/Data%20Models/Interests%20Data%20Model/interests_data_model.dart';
import 'package:uny_app/Data%20Models/Media%20Data%20Model/media_data_model.dart';
import 'package:uny_app/Data%20Models/User%20Data%20Model/all_user_data_model.dart';
import 'package:uny_app/Data%20Models/User%20Data%20Model/user_data_model.dart';
import 'package:uny_app/Timeline%20Page/time_line_page.dart';
import 'package:uny_app/Token%20Data/token_data.dart';
import 'package:uny_app/User%20Profile%20Page/all_photos_page.dart';
import 'package:uny_app/User%20Profile%20Page/all_videos_page.dart';
import 'package:uny_app/User%20Profile%20Page/edit_interests_page.dart';
import 'package:uny_app/User%20Profile%20Page/profile_photos_page.dart';
import 'package:uny_app/User%20Profile%20Page/video_page.dart';
import 'package:uny_app/Video%20Search%20Page/video_search_page.dart';
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
  
  final String _mainButtonAsset = 'assets/bnm_main_icon.svg';
  final String _chatButtonAsset = 'assets/chat_icon.svg';
  final String _profileButtonAsset = 'assets/user_profile_icon.svg';
  final String _videoSearchButtonAsset = 'assets/video_search_icon.svg';
  final String _optionsButtonAsset = 'assets/options_icon.svg';

  StateSetter? _bioState;

  Widget? userInterface;

  bool _showImageLoading = true;
  bool _showEditBioLoading = false;

  Future<Response<AllUserDataModel>>? _allUserDataModelFuture;

  AllUserDataModel? _allUserDataModel;
  List<MediaDataModel>? _photos;
  List<InterestsDataModel>? _interests;

  List<String>? _profilePicturesUrls = [];
  List<String>? _userPhotosUrls = [];
  List<String>? _videosUrls = [];

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

    bioTextFocusNode = FocusNode();
    bioTextController = TextEditingController();

    _allUserDataModelFuture = UnyAPI.create(Constants.ALL_USER_DATA_MODEL_CONVERTER_CONSTANT).getCurrentUser(token);

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
    print("Token: ${TokenData.getUserToken()}");
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
               systemOverlayStyle: _bottomNavBarIndex == 1 ?
               SystemUiOverlayStyle.light : _bottomNavBarIndex == 4 || _bottomNavBarIndex == 2 ? SystemUiOverlayStyle.dark : _bottomNavBarIndex == 0 ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
               backgroundColor: Colors.transparent,
               toolbarHeight: 0,
             ),
             body: PageView(
               physics: NeverScrollableScrollPhysics(),
               controller: _pageController,
               children: [
                 ChatsPage(),
                 RefreshIndicator(
                   color: Color.fromRGBO(145, 10, 251, 5),
                   child: SingleChildScrollView(
                     scrollDirection: Axis.vertical,
                     physics: BouncingScrollPhysics(),
                     child: _allUserDataModel != null ? mainBody() : getUserData()
                   ),
                   strokeWidth: 1,
                   onRefresh: () async {
                     await getUserData();
                   },
                 ),
                 TimeLinePage(),
                 VideoSearchPage(),
                 SettingsPage(),
               ],
             ),
             bottomNavigationBar: Container(
               height: height / 10,
               child: StatefulBuilder(
                 builder: (context, setState){
                   return BottomNavigationBar(
                     type: BottomNavigationBarType.fixed,
                     selectedItemColor: _bottomNavBarIndex == 3 ? Colors.white : Color.fromRGBO(145, 10, 251, 5),
                     unselectedItemColor: Colors.grey,
                     backgroundColor: _bottomNavBarIndex == 3 ? Colors.black87 : Colors.white,
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
                                   SvgPicture.asset(_chatButtonAsset, color: _bottomNavBarIndex == 0 ? Color.fromRGBO(145, 10, 251, 5) : Colors.grey, height: 20, width: 20),
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
                           icon: SvgPicture.asset(_profileButtonAsset, color: _bottomNavBarIndex == 1 ? Color.fromRGBO(145, 10, 251, 5) : Colors.grey)
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
                           icon:  SvgPicture.asset(_optionsButtonAsset, color: _bottomNavBarIndex == 4 ? Color.fromRGBO(145, 10, 251, 5) : Colors.grey)
                       )
                     ],
                     onTap: (index) {
                       setState(() {
                         _bottomNavBarIndex = index;
                       });
                       _pageController!.animateToPage(_bottomNavBarIndex, duration: Duration(milliseconds: 250), curve: Curves.fastOutSlowIn);
                     },
                   );
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
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromRGBO(165, 21, 215, 5),
                              Color.fromRGBO(38, 78, 215, 5)
                            ]
                        )
                    ),
                    child: Container (
                      padding: EdgeInsets.only(left: width / 20, top: height / 20),
                      child: Row(
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.transparent
                                  ),
                                  child: Stack(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: _profilePicturesUrls![0],
                                        fadeOutDuration: Duration(seconds: 0),
                                        fadeInDuration: Duration(seconds: 0),
                                        imageBuilder: (context, imageProvider) => Container(
                                          width: 81,
                                          height: 81,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          top: 50,
                                          left: 57,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => ProfilePhotosPage()
                                                  )
                                              );
                                            },
                                            child: Container(
                                              height: constraints.maxHeight * 0.2,
                                              child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                  size: 24
                                              ),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          )
                                      )
                                    ],
                                  )
                              );
                            },
                          ),
                          SizedBox(width: 10),
                          Container(
                            height: height / 9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('Мой профиль', style: TextStyle(color: Colors.white, fontSize: 17)),
                                    SizedBox(width: width / 2.45),
                                    IconButton(
                                      icon: Icon(Icons.settings, color: Colors.white),
                                      onPressed: () {
                                        setState(() {
                                          _bottomNavBarIndex = 4;
                                        });
                                        _pageController!.animateToPage(_bottomNavBarIndex, duration: Duration(milliseconds: 250), curve: Curves.fastOutSlowIn);
                                      },
                                    ),
                                  ],
                                ),
                                Text('${_user!.firstName} ${_user!.lastName}   ${DateTime.now().year - (int.parse(_user!.dateOfBirth.split('-')[0]))}', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                ),
              )
          ),
          SizedBox(height: height / 25),
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Мои интересы', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditInterestsPage()
                            )
                        );
                      },
                      child: Text('Редактировать', style: TextStyle(fontSize: 17, color: Color.fromRGBO(145, 10, 251, 5))),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    width: width * 3,
                    height: 100,
                    child: Wrap(
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
                    ),
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
                Text('О себе', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)),
                Container(
                  height: 30,
                  width: 110,
                  child: InkWell(
                    onTap: () => openEditBioSheet(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.edit, color: Color.fromRGBO(145, 10, 251, 5), size: 20),
                        Text('Изменить', style: TextStyle(fontSize: 15, color: Colors.black))
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
                              style: TextStyle(fontSize: 15, color: Colors.black),
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
                                  Text('Ещё', style: TextStyle(fontSize: 15, color: Color.fromRGBO(145, 10, 251, 5))),
                                  Icon(Icons.arrow_drop_down, color: Color.fromRGBO(145, 10, 251, 5))
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
                  child: Text('Все', style: TextStyle(color: Color.fromRGBO(145, 10, 251, 5), fontSize: 17)),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
              height: 200,
              padding: EdgeInsets.only(left: 20),
              child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio: 16 / 8,
                mainAxisSpacing: 10,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: List.generate(_videosUrls!.length + 1, (index) {
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
                                builder: (context) => VideoPage(base64Videos: _base64Videos, videoIndex: (index - 1))
                            )
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: Container(
                          child: _base64Videos!.isEmpty ? Center(
                            heightFactor: 1,
                            widthFactor: 1,
                            child: CircularProgressIndicator(color: Color.fromRGBO(145, 10, 251, 5), strokeWidth: 1)
                          ) : CachedMemoryImage(
                            height: 100,
                            width: 100,
                            uniqueKey: 'app://content/video/${index - 1}',
                            base64: _base64Videos![index - 1],
                            fit: BoxFit.cover,
                          )
                        ),
                      ),
                    );
                  }
                }),
              ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Фото', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)),
                Container()
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
              height: 200,
              width: 430,
              padding: EdgeInsets.only(left: 10),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: List.generate(_userPhotosUrls!.length + 1, (index){
                  if(index == 0){
                    return InkWell(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: Container(
                          height: 100,
                          width: 100,
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
                                  builder: (context) => AllPhotosPage(photos: _userPhotosUrls)
                              )
                           );
                      },
                       child: ClipRRect(
                         borderRadius: BorderRadius.all(Radius.circular(15)),
                         child: Container(
                           child: CachedNetworkImage(
                             imageUrl: _userPhotosUrls![index - 1],
                             width: 100,
                             height: 100,
                             fit: BoxFit.cover,
                           ),
                         ),
                       ),
                    );
                  }
                }),
              )
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
                      Text('О себе',
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
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 20),
                  child: Text(
                    'Напишите пару слов о себе и ваших постоянных увлечениях',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, color: Colors.grey),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                      controller: bioTextController,
                      focusNode: bioTextFocusNode,
                      cursorColor: Color.fromRGBO(145, 10, 251, 5),
                      style: TextStyle(color: Colors.black),
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
                      Container(
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
                      SizedBox(width: 12),
                      Container(
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
                          ))
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
      builder: (context, snapshot) {
        while(snapshot.connectionState == ConnectionState.waiting){
          return Container();
        }


        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          _allUserDataModel = snapshot.data!.body;
          _photos = _allUserDataModel!.media;
          _user = _allUserDataModel!.user;

          _interests = _allUserDataModel!.interests;

          _aboutMe = _user!.aboutMe;

          for(var images in _photos!) {
            if(images.type.startsWith('image') && images.filter == 'main'){
              if(!(_profilePicturesUrls!.contains(images.url))){
                _profilePicturesUrls!.add(images.url);
              }
            }else if(images.type.startsWith('image') && images.filter == '-'){
              if(!(_userPhotosUrls!.contains(images.url))){
                _userPhotosUrls!.add(images.url);
              }
            }else if(images.type.startsWith('video')){
              if(!(_videosUrls!.contains(images.url))){
                _videosUrls!.add(images.url);
              }
            }
          }

          cacheVideos();

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

  Future cacheVideos() async {

    for(var url in _videosUrls!){
      http.Response response = await http.get(Uri.parse(url)).whenComplete((){
        setState((){
          _showImageLoading = false;
        });
      });

      final bytes = response.bodyBytes;

      debugPrint(base64Encode(bytes), wrapWidth: 2000);

      if(!(_base64Videos!.contains(base64Encode(bytes)))){
        _base64Videos!.add(base64Encode(bytes));
      }
    }
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
      showModalBottomSheet(
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
}