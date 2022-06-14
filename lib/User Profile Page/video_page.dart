import 'dart:convert';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/Providers/video_controller_provider.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget{

  int? videoIndex;

  VideoPage({required this.videoIndex});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage>{

  late double height;
  late double width;

  bool _showIcon = false;

  List<VideoPlayerController>? _videoPlayerControllersList;

  @override
  void initState(){

    _videoPlayerControllersList = Provider.of<VideoControllerProvider>(context, listen: false).videoPlayerControllersList;

    _videoPlayerControllersList![widget.videoIndex!].play();

    super.initState();
  }

  @override
  void dispose(){

    _videoPlayerControllersList = [];

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
                systemOverlayStyle: SystemUiOverlayStyle.light,
                backgroundColor: Colors.transparent,
                title: Text('Видеозапись', style: TextStyle(fontSize: 17, color: Colors.white)),
                leading: IconButton(
                  onPressed: (){
                    _videoPlayerControllersList = [];

                    _videoPlayerControllersList![widget.videoIndex!].dispose();

                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                ),
                actions: [
                  Center(
                    child: IconButton(
                      icon: Icon(CupertinoIcons.delete),
                      onPressed: () => showDeleteVideoDialog()
                    ),
                  )
                ],
              ),
              body: GestureDetector(
                onTap: (){
                  _videoPlayerControllersList![widget.videoIndex!].value.isPlaying
                      ? setState((){
                          _videoPlayerControllersList![widget.videoIndex!].pause();
                          _showIcon = true;
                       }) : setState((){
                          _videoPlayerControllersList![widget.videoIndex!].play();
                          _showIcon = false;
                       });
                },
                child: Stack(
                  children: [
                    mainBody(),
                    Center(
                        child: AnimatedOpacity(
                          opacity: _showIcon ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 150),
                          child: IconButton(
                              icon: Icon(CupertinoIcons.play_fill, size: 60, color: Colors.white),
                              onPressed: (){
                                _videoPlayerControllersList![widget.videoIndex!].play();

                                setState((){
                                  _showIcon = false;
                                });
                              }
                          ),
                        )
                    )
                  ],
                )
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
    return SizedBox.expand(
      child: _videoPlayerControllersList![widget.videoIndex!].value.isInitialized ? AspectRatio(
        aspectRatio: 1,
        child: VideoPlayer(_videoPlayerControllersList![widget.videoIndex!]),
      ) : Container(),
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
