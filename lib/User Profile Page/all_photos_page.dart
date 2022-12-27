import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/API/uny_app_api.dart';
import 'package:uny_app/App%20Bar/sliding_app_bar.dart';
import 'package:uny_app/Constants/constants.dart';
import 'package:uny_app/Data%20Models/Media%20Data%20Model/media_data_model.dart';
import 'package:uny_app/Providers/user_data_provider.dart';
import 'package:uny_app/Token%20Data/token_data.dart';

class AllPhotosPage extends StatefulWidget {
  @override
  _AllPhotosPageState createState() => _AllPhotosPageState();
}

class _AllPhotosPageState extends State<AllPhotosPage>
    with SingleTickerProviderStateMixin {
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
    return Consumer<UserDataProvider>(
      builder: (context, viewModel, child) {
        photos = viewModel.mediaDataModel!.otherPhotosList!
            .where((element) => (element.filter.toString().startsWith("-") &&
                element.type.toString().startsWith("image")))
            .toList();
        getBase64FromPhotos();
        return LayoutBuilder(
          builder: (context, constraints) {
            height = constraints.maxHeight;
            width = constraints.maxWidth;
            return ResponsiveWrapper.builder(
              Scaffold(
                  extendBodyBehindAppBar: true,
                  body: GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.only(top: height / 40),
                      child: mainBody(),
                    ),
                    onTap: () {
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
                      title: Text('Фотография',
                          style: TextStyle(color: Colors.white)),
                      centerTitle: true,
                      actions: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: IconButton(
                              icon: Icon(Icons.more_horiz),
                              onPressed: () {
                                if (UniversalPlatform.isIOS) {
                                  showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) {
                                        return showPicOptions();
                                      });
                                } else if (UniversalPlatform.isAndroid) {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return showPicOptions();
                                      });
                                }
                              },
                            ))
                      ],
                      leading: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: FittedBox(
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child:
                                Text('Закрыть', style: TextStyle(fontSize: 20)),
                          ),
                        ),
                      ),
                      leadingWidth: width / 5,
                    ),
                  )),
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

  Widget mainBody() {
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
                      onPageChanged: (index, reason) {
                        picsState!(() {
                          _currentPic = index + 1;
                        });
                      }),
                  items: List.generate(photos!.length, (index) {
                    return Consumer<UserDataProvider>(
                      builder: (context, viewModel, child) {
                        return AspectRatio(
                          aspectRatio: 1,
                          child: CachedNetworkImage(
                            imageUrl: photos![index].url,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
              Center(
                  heightFactor: 8,
                  child: _showLoading
                      ? ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            height: 80,
                            width: 80,
                            color: Colors.black.withOpacity(0.7),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Container())
            ],
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 400),
            transitionBuilder: (child, transition) {
              return SlideTransition(
                position: Tween<Offset>(begin: Offset.zero, end: Offset(0, 2))
                    .animate(
                  CurvedAnimation(
                      parent: _controller, curve: Curves.fastOutSlowIn),
                ),
                child: child,
              );
            },
            child: _showAppBar
                ? StatefulBuilder(
                    builder: (context, setState) {
                      picsState = setState;
                      return Container(
                          padding: EdgeInsets.only(top: 40),
                          child: Column(
                            children: [
                              Text('$_currentPic из ${photos!.length}',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.white)),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                    indicators(photos!.length, _currentPic),
                              ),
                            ],
                          ));
                    },
                  )
                : null,
          )
        ],
      ),
    );
  }

  Widget showPicOptions() {
    return Material(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35), topRight: Radius.circular(35)),
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
                  Text('Действия',
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
            ListTile(
              title: Text('Скачать фотографию'),
              leading: Icon(CupertinoIcons.arrow_down_to_line_alt),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 20),
              onTap: () => saveImage(),
            ),
            ListTile(
                title: Text('Сделать фотографией профиля'),
                leading: Icon(Icons.account_box_outlined),
                trailing: Icon(Icons.arrow_forward_ios_rounded, size: 20),
                onTap: () => setAsProfilePhoto()),
            Divider(
              thickness: 5,
              color: Colors.grey.withOpacity(0.2),
            ),
            ListTile(
                title: Text('Удалить фотографию',
                    style: TextStyle(color: Colors.red)),
                leading: Icon(Icons.delete_forever_outlined, color: Colors.red),
                trailing: Icon(Icons.arrow_forward_ios_rounded, size: 20),
                onTap: () => deleteMedia()),
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

  void getBase64FromPhotos() async {
    for (var image in photos!) {
      await http.get(Uri.parse(image.url)).then((value) {
        if (!(base64Photos!.contains(base64Encode(value.bodyBytes)))) {
          base64Photos!.add(base64Encode(value.bodyBytes));
        }
      });
    }
  }

  void saveImage() async {
    setState(() {
      _showLoading = true;
    });

    Uint8List bytes = base64Decode(base64Photos![_currentPic - 1]);

    String dir = (await getApplicationDocumentsDirectory()).path;

    String fullPath = '$dir/uny_image.png';

    File file = File(fullPath);
    await file.writeAsBytes(bytes).whenComplete(() async {
      await ImageGallerySaver.saveImage(bytes, quality: 100);

      setState(() {
        _showLoading = false;
      });

      Navigator.pop(context);
    });
  }

  void setAsProfilePhoto() async {
    setState(() {
      _showLoading = true;
    });

    var data = {'media_id': photos![_currentPic - 1].id, 'filter': 'main+'};

    await UnyAPI.create(Constants.SIMPLE_RESPONSE_CONVERTER)
        .updateMedia(token, data)
        .whenComplete(() async {
      _showToast(1);
      await UnyAPI.create(Constants.ALL_USER_DATA_MODEL_CONVERTER_CONSTANT)
          .getCurrentUser(token)
          .then((value) {
        Provider.of<UserDataProvider>(context, listen: false)
            .setUserDataModel(value.body!.user);
        Provider.of<UserDataProvider>(context, listen: false)
            .setMediaDataModel(value.body!.media);

        Navigator.pop(context);
        Navigator.pop(context);
      });
    });
  }

  void deleteMedia() async {
    setState(() {
      _showLoading = true;
    });

    var data = {
      'media_id': photos![_currentPic - 1].id,
    };

    await UnyAPI.create(Constants.SIMPLE_RESPONSE_CONVERTER)
        .deleteMedia(token, data)
        .whenComplete(() async {
      _showToast(0);
      await UnyAPI.create(Constants.ALL_USER_DATA_MODEL_CONVERTER_CONSTANT)
          .getCurrentUser(token)
          .then((value) {
        Provider.of<UserDataProvider>(context, listen: false)
            .setUserDataModel(value.body!.user);
        Provider.of<UserDataProvider>(context, listen: false)
            .setMediaDataModel(value.body!.media);

        setState(() {
          _showLoading = false;
        });

        Navigator.pop(context);
      });
    });
  }

  void _showToast(int index) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.black,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          index == 0
              ? Text("Фото удалено", style: TextStyle(color: Colors.white))
              : Text("Фото установлено фотографией пользователя",
                  style: TextStyle(color: Colors.white)),
          Container(
            height: 20,
            width: 20,
            child: Center(
              child: Icon(Icons.check, color: Colors.black, size: 15),
            ),
            decoration:
                BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          )
        ],
      ),
    );

    _fToast!.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 10),
    );
  }
}
