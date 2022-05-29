import 'dart:convert';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget{

  List<String>? base64Videos;
  int? videoIndex;

  VideoPage({required this.base64Videos, required this.videoIndex});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage>{

  late double height;
  late double width;

  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  Future<VideoPlayerController>? _futureController;

  Future<VideoPlayerController> createVideoPlayer() async {
    final File file = File.fromRawPath(base64Decode(widget.base64Videos![widget.videoIndex!]));
    final VideoPlayerController controller = VideoPlayerController.file(file);
    await controller.initialize();
    await controller.setLooping(true);

    return controller;
  }

  @override
  void initState(){

    print('hahahha');
    _futureController = createVideoPlayer();

    super.initState();
  }

  @override
  void dispose(){

    _videoPlayerController.dispose();
    _chewieController.dispose();

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
                title: Text('Видеозапись', style: TextStyle(fontSize: 17, color: Colors.white)),
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                ),
                actions: [
                  Center(
                    child: IconButton(
                      icon: Icon(CupertinoIcons.delete),
                      onPressed: () => showDeleteVideoDialog(),
                    ),
                  )
                ],
              ),
              body: initVideoFutureBuilder()
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

  FutureBuilder initVideoFutureBuilder(){
    return FutureBuilder(
      future: _futureController,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          _videoPlayerController = snapshot.data as VideoPlayerController;

          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            allowedScreenSleep: false,

            autoPlay: true,
          );

          return mainBody();
        }else{
          return Center(
            child: Text('Error while loading video'),
          );
        }
      },
    );
  }

  Widget mainBody(){
    return SizedBox.expand(
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  void showDeleteVideoDialog() {
    if(UniversalPlatform.isIOS){
      showCupertinoModalPopup(
          context: context,
          builder: (context){
            return CupertinoActionSheet(
              title: Text.rich(
                TextSpan(
                    text: 'Вы уверены, что хотите удалить видео? ',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    children: [
                      TextSpan(
                        text: '   Это действие невозможно отменить.',
                        style: TextStyle(color: Colors.red, fontSize: 15),
                      ),
                    ]
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () {

                  },
                  isDestructiveAction: true,
                  child: Text('Удалить видео'),
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
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text.rich(
                TextSpan(
                    text: 'Вы уверены, что хотите удалить видео? ',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    children: [
                      TextSpan(
                        text: 'Это действие невозможно отменить.',
                        style: TextStyle(color: Colors.red, fontSize: 15),
                      ),
                    ]
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              actions: [
                TextButton(
                  onPressed: () {

                  },
                  child: Text('Удалить видео', style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Отмена', style: TextStyle(color: Color.fromRGBO(145, 10, 251, 5))),
                ),
              ],
            );
          }
      );
    }
  }

}
