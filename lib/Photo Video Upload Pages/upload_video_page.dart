
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/Interests%20Pages/choose_interests_page.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_player/video_player.dart';

class UploadVideoPage extends StatefulWidget{
  @override
  _UploadVideoPageState createState() => _UploadVideoPageState();
}


class _UploadVideoPageState extends State<UploadVideoPage>{

  late double height;
  late double width;

  ImagePicker _picker = ImagePicker();
  XFile? _video;
  Uint8List? _videoImageBytes;

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
                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: mainBody(),
              ),
              defaultScale: true,
              breakpoints: [
                const ResponsiveBreakpoint.resize(480, name: MOBILE),
                const ResponsiveBreakpoint.resize(720, name: MOBILE)
              ]
          );
        }
    );
  }


  Widget mainBody(){
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
              top: height / 8, left: width / 10, right: width / 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Загрузи первое видео',
                  style: TextStyle(fontSize: 24,
                      color: Colors.black,
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
        SizedBox(height: height / 200),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 4),
          child: Stack(
            children: [
              Container(
                height: _videoImageBytes != null ? height / 2.5 : height / 2,
                width: _videoImageBytes != null ? width / 2 : width,
                child: _videoImageBytes == null ? Image(
                  image: AssetImage('assets/upload_video_page_icon.png'),
                ) : null,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(10)),
                    image: _videoImageBytes != null ? DecorationImage(
                        fit: BoxFit.cover,
                        image: MemoryImage(_videoImageBytes!)
                    ) : null
                ),
              ),
              _video != null ? Padding(
                padding: EdgeInsets.only(top: height * 0.360, left: width * 0.420),
                child: IconButton(
                  alignment: Alignment.bottomRight,
                  icon: Icon(CupertinoIcons.clear_thick_circled,
                      color: Colors.white, size: 40),
                  onPressed: () {
                    setState(() {
                      _video = null;
                      _videoImageBytes = null;
                    });
                  },
                ),
              ) : Container()
            ],
          ),
        ),
        SizedBox(height: height / 25),
        Padding(
          padding: EdgeInsets.only(left: width / 15, right: width / 15),
          child: InkWell(
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
                          content: Center(
                            child: Text(
                                'Длительность видео должен быть не более 15 сек'),
                          ),
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
            },
            child: Container(
              height: height / 15,
              child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage('assets/new_media.png')),
                      SizedBox(width: 5),
                      Text('Загрузить из медиатеки', style: TextStyle(
                          color: Colors.black, fontSize: 17))
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
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InterestsPage())
                );
              },
              child: Container(
                height: height / 15,
                child: Center(child: Text('Далее', style: TextStyle(
                    color: Colors.white.withOpacity(0.9), fontSize: 17))),
              ),
            ),
          ),
        )
      ],
    );
  }
}

