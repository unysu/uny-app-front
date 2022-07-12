import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:video_player/video_player.dart';

class OtherUsersVideoPlayer extends StatefulWidget{

  late String videoUrl;

  OtherUsersVideoPlayer({required this.videoUrl});

  @override
  _OtherUsersVideoPlayerState createState() => _OtherUsersVideoPlayerState();
}


class _OtherUsersVideoPlayerState extends State<OtherUsersVideoPlayer>{

  late double height;
  late double width;

  late VideoPlayerController _videoPlayerController;
  late Future<void> _videoPlayerFuture;

  late StateSetter _videoState;

  bool _showPlayIcon = false;

  @override
  void initState() {

    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);

    _videoPlayerFuture = _videoPlayerController.initialize();

    super.initState();
  }

  @override
  void dispose(){
    _videoPlayerController.dispose();
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
              backgroundColor: Colors.black,
              appBar: AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                systemOverlayStyle: SystemUiOverlayStyle.light,
                backgroundColor: Colors.transparent,
                title: Text('Видеозапись', style: TextStyle(fontSize: 17, color: Colors.white)),
                leading: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
              body: Stack(
                children: [
                  Container(
                      color: Colors.black,
                      child: FutureBuilder(
                        future: _videoPlayerFuture,
                        builder: (context, snapshot){
                          while(snapshot.connectionState == ConnectionState.waiting){
                            return Center(
                              heightFactor: 25,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Color.fromRGBO(145, 10, 251, 5),
                              ),
                            );
                          }

                          if(snapshot.connectionState == ConnectionState.done){

                            _videoPlayerController.setLooping(true);
                            _videoPlayerController.play();

                            return mainBody();
                          }else{
                            return Center(
                              child: Text('Error'),
                            );
                          }
                        },
                      )
                  ),
                  Center(
                      child: AnimatedOpacity(
                        opacity: _showPlayIcon ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 150),
                        child: IconButton(
                            icon: Icon(CupertinoIcons.play_fill, size: 60, color: Colors.white),
                            onPressed: (){
                              _videoPlayerController.play();

                              _videoState((){
                                _showPlayIcon = false;
                              });
                            }
                        ),
                      )
                  ),
                ],
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
    return GestureDetector(
        onTap: (){
          if(_videoPlayerController.value.isPlaying){
            _videoState((){
              _videoPlayerController.pause();
              _showPlayIcon = true;
            });
          }else{
            _videoState((){
              _videoPlayerController.play();
              _showPlayIcon = false;
            });
          }
        },
        child: StatefulBuilder(
          builder: (context, setState){
            _videoState = setState;
            return Center(
                child: Stack(
                  children: [
                    Center(
                      child: SizedBox.expand(
                          child: AspectRatio(
                            aspectRatio: _videoPlayerController.value.aspectRatio,
                            child: VideoPlayer(_videoPlayerController),
                          )
                      ),
                    ),
                    Center(
                        child: AnimatedOpacity(
                          opacity: _showPlayIcon ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 150),
                          child: IconButton(
                              icon: Icon(CupertinoIcons.play_fill, size: 60, color: Colors.white),
                              onPressed: (){
                                _videoPlayerController.play();

                                setState((){
                                  _showPlayIcon = false;
                                });
                              }
                          ),
                        )
                    ),
                  ],
                )
            );
          },
        )
    );
  }
}

