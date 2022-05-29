import 'dart:convert';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/App%20Bar%20/sliding_app_bar.dart';

class AllPhotosPage extends StatefulWidget {

  List<String>? photos;

  AllPhotosPage({required this.photos});

  @override
  _AllPhotosPageState createState() => _AllPhotosPageState();
}

class _AllPhotosPageState extends State<AllPhotosPage> with SingleTickerProviderStateMixin{

  late double height;
  late double width;

  late final AnimationController _controller;

  bool _showAppBar = true;
  int _currentPic = 1;

  StateSetter? picsState;
  
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

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
            body: GestureDetector(
              child: mainBody(),
              onTap: (){
                setState(() {
                  _showAppBar = !_showAppBar;
                });
              },
            ),
            appBar: SlidingAppBar(
              controller: _controller,
              visible: _showAppBar,
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Color.fromRGBO(44, 44, 49, 10),
                title: Text('Фотография', style: TextStyle(color: Colors.white)),
                centerTitle: true,
                actions: [
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: IconButton(
                        icon: Icon(Icons.more_horiz),
                        onPressed: (){
                          if(UniversalPlatform.isIOS){
                            showCupertinoModalPopup(
                                context: context,
                                builder: (context){
                                  return showPicOptions();
                                }
                            );
                          }else if(UniversalPlatform.isAndroid){
                            showModalBottomSheet(
                                context: context,
                                builder: (context){
                                  return showPicOptions();
                                }
                            );
                          }
                        },
                      )
                  )
                ],
                leading: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child:  FittedBox(
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Text('Закрыть', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
                leadingWidth: width / 5,
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

  Widget mainBody(){
    return Container(
      color: Colors.black,
      child: ListView(
        children: [
          SizedBox(height: 60),
          CarouselSlider(
            options: CarouselOptions(
                height: height / 1.5,
                enlargeCenterPage: true,
                scrollPhysics: PageScrollPhysics(),
                viewportFraction: 1,
                enableInfiniteScroll: false,
                disableCenter: false,
                pageSnapping: true,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason){
                  picsState!(() {
                    _currentPic = index + 1;
                  });
                }
            ),
            items: List.generate(widget.photos!.length, (index) {
              return CachedNetworkImage(
                imageUrl: widget.photos![index],
                fit: BoxFit.contain,
              );
            }),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 400),
            transitionBuilder: (child, transition){
              return SlideTransition(
                position: Tween<Offset>(begin: Offset.zero, end: Offset(0, 2)).animate(
                  CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
                ),
                child: child,
              );
            },
            child: _showAppBar ? StatefulBuilder(
              builder: (context, setState){
                picsState = setState;
                return Container(
                    padding: EdgeInsets.only(top: 40),
                    child: Column(
                      children: [
                        Text('${_currentPic} из ${widget.photos!.length}', style: TextStyle(fontSize: 17, color: Colors.white)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: indicators(widget.photos!.length, _currentPic),
                        ),
                      ],
                    )
                );
              },
            ) : null,
          )
        ],
      ),
    );
  }

  Widget showPicOptions(){
    return Material(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
      child: Container(
        height: height * 0.35,
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
              title: Text('Скачать фотографию'),
              leading: Icon(CupertinoIcons.arrow_down_to_line_alt),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 20),
            ),
            ListTile(
              title: Text('Сделать фотографией профиля'),
              leading: Icon(Icons.account_box_outlined),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 20),
              onTap: () => null,
            ),
            Divider(
              thickness: 5,
              color: Colors.grey.withOpacity(0.2),
            ),
            ListTile(
              title: Text('Удалить фотографию', style: TextStyle(color: Colors.red)),
              leading: Icon(Icons.delete_forever_outlined, color: Colors.red),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 20),
              onTap: () => null
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(3),
        width: 8,
        height: 8,
        decoration: BoxDecoration(
            color: currentIndex - 1 == index ? Colors.white : Colors.grey,
            shape: BoxShape.circle),
      );
    });
  }
}