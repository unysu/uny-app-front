import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/User%20Profile%20Page/all_photos_page.dart';
import 'package:uny_app/User%20Profile%20Page/all_videos_page.dart';
import 'package:uny_app/User%20Profile%20Page/other_users_page.dart';
import 'package:uny_app/User%20Profile%20Page/profile_photos_page.dart';

import '../Settings Page/settings_page.dart';

class UserProfilePage extends StatefulWidget{

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  
  final String _mainButtonAsset = 'assets/bnm_main_icon.svg';
  final String _chatButtonAsset = 'assets/chat_icon.svg';
  final String _profileButtonAsset = 'assets/user_profile_icon.svg';
  final String _videoSearchButtonAsset = 'assets/video_search_icon.svg';
  final String _optionsButtonAsset = 'assets/options_icon.svg';

  late double height;
  late double width;

  int _bottomNavBarIndex = 1;
  int _symbolsLeft = 650;

  TextEditingController? bioTextController;
  FocusNode? bioTextFocusNode;

  String? bioValue = '';

  @override
  void initState() {
    super.initState();

    bioTextFocusNode = FocusNode();
    bioTextController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    bioTextFocusNode!.dispose();
    bioTextController!.dispose();
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
             appBar: AppBar(
               elevation: 0,
               automaticallyImplyLeading: false,
               systemOverlayStyle: SystemUiOverlayStyle.light,
               backgroundColor: Colors.transparent,
             ),
             body: _bottomNavBarIndex == 1 ? RefreshIndicator(
               color: Color.fromRGBO(145, 10, 251, 5),
               child: SingleChildScrollView(
                 scrollDirection: Axis.vertical,
                 physics: BouncingScrollPhysics(),
                 child: mainBody(),
               ),
               strokeWidth: 1,
               onRefresh: () {
                 return Future.delayed(Duration(milliseconds: 1000));
               },
             ) : _bottomNavBarIndex == 4 ? SettingsPage() : null,
             bottomNavigationBar: Container(
               height: height / 8.5,
               child: BottomNavigationBar(
                 type: BottomNavigationBarType.fixed,
                 elevation: 20,
                 selectedItemColor: Color.fromRGBO(145, 10, 251, 5),
                 selectedLabelStyle: TextStyle(color: Color.fromRGBO(145, 10, 251, 5)),
                 unselectedItemColor: Colors.grey,
                 iconSize: 8,
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
                               SvgPicture.asset(_chatButtonAsset, color: _bottomNavBarIndex == 0 ? Color.fromRGBO(145, 10, 251, 5) : Colors.grey, height: 30, width: 30),
                               Positioned(
                                 left: constraints.maxWidth / 2,
                                 bottom: 15,
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
                       icon: SvgPicture.asset(_videoSearchButtonAsset, color: _bottomNavBarIndex == 3 ? Color.fromRGBO(145, 10, 251, 5) : Colors.grey)
                   ),
                   BottomNavigationBarItem(
                       label: 'Ещё',
                       icon:  SvgPicture.asset(_optionsButtonAsset, color: _bottomNavBarIndex == 4 ? Color.fromRGBO(145, 10, 251, 5) : Colors.grey)
                   )
                 ],
                 onTap: (index){
                   setState(() {
                     _bottomNavBarIndex = index;
                   });
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
    return Column(
      children: [
        Align(
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
                            height: constraints.maxHeight * 0.55,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white
                            ),
                            child: Stack(
                              children: [
                                Image.asset('assets/sample_pic.png', fit: BoxFit.cover),
                                Positioned(
                                  top: constraints.maxHeight * 0.35,
                                  left: constraints.maxHeight * 0.38,
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
                                          size: constraints.maxHeight / 6
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Мой профиль', style: TextStyle(color: Colors.white, fontSize: 17)),
                            SizedBox(width: width / 2.45),
                            InkWell(
                              child: IconButton(
                                icon: Icon(Icons.settings, color: Colors.white),
                                constraints: BoxConstraints(
                                    maxHeight: 10,
                                    maxWidth: 10
                                ),
                                onPressed: () {
                                  print('fffff');
                                },
                              ),
                            )
                          ],
                        ),
                        Text('Кристина З. 23 🇷🇺', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 3),
                        Text('Менеджер-логист в логистической к...', style: TextStyle(fontSize: 15, color: Colors.grey))
                      ],
                    )
                  ],
                ),
              )
            ),
          )
        ),
        SizedBox(height: height / 25),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Мои интересы', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)),
              InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OtherUsersPage()
                    )
                  );
                },
                child: Text('Редактировать', style: TextStyle(fontSize: 17, color: Color.fromRGBO(145, 10, 251, 5))),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 100,
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
        Container(
          height: height / 12,
          child: LayoutBuilder(
            builder: (context, constraints) {
             return Stack(
               children: [
                 Container(
                     padding: EdgeInsets.symmetric(horizontal: width / 15),
                     child: Text(
                       'В то время некий безымянный печатник создал большую коллекцию размеров и форм шрифтов, используя Lorem Ipsum для распечатки образцов. Lorem Ipsum не только успешно пережил без заметных',
                       style: TextStyle(fontSize: 15, color: Colors.black),
                       overflow: TextOverflow.fade,
                       maxLines: 4,
                     )
                 ),
                 Positioned(
                     top: constraints.maxHeight / 1.5,
                     right: constraints.maxWidth / 40,
                     child: InkWell(
                       onTap: () => null,
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
          padding: EdgeInsets.only(left: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(10, (index) {
                if(index == 0){
                  return Row(
                    children: [
                      ClipRRect(
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
                      ),
                      SizedBox(width: 10)
                    ],
                  );
                }else{
                  return Row(
                    children: [
                      InkWell(
                        onTap: () => null,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: Container(
                            height: height / 5,
                            width: width / 4.5,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                      SizedBox(width: 10)
                    ],
                  );
                }
              }),
            ),
          )
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
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
          padding: EdgeInsets.only(left: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: List.generate(10, (rowIndex){
                  return Row(
                    children: [
                      Column(
                        children: List.generate(2, (columnIndex){
                          if(rowIndex == 0 && columnIndex == 0){
                            return Column(
                              children: [
                                ClipRRect(
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
                                SizedBox(height: 10),
                              ],
                            );
                          }else{
                            return Column(
                              children: [
                                InkWell(
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
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage('assets/sample_user_pic.png'),
                                            fit: BoxFit.cover,
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            );
                          }
                        }),
                      ),
                      SizedBox(width: 10)
                    ],
                  );
                })
            ),
          )
        )
      ],
    );
  }

  Widget editBioWidget(BuildContext sheetContext) {
    return StatefulBuilder(
      builder: (context, setState) {
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
                      style: TextStyle(color: Colors.grey),
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
                          setState(() {
                            --_symbolsLeft;
                          });
                        }else{
                          setState(() {
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
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: height * 0.10,
                                child: Center(
                                    child: Text('Сохранить',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 17))),
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
}