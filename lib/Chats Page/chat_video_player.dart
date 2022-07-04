import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChatVideoPlayer extends StatefulWidget{

  String? url;

  ChatVideoPlayer({required this.url});

  @override
  _ChatVideoPlayerState createState() => _ChatVideoPlayerState();
}

class _ChatVideoPlayerState extends State<ChatVideoPlayer>{

  late VideoPlayerController _videoPlayerController;
  late Future<void> _videoFuture;

  late StateSetter videoState;

  bool showIcon = false;

  @override
  void initState() {

    _videoPlayerController = VideoPlayerController.network(widget.url!, videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false));
    _videoFuture = _videoPlayerController.initialize();

    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Hero(
        tag: widget.url!,
        child: loadVideo(),
      )
    );
  }


  FutureBuilder loadVideo(){
    return FutureBuilder(
      future: _videoFuture,
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

          return GestureDetector(
              onTap: (){
                if(_videoPlayerController.value.isPlaying){
                  videoState((){
                    _videoPlayerController.pause();
                    showIcon = true;
                  });
                }else{
                  videoState((){
                    _videoPlayerController.play();
                    showIcon = false;
                  });
                }
              },
              child: StatefulBuilder(
                builder: (context, setState){
                  videoState = setState;
                  return Center(
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              child: AspectRatio(
                                aspectRatio: _videoPlayerController.value.aspectRatio,
                                child: VideoPlayer(_videoPlayerController),
                              ),
                            ),
                          ),
                          Center(
                              child: AnimatedOpacity(
                                opacity: showIcon ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 150),
                                child: IconButton(
                                    icon: Icon(CupertinoIcons.play_fill, size: 60, color: Colors.white),
                                    onPressed: (){
                                      _videoPlayerController.play();

                                      setState((){
                                        showIcon = false;
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
        }else{
          return Center(
            child: Text('Error'),
          );
        }
      },
    );
  }
}