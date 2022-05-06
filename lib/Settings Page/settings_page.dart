import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/Authorization%20Pages/authorization_page.dart';
import 'package:uny_app/Settings%20Page/blocked_users_settings_page.dart';
import 'package:uny_app/Settings%20Page/edit_profile_page.dart';
import 'package:uny_app/Settings%20Page/notifications_settings_page.dart';
import 'package:uny_app/Settings%20Page/privacy_settings_page.dart';
import 'package:uny_app/Settings%20Page/support_settings_page.dart';
import 'package:uny_app/User%20Profile%20Page/profile_photos_page.dart';

class SettingsPage extends StatefulWidget{

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>{

  late double height;
  late double width;

  final String _privacyAsset = 'assets/privacy.svg';
  final String _notificationAsset = 'assets/notification.svg';
  final String _assistanceAsset = 'assets/assistance.svg';
  final String _logoutAsset  = 'assets/logout.svg';
  final String _rearrangeAsset = 'assets/rearrange.svg';
  final String _newMediaImageAsset = 'assets/new_media.svg';
  final String _noPhotoPlaceholder = 'assets/removed_avatar_pic.svg';

  final ImagePicker _picker = ImagePicker();

  File? _image;


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        return ResponsiveWrapper.builder(
          Scaffold(
              resizeToAvoidBottomInset: false,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
              ),
              body: mainBody()
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
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: height * 0.1),
          child: Text('Настройки', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: width / 20),
        Container(
          child: Stack(
            children: [
              GestureDetector(
                child: Container(
                  height: height / 5,
                  child: Center(
                    child: _image == null
                    ? SvgPicture.asset(_noPhotoPlaceholder, height: 50, width: 50)
                    : null
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.2),
                    image: _image != null ? DecorationImage(
                      image: FileImage(_image!)
                    ) : null
                  ),
                ),
                onTap: (){
                  if(UniversalPlatform.isIOS){
                    showCupertinoModalPopup(
                        context: context,
                        builder: (context){
                          return showPicOptions();
                        }
                    );
                  }else if(UniversalPlatform.isAndroid){
                    showModalBottomSheet(
                        context: context,
                        builder: (context){
                          return showPicOptions();
                        }
                    );
                  }
                },
              ),
              Positioned(
                  top: height / 6.3,
                  left: width * 0.59,
                  child: InkWell(
                    onTap: () {
                      if(UniversalPlatform.isIOS){
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context){
                              return showPicOptions();
                            }
                        );
                      }else if(UniversalPlatform.isAndroid){
                        showModalBottomSheet(
                            context: context,
                            builder: (context){
                              return showPicOptions();
                            }
                        );
                      }
                    },
                    child: Container(
                      child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: height / 30
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                    ),
                  )
              )
            ],
          ),
        ),
        SizedBox(height: 5),
        Text('Кристина З. 23 🇷🇺', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        Text('+7 (712) 654-46-12', style: TextStyle(fontSize: 13, color: Colors.grey)),
        SizedBox(height: height / 40),
        InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfilePage()
              )
            );
          },
          child: Container(
            height: height / 18,
            width: width * 0.9,
            child: Center(
                child: Text('Редактировать профиль', style: TextStyle(
                    color: Colors.black, fontSize: 17))
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    color: Colors.grey,
                    width: 0.5
                )
            ),
          ),
        ),
        SizedBox(height: 10),
        ListTile(
          contentPadding: EdgeInsets.only(left: width / 20, right: width / 20),
          title: Text('Приватность', style: TextStyle(fontSize: 17, color: Colors.black)),
          leading: SvgPicture.asset(_privacyAsset),
          trailing: Icon(CupertinoIcons.forward),
          minLeadingWidth: 2,
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PrivacySettingsPage())
            );
          }
        ),
        ListTile(
          contentPadding: EdgeInsets.only(left: width / 21, right: width / 20),
          title: Text('Уведомления', style: TextStyle(fontSize: 17, color: Colors.black)),
          leading: SvgPicture.asset(_notificationAsset),
          trailing: Icon(CupertinoIcons.forward),
          minLeadingWidth: 2,
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationsSettingsPage())
              );
            }
        ),
        ListTile(
          contentPadding: EdgeInsets.only(left: width / 23, right: width / 20),
          title: Text('Черный список', style: TextStyle(fontSize: 17, color: Colors.black)),
          trailing: Icon(CupertinoIcons.forward),
          leading: Icon(Icons.block_flipped, color: Color.fromRGBO(145, 10, 251, 5)),
          minLeadingWidth: 2,
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BlockedUsersSettingsPage())
              );
            }
        ),
        ListTile(
          contentPadding: EdgeInsets.only(left: width / 20, right: width / 20),
          title: Text('Техподдержка', style: TextStyle(fontSize: 17, color: Colors.black)),
          leading: SvgPicture.asset(_assistanceAsset, color: Color.fromRGBO(145, 10, 251, 5)),
          trailing: Icon(CupertinoIcons.forward),
          minLeadingWidth: 2,
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupportPage())
              );
            }
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Divider(
            thickness: 1,
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.only(left: width / 20, right: width / 20),
          title: Text('Выйти', style: TextStyle(fontSize: 17, color: Colors.red)),
          leading: SvgPicture.asset(_logoutAsset, color: Colors.red),
          trailing: Icon(CupertinoIcons.forward),
          minLeadingWidth: 2,
          onTap: () => _showSignOutDialog(),
        ),
      ],
    );
  }


  Widget showPicOptions() {
    return Material(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
      child: Container(
        height: height * 0.35,
        padding: EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35), topRight: Radius.circular(35)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: width / 8),
                  Text('Фото профиля', style:
                  TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(CupertinoIcons.clear_thick_circled),
                    color: Colors.grey.withOpacity(0.5),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),
            ListTile(
                title: Text('Удалить текущее фото'),
                leading: Icon(CupertinoIcons.delete),
                trailing: Icon(Icons.arrow_forward_ios_rounded, size: 20),
                onTap: () {

                }
            ),
            ListTile(
                title: Text('Изменить порядок фотографий'),
                leading: SvgPicture.asset(_rearrangeAsset),
                trailing: Icon(Icons.arrow_forward_ios_rounded, size: 20),
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePhotosPage()
                      )
                  );
                }
            ),
            ListTile(
              title: Text('Загрузить из медиатеки'),
              leading: SvgPicture.asset(_newMediaImageAsset, color: Colors.grey),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 20),
              onTap: () async {
                XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                _cropImage(image!.path);
              },
            ),
          ],
        ),
      ),
    );
  }


  void _showSignOutDialog() {
    if(UniversalPlatform.isIOS){
      showCupertinoModalPopup(
        context: context,
        builder: (context){
          return CupertinoActionSheet(
            title: Text(
              'Вы уверены, что хотите выйти? Вам придется заново ввести данные для входа.',
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => AuthorizationPage()),
                        (Route<dynamic> route) => false,
                  );
                },
                isDestructiveAction: true,
                child: Text('Выйти из аккаунта'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context),
              child: Text('Отмена'),
            ),
          );
        }
      );
    }else if(UniversalPlatform.isAndroid){
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text(
              'Вы уверены, что хотите выйти?',
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => AuthorizationPage()),
                        (Route<dynamic> route) => false,
                  );
                },
                child: Text('Выйти из аккаунта', style: TextStyle(color: Colors.red)),
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
      _image = croppedFile;
    });
  }
}