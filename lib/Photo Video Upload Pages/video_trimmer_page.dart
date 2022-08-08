import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_trimmer/video_trimmer.dart';

class TrimmerView extends StatefulWidget {
  final String path;

  const TrimmerView(this.path);

  @override
  _TrimmerViewState createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: File(widget.path));
  }

  @override
  void initState() {
    super.initState();

    _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _trimmer.saveTrimmedVideo(startValue: _startValue, endValue: _endValue, onSave: (String? outputPath) {
                Navigator.pop(context, outputPath);
              });
            },
            style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
            ),
            child: Text('Сохранить', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Builder(
        builder: (context) => Center(
          child: GestureDetector(
            onTap: () async {
              bool playbackState = await _trimmer.videPlaybackControl(
                startValue: _startValue,
                endValue: _endValue,
              );
              setState(() {
                _isPlaying = playbackState;
              });
            },
            child: Container(
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                      child: Stack(
                        children: [
                          VideoViewer(trimmer: _trimmer),
                          Center(
                            child: GestureDetector(
                                onTap: () async {
                                  bool playbackState = await _trimmer.videPlaybackControl(
                                    startValue: _startValue,
                                    endValue: _endValue,
                                  );
                                  setState(() {
                                    _isPlaying = playbackState;
                                  });
                                },
                                child: AnimatedOpacity(
                                  opacity: _isPlaying ? 0 : 1,
                                  duration: Duration(milliseconds: 150),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    child: Center(
                                      child: Icon(CupertinoIcons.play_arrow_solid, color: Colors.white),
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        shape: BoxShape.circle
                                    ),
                                  ),
                                )
                            ),
                          )
                        ],
                      )
                  ),
                  TrimEditor(
                    trimmer: _trimmer,
                    viewerHeight: 50.0,
                    viewerWidth: MediaQuery.of(context).size.width / 1.1,
                    onChangeStart: (value) {
                      _startValue = value;
                    },
                    onChangeEnd: (value) {
                      _endValue = value;
                    },
                    onChangePlaybackState: (value) {
                      setState(() {
                        _isPlaying = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}