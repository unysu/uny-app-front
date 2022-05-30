import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/Shared%20Preferences/shared_preferences.dart';
import 'package:uny_app/Video%20Search%20Page/filter_interests_page.dart';
import 'package:uny_app/Video%20Search%20Page/interests_counter_provider.dart';

class VideoSearchPage extends StatefulWidget {

  @override
  _VideoSearchPageState createState() => _VideoSearchPageState();
}

class _VideoSearchPageState extends State<VideoSearchPage> with TickerProviderStateMixin {

  AnimationController? controller;
  AnimationController? emojisAnimationController;

  late FocusNode _startAgeFieldFocusNode;
  late FocusNode _endAgeFieldFocusNode;

  late TextEditingController _startAgeFieldTextController;
  late TextEditingController _endAgeFieldTextController;

  late double height;
  late double width;

  final String _chatAsset = 'assets/chat_video_search.svg';
  final String _reactionAsset = 'assets/video_search_reaction.svg';


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

    _startAgeFieldFocusNode = FocusNode();
    _endAgeFieldFocusNode = FocusNode();

    _startAgeFieldTextController = TextEditingController();
    _endAgeFieldTextController = TextEditingController();

    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    emojisAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));


    super.initState();
  }


  @override
  void dispose(){

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
                toolbarHeight: height / 4.2,
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
              body: GestureDetector(
                child: mainBody(),
                onTap: () {
                  if (_isReactionButtonTapped == false) {
                    return;
                  } else {
                    setState(() {
                      _isReactionButtonTapped = !_isReactionButtonTapped;
                    });
                    controller!.reverse();
                    emojisAnimationController!.reverse();

                    animateBlur();
                  }
                },
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
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/video_sample_pic.png'),
                fit: BoxFit.cover,
              )
          ),
        ),
        Positioned(
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
                          )
                        ],
                      ),
                    )
                ),
              );
            },
          ) : Container(),
        ),
        Positioned(
            top: height / 2,
            left: width / 1.18,
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
                        onTap: () => null,
                        child: Stack(
                          children: [
                            Container(
                              height: height / 14,
                              width: width / 8,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/video_search_sample_pic.png')
                                  ),
                                  border: Border.all(color: Colors.white)
                              ),
                            ),
                            Positioned(
                              top: height / 20,
                              left: width / 69,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: Text('64 %', style: TextStyle(
                                    color: Colors.white)),
                                decoration: BoxDecoration(
                                  color: Colors.deepOrangeAccent,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                              ),
                            )
                          ],
                        )
                    )
                )
              ],
            )
        ),
        Positioned(
            top: height / 1.69,
            left: width / 1.19,
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
                    onTap: () => null,
                    child: Container(
                      height: 60,
                      width: 60,
                      child: Center(
                        child: SvgPicture.asset(_chatAsset),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text('Написать',
                      style: TextStyle(fontSize: 14, color: Colors.white))
                ],
              ),
            )
        ),
        Positioned(
            top: height / 1.42,
            left: width / 1.18,
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
                      setState(() {
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
            top: height / 1.12,
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
              child: Text('Анастасия Ч. 29',
                  style: TextStyle(fontSize: 24, color: Colors.white)),
            )
        ),
      ],
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
      builder: (context, setState) {
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
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'От 18',
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
                                focusNode: _endAgeFieldFocusNode,
                                decoration: InputDecoration(
                                  hintText: 'До 35',
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