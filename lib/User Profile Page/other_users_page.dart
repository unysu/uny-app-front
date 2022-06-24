import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/Data%20Models/Interests%20Data%20Model/interests_data_model.dart';
import 'package:uny_app/Data%20Models/Media%20Data%20Model/media_data_model.dart';
import 'package:uny_app/Data%20Models/Photo%20Search%20Data%20Model/photo_search_data_model.dart';
import 'package:uny_app/Report%20Page%20Android/report_page_android.dart';
import 'package:uny_app/Report%20Types/report_types.dart';
import 'package:uny_app/User%20Profile%20Page/all_photos_page.dart';
import 'package:uny_app/User%20Profile%20Page/video_page.dart';
import 'package:uny_app/Zodiac%20Signes/zodiac_signs.dart';

class OtherUsersPage extends StatefulWidget{

  Matches? user;

  OtherUsersPage({required this.user});

  @override
  _OtherUsersPage createState() => _OtherUsersPage();
}

class _OtherUsersPage extends State<OtherUsersPage>{

  late double height;
  late double width;

  FToast? _fToast;
  Reports? _reports;

  Matches? user;

  MediaModel? userProfilePhoto;
  List<MediaModel>? mainPhotos;
  List<MediaModel>? videos;
  List<MediaModel>? photos;

  @override
  void initState() {
    super.initState();

    _fToast = FToast();

    user = widget.user;

    if(user!.media!.mainPhoto != null){
      userProfilePhoto = user!.media!.mainPhoto;
    }

    if(user!.media!.mainPhotosList != null){
      mainPhotos = user!.media!.mainPhotosList!;

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
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        return Sizer(
          builder: (context, orientation, deviceType) {
            return ResponsiveWrapper.builder(
              Scaffold(
                body: NestedScrollView (
                    physics: BouncingScrollPhysics(),
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return[
                        SliverAppBar(
                          centerTitle: false,
                          floating: true,
                          backgroundColor: Colors.white,
                          expandedHeight: height * 0.4,
                          systemOverlayStyle: SystemUiOverlayStyle.light,
                          toolbarHeight: 120,
                          title: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${user!.firstName} ' + '${user!.lastName[0]}',
                                  style: TextStyle(fontSize: 24, color: Colors.white),
                                ),
                                Text('${user!.id}'),
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
                          flexibleSpace: FlexibleSpaceBar(
                            centerTitle: false,
                            background: ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(50),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/user_pic.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          leading: Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                                  child: IconButton(
                                  icon: Icon(Icons.arrow_back, color: Colors.white),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              )
                            ],
                          ),
                          actions: [
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                                child: Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.more_horiz),
                                      onPressed: (){
                                        showActionsSheet();
                                      },
                                    ),
                                    Container(
                                      height: 30,
                                      width: 30,
                                      child: SvgPicture.asset('assets/mail_icon.svg'),
                                    )
                                  ],
                                )
                            )
                          ],
                        ),
                      ];
                    },
                    body: SafeArea(
                      top: false,
                      minimum: EdgeInsets.only(top: 10),
                      child: mainBody(),
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
        );
      },
    );
  }

  Widget mainBody(){
    return Wrap(
      children: [
        Container(
          height: height,
          child: Column(
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
                                color: Colors.blue,
                                shape: BoxShape.circle
                            ),
                          ),
                          SizedBox(width: 5),
                          Text('Москва', style: TextStyle(fontSize: 17)),
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
                                    colors: [
                                      Color.fromRGBO(145, 10, 251, 10),
                                      Color.fromRGBO(217, 10, 251, 10)
                                    ]
                                )
                            ),
                          ),
                          SizedBox(width: 5),
                          Text('${Random().nextInt(1000)} м'),
                          SizedBox(width: 15),
                          ZodiacSigns.getZodiacSign(DateTime(int.parse(user!.dateOfBirth[0]), int.parse(user!.dateOfBirth[1]), int.parse(user!.dateOfBirth[2])), 0)
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
                      child: Container(
                        height: 50,
                        child: Center(
                          child: Text('Реакция', style: TextStyle(color: Colors.black)),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.deepOrange)
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 50,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
              SizedBox(height: height / 40),
              Container(
                height: 100,
                width: width * 3,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                        padding: EdgeInsets.only(left: 10),
                        width: width * 3,
                        child: Wrap(
                            spacing: 7.0,
                            runSpacing: 9.0,
                            direction: Axis.horizontal,
                            children: List.generate(user!.interests!.length, (index) {
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
              ),
              Container(
                child: Divider(
                  thickness: 1,
                ),
              ),
              user!.aboutMe != null ? Container(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Text('${user!.aboutMe}',
                  maxLines: 3,
                  style: TextStyle(fontSize: 15),
                ),
              ) : Container(),
              user!.aboutMe != null ? SizedBox(height: height / 10) : SizedBox(),
              Divider(
                color: Colors.grey.withOpacity(0.1),
                thickness: 8,
              ),
              Container(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Актуальные видео', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)),
                    InkWell(
                      child: Text('Все', style: TextStyle(fontSize: 17, color: Color.fromRGBO(145, 10, 251, 5))),
                    )
                  ],
                ),
              ),
              Container(
                height: 200,
                padding: EdgeInsets.only(left: 10, top: 10),
                child:  videos!.isNotEmpty ? GridView.count(
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
                                builder: (context) => VideoPage(videoId: videos![index].id)
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
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Фото', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)),
                    InkWell(
                      child: Text('Все', style: TextStyle(fontSize: 17, color: Color.fromRGBO(145, 10, 251, 5))),
                    )
                  ],
                ),
              ),
              photos!.isNotEmpty ? Container(
                  height: height / 2,
                  width: width,
                  padding: EdgeInsets.only(top: 10),
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 10,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: List.generate(photos!.length, (index){
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
                            child: CachedNetworkImage(
                              imageUrl: photos![index].url,
                              fit: BoxFit.cover,
                            )
                        ),
                      );
                    }),
                  )
              ) : Container(
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
                    children: [
                      Icon(CupertinoIcons.arrowshape_turn_up_right, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('Поделиться', style: TextStyle(color: Colors.blue)),
                    ],
                  )
                ),
                CupertinoActionSheetAction(
                  onPressed: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.doc_on_doc, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('Скопировать ссылку', style: TextStyle(color: Colors.blue)),
                    ],
                  )
                ),
                CupertinoActionSheetAction(
                  onPressed: () => _showReportOptions(),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('Пожаловаться', style: TextStyle(color: Colors.blue)),
                    ],
                  )
                ),
                CupertinoActionSheetAction(
                  child: Row(
                    children: [
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
        children: [
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
                return Container(
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
}