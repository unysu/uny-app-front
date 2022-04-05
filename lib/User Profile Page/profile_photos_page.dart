import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_platform/universal_platform.dart';

class ProfilePhotosPage extends StatefulWidget {

  @override
  _ProfilePhotosPageState createState() => _ProfilePhotosPageState();
}

class _ProfilePhotosPageState extends State<ProfilePhotosPage> {

  late double height;
  late double width;

  ImagePicker _picker = ImagePicker();

  File? image;

  List<String?> imagesList = [];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        return ResponsiveWrapper.builder(
            Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
                elevation: 0,
                title: Text('Редактировать фото', style: TextStyle(color: Colors.black)),
                backgroundColor: Colors.grey.withOpacity(0),
                centerTitle: true,
                leading: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child:  FittedBox(
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Text('Отмена', style: TextStyle(fontSize: 17, color: Colors.red)),
                    ),
                  ),
                ),
                leadingWidth: width / 5,
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
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.only(top: height * 0.01),
          child: Text(
            'Удерживайте и перетаскивайте фото для изменения их порядка',
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17.9, color: Colors.grey),
          ),
        ),
        SizedBox(height: 30),
        Container(
          height: height / 1.25,
          child: ReorderableGridView.count(
            padding: EdgeInsets.only(top: height / 50, left: width / 20, right: width / 20, bottom: height / 50),
            childAspectRatio: 20 / 33,
            crossAxisSpacing: width / 50,
            mainAxisSpacing: height / 80,
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: List.generate(10, (index) {
              return GestureDetector (
                key: ValueKey(index),
                onTap: () async {
                  if (UniversalPlatform.isIOS) {
                    var status = await Permission.photos.request();
                    if (status.isGranted) {
                      showBottomSheet();
                    } else if (status.isPermanentlyDenied) {
                      showAlertDialog();
                    }
                  } else if (UniversalPlatform.isAndroid) {
                    var storagePermission = await Permission.storage.request();
                    var photosPermission = await Permission.photos.request();
                    if (storagePermission.isGranted && photosPermission.isGranted) {
                      showBottomSheet();
                    } else {
                      showAlertDialog();
                    }
                  }
                },
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double? dHeight = constraints.maxHeight;
                    double? dWidth = constraints.maxWidth;
                    return Stack(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                              border: Border.all(
                                  color: Colors.transparent
                              ),
                              image: imagesList.asMap().containsKey(index)
                                  ? DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(imagesList[index]!)),
                              )
                                  : null,
                            ),
                            child: !imagesList.asMap().containsKey(index)
                                ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                    CupertinoIcons.add_circled_solid,
                                    color: Colors.grey.withOpacity(0.2)),
                                SizedBox(height: 3),
                                Text('Нажмите для загрузки',
                                    style: TextStyle(fontSize: 15),
                                    textAlign: TextAlign.center)
                              ],
                            ) : null
                        ),
                        imagesList.asMap().containsKey(index) ? Positioned(
                          top: dHeight / 1.2,
                          left: dWidth / 1.4,
                          child: IconButton(
                            alignment: Alignment.center,
                            icon: Icon(CupertinoIcons.clear_thick_circled,
                                color: Colors.white, size: dWidth / 4),
                            onPressed: () {
                              setState(() {
                                imagesList.removeAt(index);
                              });
                            },
                          ),
                        ) : Container(),
                      ],
                    );
                  },
                ),
              );
            }),
            onReorder: (oldIndex, newIndex) {},
          ),
        ),
        Container(
            width: 400,
            height: 48,
            child: Material(
              borderRadius: BorderRadius.circular(11),
              color: Color.fromRGBO(145, 10, 251, 5),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  child: Center(child: Text('Готово', style: TextStyle(
                      color: Colors.white.withOpacity(0.9), fontSize: 17))),
                ),
              ),
            )
        )
      ],
    );
  }

  void showBottomSheet() async {
    try {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
          onlyAll: true, type: RequestType.image);
      List<AssetEntity> media = await albums[0].getAssetListPaged(
          page: 0, size: 60);

      if (UniversalPlatform.isIOS) {
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
                                    media[index].file.then((file) {
                                      _cropImage(file!.path);
                                    });
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
                            'Выбрать из библиотеки',
                            textAlign: TextAlign.center),
                        onPressed: () async {
                          XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          _cropImage(image!.path);
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
      } else if (UniversalPlatform.isAndroid) {
        showModalBottomSheet(
            context: context,
            builder: (context) {
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
                                    media[index].file.then((file) {
                                      _cropImage(file!.path);
                                    });
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
                          XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          _cropImage(image!.path);
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
    } on RangeError catch (_) {
      if (UniversalPlatform.isIOS) {
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
      } else if (UniversalPlatform.isAndroid) {
        Widget _closeButton = TextButton(
            child: const Text(
                'Закрыть',
                style: TextStyle(color: Color.fromRGBO(145, 10, 251, 5))),
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

  void _cropImage(String? filePath) async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath!,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Загрузить фото',
          toolbarColor: Color.fromRGBO(145, 10, 251, 5),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          hideBottomControls: true,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Загрузить фото',
          showCancelConfirmationDialog: true,
          cancelButtonTitle: 'Закрыть',
          doneButtonTitle: 'Сохранить',
          rotateButtonsHidden: true,
          aspectRatioPickerButtonHidden: true,
          rotateClockwiseButtonHidden: true,
          resetButtonHidden: true,
          rectX: 100,
          rectY: 100,
          aspectRatioLockEnabled: false,
        )
    );

    Navigator.pop(context);
    setState(() {
      imagesList.add(croppedFile!.path);
    });
  }

  void showAlertDialog() {
    if (UniversalPlatform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text('Нет доступа к галерии'),
              content: Center(
                child: Text(
                    'Что бы выбрать фото из галерии, предоставьте доступ'),
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
    } else if (UniversalPlatform.isAndroid) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Нет доступа к галерии'),
              content: Center(
                child: Text(
                    'Что бы выбрать фото из галерии, предоставьте доступ'),
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
}