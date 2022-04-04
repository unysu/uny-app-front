import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_platform/universal_platform.dart';

class AllVideosPage extends StatefulWidget{

  @override
  _AllVideosPageState createState() => _AllVideosPageState();
}

class _AllVideosPageState extends State<AllVideosPage> {

  bool _isEditing = false;

  late double height;
  late double width;

  final ImagePicker _picker = ImagePicker();

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
                 title: !_isEditing
                     ? Text('Мои видео', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black))
                     : InkWell(
                     onTap: (){
                       setState(() {
                         _isEditing = false;
                       });
                     },
                     child: Text('Отмена', style: TextStyle(fontSize: 17, color: Colors.grey))),
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
      children: [
        Container(
          height: height / 1.3,
          child: ReorderableGridView.count(
            padding: EdgeInsets.only(top: height / 50, left: width / 20, right: width / 20, bottom: height / 50),
            childAspectRatio: (width / 3) / (height / 4),
            crossAxisSpacing: width / 50,
            mainAxisSpacing: height / 80,
            crossAxisCount: 3,
            shrinkWrap: true,
            children: List.generate(20, (index) {
              return LayoutBuilder(
                key: ValueKey(index),
                builder: (context, constraints) {
                  double dHeight = constraints.maxHeight;
                  double dWidth = constraints.maxWidth;
                  return Stack(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.4),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                                color: Colors.transparent
                            ),
                          ),
                          child: Center(child: Text('Your image here'))
                      ),
                      _isEditing ? Padding(
                        padding: EdgeInsets.only(
                            top: dHeight * 0.820, left: dWidth * 0.740),
                        child: IconButton(
                          icon: Icon(CupertinoIcons.clear_thick_circled,
                              color: Colors.white, size: 30),
                          onPressed: () {
                            setState(() {

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
          )
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: InkWell(
            onTap: () => showBottomSheet(),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: Container(
                height: height / 15,
                color: Color.fromRGBO(145, 10, 251, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage('assets/new_media.png'), color: Colors.white),
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

  void showBottomSheet() async {
    try{
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(onlyAll: true, type: RequestType.video);
      List<AssetEntity> media = await albums[0].getAssetListPaged(page: 0, size: 60);

      if(UniversalPlatform.isIOS){
        showCupertinoModalPopup(
            context: context,
            builder: (context) {
              return CupertinoActionSheet(
                actions: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: media.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {

                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8)),
                                    child: AssetEntityImage(
                                      media[index],
                                      isOriginal: false,
                                      thumbnailFormat: ThumbnailFormat.png,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                              ],
                            );
                          },
                        ),
                      ),
                      CupertinoActionSheetAction(
                        child: Text(
                            'Выбрать из библиотеки', textAlign: TextAlign.center),
                        onPressed: () async {
                          await _picker.pickVideo(source: ImageSource.gallery);
                        },
                      )
                    ],
                  )
                ],
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Отмена'),
                ),
              );
            }
        );
      }else if(UniversalPlatform.isAndroid){
        showModalBottomSheet(
            context: context,
            builder: (context){
              return Wrap(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: media.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {

                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8)),
                                    child: AssetEntityImage(
                                      media[index],
                                      isOriginal: false,
                                      thumbnailFormat: ThumbnailFormat.png,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                              ],
                            );
                          },
                        ),
                      ),
                      ListTile(
                        title: Text('Выбрать из библиотеки'),
                        onTap: () async {
                          XFile? image = await _picker.pickVideo(source: ImageSource.gallery);
                        },
                      ),
                      ListTile(
                          title: Text('Отмена'),
                          onTap: () => Navigator.pop(context)
                      ),
                    ],
                  )
                ],
              );
            }
        );
      }
    }on RangeError catch(_){
      if(UniversalPlatform.isIOS){
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('Нет фото'),
                content: Center(
                  child: Text(
                      'У вас нет фотографий'),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text('Закрыть'),
                    isDestructiveAction: true,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
            }
        );
      }else if(UniversalPlatform.isAndroid){
        Widget _closeButton = TextButton(
            child: const Text(
                'Закрыть', style: TextStyle(color: Color.fromRGBO(145, 10, 251, 5))),
            onPressed: () {
              Navigator.pop(context);
            });

        AlertDialog dialog = AlertDialog(
            title: const Text('Нет фото'),
            content: const Text('У вас нет фотографий'),
            actions: [_closeButton]);

        showDialog(
            context: context,
            builder: (context) {
              return dialog;
            });
      }
    }
  }
}
