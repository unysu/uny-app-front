import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/API/uny_app_api.dart';
import 'package:uny_app/Constants/constants.dart';
import 'package:uny_app/Providers/user_data_provider.dart';
import 'package:uny_app/Providers/video_controller_provider.dart';
import 'package:uny_app/Token%20Data/token_data.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget{

  int? videoId;

  VideoPage({required this.videoId});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage>{

  Map<int, VideoPlayerController>? _videoPlayerControllersMap;

  late String token;

  late double height;
  late double width;

  bool _showIcon = false;
  bool _showLoading = false;

  StateSetter? _videoPageState;

  @override
  void initState(){

    token = 'Bearer ' + TokenData.getUserToken();

    _videoPlayerControllersMap = Provider.of<VideoControllerProvider>(context, listen: false).videoPlayerControllersMap;

    _videoPlayerControllersMap![widget.videoId!]!.play();

    super.initState();
  }

  @override
  void dispose(){

    _videoPlayerControllersMap![widget.videoId!]!.pause();

    _videoPlayerControllersMap = {};

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
                    _videoPlayerControllersMap![widget.videoId!]!.pause();

                    _videoPlayerControllersMap = {};

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
                  _videoPlayerControllersMap![widget.videoId!]!.value.isPlaying
                      ? setState((){
                    _videoPlayerControllersMap![widget.videoId!]!.pause();
                          _showIcon = true;
                       }) : setState((){
                    _videoPlayerControllersMap![widget.videoId!]!.play();
                          _showIcon = false;
                       });
                },
                child: Stack(
                  children: [
                    Container(
                      color: Colors.black,
                      child: mainBody()
                    ),
                    Center(
                        child: AnimatedOpacity(
                          opacity: _showIcon ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 150),
                          child: IconButton(
                              icon: Icon(CupertinoIcons.play_fill, size: 60, color: Colors.white),
                              onPressed: (){
                                _videoPlayerControllersMap![widget.videoId!]!.play();

                                setState((){
                                  _showIcon = false;
                                });
                              }
                          ),
                        )
                    ),
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
    return _videoPlayerControllersMap![widget.videoId!]!.value.isInitialized ? Center(
      child: StatefulBuilder(
        builder: (context, setState){
          _videoPageState = setState;
          return Stack(
            children: [
              Center(
                child: Container(
                  child: AspectRatio(
                    aspectRatio: _videoPlayerControllersMap![widget.videoId!]!.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerControllersMap![widget.videoId!]!),
                  ),
                ),
              ),
              _showLoading ? Center(
                child: ClipRRect(
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
                ),
              ) : Container()
            ],
          );
        },
      )
    ) : Container();
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
                  onPressed: () async {
                    _videoPageState!((){
                      _showLoading = true;
                    });

                    var data = {
                      'media_id' : widget.videoId
                    };

                    await UnyAPI.create(Constants.SIMPLE_RESPONSE_CONVERTER).deleteMedia(token, data).whenComplete(() async {
                      await UnyAPI.create(Constants.ALL_USER_DATA_MODEL_CONVERTER_CONSTANT).getCurrentUser(token).then((value){

                        Provider.of<UserDataProvider>(context, listen: false).setMediaDataModel(value.body!.media);

                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    });
                  },
                  isDestructiveAction: true,
                  child: Text('Удалить видео'),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.pop(context),
                child: Text('Отмена', style: TextStyle(color: Colors.lightBlue)),
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
                  onPressed: () async {

                    _videoPageState!((){
                      _showLoading = true;
                    });

                    var data = {
                      'media_id' : widget.videoId
                    };

                    await UnyAPI.create(Constants.SIMPLE_RESPONSE_CONVERTER).deleteMedia(token, data).whenComplete(() async {
                      await UnyAPI.create(Constants.ALL_USER_DATA_MODEL_CONVERTER_CONSTANT).getCurrentUser(token).then((value){

                        Provider.of<UserDataProvider>(context, listen: false).setMediaDataModel(value.body!.media);

                        Navigator.pop(context);
                      });
                    });
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
