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
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/API/uny_app_api.dart';
import 'package:uny_app/Constants/constants.dart';
import 'package:uny_app/Interests%20Pages/choose_interests_page.dart';
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

  final ImagePicker _picker = ImagePicker();
  XFile? _video;
  Uint8List? _videoImageBytes;

  final String _mainImageAsset = 'assets/upload_video_page_icon.svg';
  final String _newMediaImageAsset = 'assets/new_media.svg';

  bool _showLoading = false;

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
                  '?????????????? ???????????? ??????????',
                  style: TextStyle(fontSize: 24,
                      color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              SizedBox(
                width: width,
                height: height / 11,
                child: Text(
                  '?????? ???? ???????????????? ?? ???????????????????????? ?? ?? ?????????????? ???????????????????????? ?????????????? ?????????? ????????????????????',
                  maxLines: 3,
                  style: TextStyle(fontSize: 17, color: Colors.grey),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: height * 0.01),
        Container(
          height: _video != null ?  300 : height * 0.4,
          width: _video != null ? width / 2 : width * 0.9,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: LayoutBuilder(
            builder: (context, constraints){
              double dHeight = constraints.maxHeight;
              double dWidth = constraints.maxWidth;
              return Stack(
                children: [
                  Container(
                    child: _video == null ? SvgPicture.asset(_mainImageAsset) : null,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(10)),
                        image: _video != null ? DecorationImage(
                            fit: BoxFit.cover,
                            image: MemoryImage(_videoImageBytes!)
                        ) : null
                    ),
                  ),
                  _video != null ? Positioned(
                      top: dHeight / 1.13,
                      left: dWidth / 1.26,
                      child: IconButton(
                      alignment: Alignment.bottomRight,
                      icon: Icon(CupertinoIcons.clear_thick_circled,
                          color: Colors.white, size: 35),
                      onPressed: () {
                        setState(() {
                          _video = null;
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
              _video = await _picker.pickVideo(source: ImageSource.gallery);

              VideoPlayerController videoController = VideoPlayerController.file(File(_video!.path));
              await videoController.initialize();

              if(videoController.value.duration.inSeconds <= 15){
                _videoImageBytes = await VideoThumbnail.thumbnailData(
                  video: _video!.path,
                  imageFormat: ImageFormat.PNG,
                );
                setState((){});
              }else{
                _video = null;
                setState((){});
                if(UniversalPlatform.isIOS){
                  showCupertinoDialog(
                    context: context,
                    builder: (context){
                      return CupertinoAlertDialog(
                        title: Text('???????????? ????????????????'),
                        content: Center(
                          child: Text(
                              '???????????????????????? ?????????? ???????????? ???????? ???? ?????????? 15 ??????'),
                        ),
                        actions: [
                          CupertinoDialogAction(
                            child: Text('??????????????'),
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
                          title: Text('???????????? ????????????????'),
                          content: Text('???????????????????????? ?????????? ???????????? ???????? ???? ?????????? 15 ??????'),
                          actions: [
                            FloatingActionButton.extended(
                              label: Text('??????????????'),
                              backgroundColor: Color.fromRGBO(145, 10, 251, 5),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        );
                      }
                  );
                }
              }
            },
            child: Container(
              height: height / 15,
              child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(_newMediaImageAsset),
                      SizedBox(width: 5),
                      Text('?????????????????? ???? ??????????????????', style: TextStyle(
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
          '???????????????????????? ?????????? ???? ?????????? 15 ??????.',
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
          child: Text('????????????????????', style: TextStyle(fontSize: 17, color: Colors.grey)),
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

                if(_video != null){
                  String path = _video!.path;

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
                        ? Text('??????????', style: TextStyle(
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
}

