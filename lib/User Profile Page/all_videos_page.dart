import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/API/uny_app_api.dart';
import 'package:uny_app/Constants/constants.dart';
import 'package:uny_app/Providers/user_data_provider.dart';
import 'package:uny_app/Token%20Data/token_data.dart';
import 'package:uny_app/User%20Profile%20Page/video_page.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../Data Models/Media Data Model/media_data_model.dart';

class AllVideosPage extends StatefulWidget{

  @override
  _AllVideosPageState createState() => _AllVideosPageState();
}

class _AllVideosPageState extends State<AllVideosPage> {

  final String _newMediaAsset = 'assets/new_media.svg';
  final ImagePicker _picker = ImagePicker();

  late String token;

  late double height;
  late double width;

  bool _isEditing = false;

  List<MediaModel>? _videos;

  XFile? _video;
  Uint8List? _videoImageBytes;

  @override
  void initState(){
    token = 'Bearer ' + TokenData.getUserToken();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
         return ResponsiveWrapper.builder(
           Scaffold(
               resizeToAvoidBottomInset: false,
               appBar: AppBar(
                 elevation: 0,
                 automaticallyImplyLeading: false,
                 systemOverlayStyle: SystemUiOverlayStyle.dark,
                 backgroundColor: Colors.transparent,
                 centerTitle: false,
                 titleSpacing: 1,
                 title: !_isEditing
                     ? Text('Мои видео', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black))
                     : InkWell(
                     onTap: (){
                       setState(() {
                         _isEditing = false;
                       });
                     },
                     child: Padding(
                       padding: EdgeInsets.only(left: 10),
                       child:  FittedBox(
                         child: InkWell(
                           onTap: (){
                             setState((){
                               _isEditing = false;
                             });
                           },
                           child: Text('Отмена', style: TextStyle(fontSize: 17, color: Colors.grey)),
                         ),
                       ),
                     ),
                 ),
                 leading: !_isEditing ? IconButton(
                   icon: Icon(Icons.arrow_back, color: Colors.grey),
                   onPressed: () => Navigator.pop(context),
                 ) : null,
                 actions: [
                   Padding(
                     padding: EdgeInsets.only(right: 10),
                     child: Center(
                       child: InkWell(
                         onTap: (){
                           if(_isEditing){
                             setState(() {
                               _isEditing = false;
                             });
                           }else{
                             setState(() {
                               _isEditing = true;
                             });
                           }
                         },
                         child: Text(_isEditing ? 'Сохранить' : 'Редактировать', style: TextStyle(fontSize: 17, color: Color.fromRGBO(145, 10, 251, 5))),
                       ),
                     ),
                   )
                 ],
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
      },
    );
  }

  Widget mainBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
              child: Consumer<UserDataProvider>(
                builder: (context, viewModel, child){
                  _videos = viewModel.mediaDataModel!.otherPhotosList!.where((element) => element.type.toString().startsWith('video')).toList();
                  return ReorderableGridView.count(
                    padding: EdgeInsets.only(top: height / 50, left: width / 20, right: width / 20, bottom: height / 50),
                    childAspectRatio: 20 / 33,
                    crossAxisSpacing: width / 40,
                    mainAxisSpacing: height / 80,
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    children: List.generate(_videos!.length, (index) {
                      return LayoutBuilder(
                        key: ValueKey(index),
                        builder: (context, constraints) {
                          double dHeight = constraints.maxHeight;
                          double dWidth = constraints.maxWidth;
                          return Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(11)),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => VideoPage(videoIndex: index))
                                      );
                                    },
                                    child: Container(
                                        height: 500,
                                        child: CachedNetworkImage(
                                          imageUrl: _videos![index].thumbnail,
                                          fit: BoxFit.cover,
                                        )
                                    ),
                                  )
                              ),
                              _isEditing ? Positioned(
                                top: dHeight / 1.2,
                                left: dWidth / 1.4,
                                child: IconButton(
                                  icon: Icon(CupertinoIcons.clear_thick_circled,
                                      color: Colors.white, size: 35),
                                  onPressed: () async {
                                    var data = {
                                      'media_id' : _videos![index].id
                                    };

                                    await UnyAPI.create(Constants.SIMPLE_RESPONSE_CONVERTER).deleteMedia(token, data).whenComplete(() async {
                                      await UnyAPI.create(Constants.ALL_USER_DATA_MODEL_CONVERTER_CONSTANT).getCurrentUser(token).then((value){

                                        Provider.of<UserDataProvider>(context, listen: false).setUserDataModel(value.body!.user);
                                        Provider.of<UserDataProvider>(context, listen: false).setMediaDataModel(value.body!.media);

                                        setState(() {});
                                      });
                                    });
                                  },
                                ),
                              ) : Container(),
                            ],
                          );
                        },
                      );
                    }),
                    onReorder: (oldIndex, newIndex){},
                  );
                },
              )
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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

                String path = _video!.path;

                String? mime = lookupMimeType(path);

                Uint8List videoBytes = File(path).readAsBytesSync();

                String base64Video = base64Encode(videoBytes);

                var data = {
                  'media' : base64Video,
                  'mime' : mime,
                  'filter' : '-'
                };

                await UnyAPI.create(Constants.SIMPLE_RESPONSE_CONVERTER).uploadMedia(token, data).whenComplete(() async {
                  await UnyAPI.create(Constants.ALL_USER_DATA_MODEL_CONVERTER_CONSTANT).getCurrentUser(token).then((value){

                    Provider.of<UserDataProvider>(context, listen: false).setUserDataModel(value.body!.user);
                    Provider.of<UserDataProvider>(context, listen: false).setMediaDataModel(value.body!.media);
                  });
                });

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
            },
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: Container(
                  width: 400,
                  height: 50,
                color: Color.fromRGBO(145, 10, 251, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(_newMediaAsset, color: Colors.white),
                      SizedBox(width: 5),
                      Text('Загрузить новое видео', style: TextStyle(
                          color: Colors.white, fontSize: 17))
                    ],
                  )
              ),
            ),
          )
        )
      ],
    );
  }
}
