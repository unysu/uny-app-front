import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uny_app/App%20Bar%20/sliding_app_bar.dart';
import 'package:uny_app/Data%20Models/Media%20Data%20Model/media_data_model.dart';
import 'package:uny_app/Other%20Users%20Page/other_users_page.dart';
import 'package:uny_app/Token%20Data/token_data.dart';

class OtherUsersPhotoViewer extends StatefulWidget{

  List<MediaModel>? photos;

  OtherUsersPhotoViewer({required this.photos});
  
  @override
  _OtherUsersPhotoViewerState createState() => _OtherUsersPhotoViewerState();
}

class _OtherUsersPhotoViewerState extends State<OtherUsersPhotoViewer> with SingleTickerProviderStateMixin{


  FToast? _fToast;

  bool _showLoading = false;

  late String token;

  late double height;
  late double width;

  late final AnimationController _controller;

  bool _showAppBar = true;
  int _currentPic = 1;

  StateSetter? picsState;

  List<MediaModel>? photos;

  List<String>? base64Photos = [];

  @override
  void initState() {
    super.initState();

    _fToast = FToast();

    token = 'Bearer ' + TokenData.getUserToken();

    photos = widget.photos;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _fToast!.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        return ResponsiveWrapper.builder(
          Scaffold(
            backgroundColor: Colors.black,
              extendBodyBehindAppBar: true,
              body: GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(top: height / 40),
                  child: mainBody(),
                ),
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
        physics: NeverScrollableScrollPhysics(),
        children: [
          SizedBox(height: 60),
          Stack(
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
                  items: List.generate(photos!.length, (index) {
                    return AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: photos![index].url,
                        fit: BoxFit.cover,
                      ),
                    );
                  }),
                ),
              ),
              Center(
                  heightFactor: 8,
                  child: _showLoading ? ClipRRect(
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
                  ) : Container()
              )
            ],
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
                        Text('${_currentPic} из ${photos!.length}', style: TextStyle(fontSize: 17, color: Colors.white)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: indicators(photos!.length, _currentPic),
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