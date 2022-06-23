import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

import '../Data Models/Media Data Model/media_data_model.dart';

class VideoControllerProvider extends ChangeNotifier{

  List<MediaModel>? _videos = [];

  Map<int, VideoPlayerController>? _videoPlayerControllersMap = {};

  Map<int, VideoPlayerController>? get videoPlayerControllersMap => _videoPlayerControllersMap;

  void setMediaModel(List<MediaModel>? videos) async {
    if(this._videos!.isNotEmpty){
      _videos!.clear();
    }


    if(videos!.isNotEmpty){
      this._videos = videos.where((element) => element.type.toString().startsWith('video')).toList();

      Map<int, VideoPlayerController>? other;

      for(int i = 0; i < _videos!.length; i++){
        VideoPlayerController? _videoController;

        other = Map();

        _videoController = VideoPlayerController.network(_videos![i].url)..initialize().then((_){
          _videoController!.setLooping(true);

          other!.addAll({
            _videos![i].id : _videoController
          });

          _videoPlayerControllersMap!.addAll(other);
        });
      }
    }
  }
}