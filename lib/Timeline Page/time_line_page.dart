import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_framework/responsive_framework.dart';

class TimeLinePage extends StatefulWidget{

  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage>{

  late double height;
  late double width;

  bool _isPeopleSelected = false;
  bool _isTimelineSelected = true;
  bool _isInterestsSelected = false;
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        return ResponsiveWrapper.builder(
          Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                toolbarHeight: height / 6,
                title: Padding(
                  padding: EdgeInsets.only(top: height / 15),
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
                            children: const [
                              Icon(CupertinoIcons.search, color: Colors.grey),
                              Text('Поиск интересов',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.grey))
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
                      Container(
                        child: Row(
                          children: [
                            TextButton(
                              child: Text(
                                'Люди',
                                style: TextStyle(color: _isPeopleSelected ? Color.fromRGBO(145, 10, 251, 5) : Colors.grey, fontSize: 17),
                              ),
                              onPressed: (){
                                setState(() {
                                  _isPeopleSelected = true;

                                  _isTimelineSelected = false;
                                  _isInterestsSelected = false;
                                });
                              },
                              style: ButtonStyle(
                                  splashFactory: NoSplash.splashFactory
                              ),
                            ),
                            const SizedBox(width: 5),
                            TextButton(
                              child: Text(
                                'Лента',
                                style: TextStyle(color: _isTimelineSelected ? Color.fromRGBO(145, 10, 251, 5) : Colors.grey, fontSize: 17),
                              ),
                              onPressed: (){
                                setState(() {
                                  _isTimelineSelected = true;

                                  _isPeopleSelected = false;
                                  _isInterestsSelected = false;
                                });
                              },
                              style: ButtonStyle(
                                  splashFactory: NoSplash.splashFactory
                              ),
                            ),
                            const SizedBox(width: 5),
                            TextButton(
                              child: Text(
                                'Интересы',
                                style: TextStyle(color: _isInterestsSelected ? Color.fromRGBO(145, 10, 251, 5) : Colors.grey, fontSize: 17),
                              ),
                              onPressed: (){
                                setState(() {
                                  _isInterestsSelected = true;

                                  _isTimelineSelected = false;
                                  _isPeopleSelected = false;
                                });
                              },
                              style: ButtonStyle(
                                  splashFactory: NoSplash.splashFactory
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ),
              body: SingleChildScrollView(
                child: mainBody(),
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

  Widget mainBody(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.only(left: width / 21),
          child: Text('Лента', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 15),
        Container(
          width: width,
          height: 200,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(top: 10, left: width / 32),
                            child: ClipRRect(
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/simple_pic_timeline.png')
                                    )
                                ),
                              ),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(10)
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Кристина Зеленская',
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '20 марта в 16:30 UnyApp',
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.more_horiz, color: Colors.grey),
                      onPressed: () => null,
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 25),
                child: Container(
                  child: Text(
                      'Приглашаем на эфир в 20:00 (мск), обсудим последние новости в сфере IT! Спикер сегодня - Кристина Зеленская - основатель Юнити!',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20),
                child: Container(
                  child: Row(
                    children: [
                      Image.asset('assets/google_meet_icon.png'),
                      SizedBox(width: 5),
                      Text('meet.google.com', style: TextStyle(color: Colors.blueAccent)),
                      IconButton(
                        iconSize: 14,
                        icon: Icon(Icons.open_in_new, color: Colors.blueAccent),
                        onPressed: () => null,
                        constraints: BoxConstraints(
                          minWidth: 0,
                          minHeight: 0
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: width / 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/timeline_comments_icon.svg'),
                          SizedBox(width: 2),
                          Text('285', style: TextStyle(color: Colors.black))
                        ],
                      ),
                    ),
                    SizedBox(width: 15),
                    Container(
                      child: Row(
                        children: [
                          Icon(Icons.add_circle_outline),
                          SizedBox(width: 2),
                          Text('12', style: TextStyle(color: Colors.black))
                        ],
                      ),
                    ),
                    SizedBox(width: 15),
                    Container(
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.arrowshape_turn_up_right),
                          SizedBox(width: 2),
                          Text('2.6K', style: TextStyle(color: Colors.black))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Icon(Icons.add, color: Colors.black),
                    SizedBox(width: 5),
                    Text('🤑 😂 😍', style: TextStyle(fontSize: 24))
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}