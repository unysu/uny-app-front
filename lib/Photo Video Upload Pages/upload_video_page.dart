import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/API/uny_app_api.dart';
import 'package:uny_app/Constants/constants.dart';
import 'package:uny_app/Interests%20Page/choose_interests_page.dart';
import 'package:uny_app/Photo%20Video%20Upload%20Pages/video_trimmer_page.dart';
import 'package:uny_app/Token%20Data/token_data.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';



class UploadVideoPage extends StatefulWidget{
  @override
  _UploadVideoPageState createState() => _UploadVideoPageState();
}


class _UploadVideoPageState extends State<UploadVideoPage>{

  late double height;
  late double width;

  late List<AssetPathEntity> albums;
  late List<AssetEntity> media;

  final ImagePicker _picker = ImagePicker();

  File? _selectedVideo;
  File? _croppedVideo;
  Uint8List? _videoImageBytes;

  final String _mainImageAsset = 'assets/upload_video_page_icon.svg';
  final String _newMediaImageAsset = 'assets/new_media.svg';

  bool _showLoading = false;


  @override
  void initState() {
    _fetchAlbums();
    super.initState();
  }

  _fetchAlbums() async {
    albums = await PhotoManager.getAssetPathList(onlyAll: true, type: RequestType.video);
    media = await albums[0].getAssetListPaged(page: 0, size: 10000);
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
                  systemOverlayStyle: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Colors.grey : Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: mainBody(),
              ),
            maxWidth: 800,
            minWidth: 450,
            defaultScale: true,
            breakpoints: [
              ResponsiveBreakpoint.resize(450, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: MOBILE),
            ],
          );
        }
    );
  }

  Widget mainBody(){
    return Column(
      children: [
        Container(
          height: height * 0.3,
          padding: EdgeInsets.only(top: height / 8, left: width / 10, right: width / 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Загрузи первое видео',
                  style: TextStyle(fontSize: 24,
                      color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              SizedBox(
                width: width,
                height: height / 11,
                child: Text(
                  'Так ты попадешь в рекомендации и с большей вероятностью найдешь новые знакомства',
                  maxLines: 3,
                  style: TextStyle(fontSize: 17, color: Colors.grey),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: height * 0.01),
        Container(
          height: _selectedVideo != null ?  300 : height * 0.4,
          width: _selectedVideo != null ? width / 2 : width * 0.9,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: LayoutBuilder(
            builder: (context, constraints){
              double dHeight = constraints.maxHeight;
              double dWidth = constraints.maxWidth;
              return Stack(
                children: [
                  Container(
                    margin: _croppedVideo != null ? EdgeInsets.symmetric(horizontal: 60) : null,
                    child: _croppedVideo == null ? SvgPicture.asset(_mainImageAsset) : Container(),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(10)),
                        image: _croppedVideo != null ? DecorationImage(
                            fit: BoxFit.cover,
                            image: MemoryImage(_videoImageBytes!)
                        ) : null
                    ),
                  ),
                  _croppedVideo != null ? Positioned(
                      top: dHeight / 1.11,
                      left: dWidth / 1.39,
                      child: IconButton(
                      alignment: Alignment.bottomRight,
                      icon: Icon(CupertinoIcons.clear_thick_circled,
                          color: Colors.white, size: 35),
                      onPressed: () {
                        setState(() {
                          _selectedVideo = null;
                          _croppedVideo = null;
                          _videoImageBytes = null;
                        });
                      },
                    ),
                  ) : Container()
                ],
              );
            },
          )
        ),
        SizedBox(height: height * 0.03),
        Padding(
          padding: EdgeInsets.only(left: width / 15, right: width / 15),
          child: InkWell(
            borderRadius: BorderRadius.circular(11),
            onTap: () async {
              showCupertinoModalBottomSheet(
                  context: context,
                  duration: Duration(milliseconds: 250),
                  topRadius: Radius.circular(25),
                  builder: (context) {
                    return media.isNotEmpty ? showPhotoVideoBottomSheet(media) : Center(
                      child: Text('У вас нет фото или видео'),
                    );
                  }
              );
            },
            child: Container(
              height: height / 15,
              child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(_newMediaImageAsset),
                      SizedBox(width: 5),
                      Text('Загрузить из медиатеки', style: TextStyle(
                          color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Colors.black : Colors.white, fontSize: 17))
                    ],
                  )
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                      color: Colors.grey,
                      width: 0.5
                  )
              ),
            ),
          ),
        ),
        SizedBox(height: height / 50),
        Text(
          'Длительность видео не более 15 сек.',
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
        SizedBox(height: height / 50),
        TextButton(
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InterestsPage())
            );
          },
          child: Text('Пропустить', style: TextStyle(fontSize: 17, color: Colors.grey)),
        ),
        SizedBox(height: height / 50),
        Padding(
          padding: EdgeInsets.only(left: width / 4, right: width / 4),
          child: Material(
            borderRadius: BorderRadius.circular(11),
            color: Color.fromRGBO(145, 10, 251, 5),
            child: InkWell(
              onTap: () async {

                String token = 'Bearer ' + TokenData.getUserToken();

                setState(() {
                  _showLoading = true;
                });

                if(_croppedVideo != null){
                  String path = _croppedVideo!.path;

                  String? mime = lookupMimeType(path);

                  Uint8List videoBytes = File(path).readAsBytesSync();

                  String base64Video = base64Encode(videoBytes);

                  var data = {
                    'media' : base64Video,
                    'mime' : mime,
                    'filter' : '-'
                  };

                 await UnyAPI.create(Constants.SIMPLE_RESPONSE_CONVERTER).uploadMedia(token, data).whenComplete((){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InterestsPage())
                    );
                  });
                }else{
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InterestsPage())
                  );
                }
              },
              child: SizedBox(
                height: height / 15,
                child: Center(
                    child: !_showLoading
                        ? Text('Далее', style: TextStyle(
                        color: Colors.white.withOpacity(0.9), fontSize: 17))
                        : SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget showPhotoVideoBottomSheet(List<AssetEntity> media) {
    return Material(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: width / 20),
                Text('Видео', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Center(
                      child: Icon(Icons.close, size: 17, color: Colors.grey),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        shape: BoxShape.circle
                    ),
                  ),
                )
              ],
            ),
          ),
          GridView.count(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(left: 10, right: 10),
              shrinkWrap: true,
              crossAxisCount: 4,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              children: List.generate(media.length, (index){
                return InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  onTap: () async {
                    media[index].file.then((file) async {
                      String? path = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TrimmerView(file!.path))
                      );

                      VideoPlayerController videoController = VideoPlayerController.file(File(path!));
                      await videoController.initialize();

                      if(videoController.value.duration.inSeconds >= 3 && videoController.value.duration.inSeconds <= 15){
                        _croppedVideo = File(path);
                        _videoImageBytes = await VideoThumbnail.thumbnailData(
                          video: file!.path,
                          imageFormat: ImageFormat.PNG,
                        );

                        Navigator.pop(context);
                        setState((){});
                      }else{
                        _croppedVideo = null;
                        setState((){});
                        if(UniversalPlatform.isIOS){
                          showCupertinoDialog(
                              context: context,
                              builder: (context){
                                return CupertinoAlertDialog(
                                  title: Text('Ошибка загрузки'),
                                  content: Center(
                                    child: Text(
                                        'Длительность видео должен быть не более 15 сек'),
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: Text('Закрыть'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                );
                              }
                          );
                        }else if(UniversalPlatform.isAndroid){
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Ошибка загрузки'),
                                  content: Text('Длительность видео должен быть не более 15 сек'),
                                  actions: [
                                    FloatingActionButton.extended(
                                      label: Text('Закрыть'),
                                      backgroundColor: Color.fromRGBO(145, 10, 251, 5),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                );
                              }
                          );
                        }
                      }
                    });
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        child: AssetEntityImage(
                          media[index],
                          width: 5,
                          height: 5,
                          fit: BoxFit.cover,
                          isOriginal: false,
                        ),
                      ),
                      Positioned(
                          bottom: 10,
                          left: 2,
                          child: media[index].type.name.toString().startsWith('video') ? Icon(Icons.play_arrow, color: Colors.white, size: 20) : Container()
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: media[index].type.name.toString().startsWith('video') ? Text(media[index].videoDuration.toString().split('.')[0], style: TextStyle(color: Colors.white)) : Container(),
                      )
                    ],
                  ),
                );
              })
          ),
        ],
      ),
    );
  }
}

