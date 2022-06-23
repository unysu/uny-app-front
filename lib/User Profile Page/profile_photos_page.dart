import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/API/uny_app_api.dart';
import 'package:uny_app/Constants/constants.dart';
import 'package:uny_app/Data%20Models/Media%20Data%20Model/media_data_model.dart';
import 'package:uny_app/Providers/user_data_provider.dart';
import 'package:uny_app/Token%20Data/token_data.dart';

class ProfilePhotosPage extends StatefulWidget {

  @override
  _ProfilePhotosPageState createState() => _ProfilePhotosPageState();
}

class _ProfilePhotosPageState extends State<ProfilePhotosPage> {

  late double height;
  late double width;
  
  late String token;

  ImagePicker _picker = ImagePicker();

  File? image;

  List<String>? _imagesList = [];
  List<MediaModel>? _profilePhotos;

  StateSetter? photosState;

  bool _showApplyLoading = false;
  bool _showLoading = false;
  
  
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
            appBar: AppBar(
              automaticallyImplyLeading: true,
              elevation: 0,
              title: Text('Редактировать фото', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
              backgroundColor: Colors.grey.withOpacity(0),
              centerTitle: true,
              leading: Padding(
                padding: EdgeInsets.only(left: 10),
                child:  FittedBox(
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Text('Отмена', style: TextStyle(color: Colors.red, fontSize: 13)),
                  ),
                ),
              ),
              leadingWidth: width / 6,
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
    return StatefulBuilder(
      builder: (context, setState){
        photosState = setState;
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
              child: Stack(
                children: [
                  Consumer<UserDataProvider>(
                    builder: (context, viewModel, child){
                      _profilePhotos = viewModel.mediaDataModel!.mainPhotosList;
                      return ReorderableGridView.count(
                        padding: EdgeInsets.only(top: height / 50, left: width / 20, right: width / 20, bottom: height / 50),
                        childAspectRatio: 20 / 33,
                        crossAxisSpacing: width / 50,
                        mainAxisSpacing: height / 80,
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        children: List.generate(9, (index) {
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
                                    _profilePhotos!.asMap().containsKey(index) ? CachedNetworkImage(
                                      imageUrl: _profilePhotos![index].url,
                                      imageBuilder: (context, imageProvider) => Container(
                                        width: 150,
                                        height: 300,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                        ),
                                      ),
                                    ) : Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.2),
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(color: Colors.transparent
                                          ),
                                        ),
                                        child: !(_profilePhotos!.asMap().containsKey(index)) ? Column(
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
                                    _profilePhotos!.asMap().containsKey(index) ? Positioned(
                                      top: dHeight / 1.2,
                                      left: dWidth / 1.4,
                                      child: IconButton(
                                        alignment: Alignment.center,
                                        icon: Icon(CupertinoIcons.clear_thick_circled,
                                            color: Colors.white, size: dWidth / 4),
                                        onPressed: () async {
                                          var data = {
                                            'media_id' : _profilePhotos![index].id
                                          };

                                          await UnyAPI.create(Constants.SIMPLE_RESPONSE_CONVERTER).deleteMedia(token, data).whenComplete(() async {
                                            await UnyAPI.create(Constants.ALL_USER_DATA_MODEL_CONVERTER_CONSTANT).getCurrentUser(token).then((value){
                                              Provider.of<UserDataProvider>(context, listen: false).setUserDataModel(value.body!.user);
                                              Provider.of<UserDataProvider>(context, listen: false).setMediaDataModel(value.body!.media);
                                            });

                                            _profilePhotos!.removeAt(index);
                                          });

                                          setState(() {});
                                        },
                                      ),
                                    ) : Container(),
                                  ],
                                );
                              },
                            ),
                          );
                        }),
                        onReorder: (oldIndex, newIndex) {

                        },
                      );
                    },
                  ),
                  Center(
                      heightFactor: 8,
                      child: _showLoading ? ClipRRect(
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
                      ) : Container()
                  )
                ],
              )
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
      },
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
                                      cropImage(file!.path);
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
                          cropImage(image!.path);
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
                                      cropImage(file!.path);
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
                          cropImage(image!.path);
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

  void cropImage(String? filePath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath!,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Загрузить фото',
            toolbarColor: Color.fromRGBO(145, 10, 251, 5),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            hideBottomControls: true,
          ),
          IOSUiSettings(
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
        ]
    );

    Navigator.pop(context);

    photosState!((){
      _showLoading = true;
    });

    Uint8List image = File(croppedFile!.path).readAsBytesSync();

    String? mime = lookupMimeType(croppedFile.path);

    var data = {
      'media' : base64Encode(image),
      'mime' : mime,
      'filter' : 'main'
    };
    
    await UnyAPI.create(Constants.SIMPLE_RESPONSE_CONVERTER).uploadMedia(token, data).whenComplete(() async {
      await UnyAPI.create(Constants.ALL_USER_DATA_MODEL_CONVERTER_CONSTANT).getCurrentUser(token).then((value){

        Provider.of<UserDataProvider>(context, listen: false).setUserDataModel(value.body!.user);
        Provider.of<UserDataProvider>(context, listen: false).setMediaDataModel(value.body!.media);

        photosState!(() {
          _showLoading = false;
        });
      });
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