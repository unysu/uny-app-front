import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_platform/universal_platform.dart';

class UploadPhotoPage extends StatefulWidget{

  @override
  _UploadPhotoPageState createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> with DragFeedback, DragPlaceHolder, DragCompletion{

  late double height;
  late double width;

  bool? isNextButtonEnabled;


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        isNextButtonEnabled = false;
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        return ResponsiveWrapper.builder(
          Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
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
              const ResponsiveBreakpoint.resize(480, name: 'MOBILE')
            ]
        );
      }
    );
  }


  Widget mainBody(){
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: height / 8, left: width / 10, right: width / 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Загрузи своё фото',
                    style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                SizedBox(
                  width: width,
                  height: 50,
                  child: Text(
                    'Удерживайте и перетаскивайте фото для изменения их порядка',
                    maxLines: 2,
                    style: TextStyle(fontSize: 17, color: Colors.grey),
                  ),
                )
              ],
            ),
          ),
          Container(
            child: DraggableGridViewBuilder(
              padding: EdgeInsets.only(top: height / 50, left: width / 20, right: width / 20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  crossAxisCount: 3,
                  childAspectRatio: (width / 3) / (height / 4),
                ),
                dragCompletion: this,
                dragFeedback: this,
                dragPlaceHolder: this,
                shrinkWrap: true,
                isOnlyLongPress: true,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(9, (index) {
                  return DraggableGridItem(
                      child: GestureDetector(
                        onTap: () async {
                          var status = await Permission.photos.request();
                          if(status.isGranted) {
                             showBottomSheet();
                          }else if(status.isPermanentlyDenied){
                            showAlertDialog();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: index != 0 ? Colors.grey.withOpacity(0.2) : Colors.orange.withOpacity(0.4),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                                color: index == 0 ? Colors.orange.withOpacity(0.4) : Colors.transparent
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                  CupertinoIcons.add_circled_solid,
                                  color: index != 0 ? Colors.grey.withOpacity(0.2) : Colors.orange.withOpacity(0.9)),
                              SizedBox(height: 3),
                              Text(
                                  index != 0 ? 'Нажмите для загрузки' : 'Фотография профиля',
                                  style: TextStyle(fontSize: 15),
                                  textAlign: TextAlign.center)
                            ],
                          ),
                        ),
                      )
                  );
                },
                )
            ),
          ),
          SizedBox(height: 15),
          Container(
            width: 215,
            height: 48,
            child: Material(
              borderRadius: BorderRadius.circular(11),
              color: isNextButtonEnabled! ?  Color.fromRGBO(145, 10, 251, 5) : Colors.grey.withOpacity(0.5),
              child: InkWell(
                onTap: isNextButtonEnabled! ? null : () {

                },
                child: SizedBox(
                  height: height * 0.06,
                  child: Center(child: Text('Готово', style: TextStyle(color: isNextButtonEnabled! ? Colors.white : Colors.white.withOpacity(0.9), fontSize: 17))),
                ),
              ),
            )
          )
        ],
      ),
    );
  }

  void showBottomSheet() async {
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(onlyAll: true);
    List<AssetEntity> media = await albums[0].getAssetListPaged(page: 0, size: 60);

    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet (
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: media.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index){
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              File? file;
                              await media[index].file.then((value) => file = value);
                              openImageCropper(file);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              child: AssetEntityImage(
                                media[index],
                                isOriginal: false,
                                thumbnailFormat: ThumbnailFormat.png,
                                height: 100,
                                width: 80,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                        ],
                      );
                    },
                  ),
                ),
                CupertinoActionSheetAction(
                    onPressed: () => null,
                    child: Text('Выбрать из библиотеки', textAlign: TextAlign.center)
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
  }

  void openImageCropper(File? file) async {
    File? croppedImage = await ImageCropper().cropImage(
      sourcePath: file!.path,
      maxWidth: 1080,
      maxHeight: 1080,
    );
  }

  void showAlertDialog(){
    if(UniversalPlatform.isIOS){
      showCupertinoDialog(
          context: context,
          builder: (context){
            return CupertinoAlertDialog(
              title: Text('Нет доступа к галерии'),
              content: Center(
                child: Text('Что бы выбрать фото из галерии, предоставьте доступ.'),
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text('Закрыть'),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoDialogAction(
                  child: Text('Настройки'),
                  onPressed: () => openAppSettings(),
                )
              ],
            );
          }
      );
    }else if(UniversalPlatform.isAndroid){
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Нет доступа к галерии'),
            content: Center(
              child: Text('Что бы выбрать фото из галерии, предоставьте доступ.'),
            ),
            actions: [
              FloatingActionButton.extended(
                label: Text('Закрыть'),
                backgroundColor: Colors.red,
                onPressed: () => Navigator.pop(context),
              ),
              FloatingActionButton.extended(
                label: Text('Настройки'),
                backgroundColor: Color.fromRGBO(145, 10, 251, 5),
                onPressed: () => openAppSettings(),
              )
            ],
          );
        }
      );
    }
  }

  @override
  void onDragAccept(List<DraggableGridItem> list) {
    // TODO: implement onDragAccept
  }

  @override
  PlaceHolderWidget placeHolder(List<DraggableGridItem> list, int index) {
    return PlaceHolderWidget(
      child: DottedBorder(
        color: Colors.grey.withOpacity(0.5),
        strokeWidth: 1,
        child: Container(
          child: Center(
            child: Image.asset('assets/placeholder_image.png'),
          ),
        ),
      )
    );
  }

  @override
  Widget feedback(List<DraggableGridItem> list, int index) {
    var item = list[index] as Container;
    return Container(
      child: item.child,
      width: 183,
      height: 203,
    );
  }
}