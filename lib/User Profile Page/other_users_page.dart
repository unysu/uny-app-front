import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/Report%20Page%20Android/report_page_android.dart';
import 'package:uny_app/Report%20Types/report_types.dart';
import 'package:uny_app/Zodiac%20Signes/zodiac_signs.dart';

class OtherUsersPage extends StatefulWidget{

  @override
  _OtherUsersPage createState() => _OtherUsersPage();
}

class _OtherUsersPage extends State<OtherUsersPage>{

  late double height;
  late double width;

  FToast? _fToast;
  Reports? _reports;

  @override
  void initState() {
    super.initState();

    _fToast = FToast();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
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
                          toolbarHeight: 75,
                          title: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Кристина З. 25',
                                  style: TextStyle(fontSize: 24, color: Colors.white),
                                ),
                                Text('Основатель Uny')
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
                          leading: IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          actions: [
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                child: IconButton(
                                  icon: Icon(Icons.more_horiz),
                                  onPressed: (){
                                    showActionsSheet();
                                  },
                                )
                            )
                          ],
                        ),
                      ];
                    },
                    body: SafeArea(
                      top: true,
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
                          SizedBox(width: 10),
                          Container(
                            height: 5,
                            width: 5,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey
                            ),
                          ),
                          SizedBox(width: 10),
                          ZodiacSigns.getScorpionSign()
                        ],
                      ),
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          color: Colors.grey.withOpacity(0.3),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,

                                ),
                              ),
                              SizedBox(width: 5),
                              Text('В сети', style: TextStyle(fontSize: 15))
                            ],
                          ),
                        )
                    )
                  ],
                ),
              ),
              SizedBox(height: height / 50),
              Container(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child:  ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: InkWell(
                    onTap: () => null,
                    child: Container(
                      height: height / 20,
                      child: Center(
                        child: Text('Написать', style: TextStyle(fontSize: 17, color: Colors.white)),
                      ),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color.fromRGBO(145, 10, 251, 5),
                                Color.fromRGBO(32, 216, 216, 5),
                              ]
                          )
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height / 40),
              Container(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Совподения', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)),
                    Text('2 интереса', style: TextStyle(fontSize: 17, color: Colors.grey))
                  ],
                ),
              ),
              SizedBox(height: height / 15),
              Container(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Row(
                  children: [
                    Text('Интересы', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              SizedBox(height: height / 10),
              Divider(
                color: Colors.grey,
              ),
              Container(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Text(
                  'Despite years of loving alcohol I no longer drink. I am not a recovering alcoholic, nor do I have any religious (or otherwise) views which dictate abstinence.',
                  maxLines: 3,
                  style: TextStyle(fontSize: 15),
                ),
              ),
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Row(
                    children: List.generate(10, (index) {
                      return Row(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              child: InkWell(
                                child: Container(
                                  height: height / 5,
                                  width: width / 4.5,
                                  color: Colors.purple,
                                ),
                              )
                          ),
                          SizedBox(width: 10)
                        ],
                      );
                    }),
                  ),
                ),
              )
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
                      Text('Поделиться'),
                    ],
                  )
                ),
                CupertinoActionSheetAction(
                  onPressed: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.doc_on_doc, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('Скопировать ссылку'),
                    ],
                  )
                ),
                CupertinoActionSheetAction(
                  onPressed: () => _showReportOptions(),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('Пожаловаться'),
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