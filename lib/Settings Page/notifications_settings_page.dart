import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/API/uny_app_api.dart';
import 'package:uny_app/Constants/constants.dart';
import 'package:uny_app/Providers/user_data_provider.dart';
import 'package:uny_app/Token%20Data/token_data.dart';

class NotificationsSettingsPage extends StatefulWidget{
  @override
  _NotificationsSettingsPageState createState() => _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {

  bool _showLoading = false;

  late String token;

  late double height;
  late double width;

  bool _isNotificationsDisabled = false;

  bool _chatRequestNotificationsEnabled = false;
  bool _chatsNotificationsEnabled = true;


  @override
  void initState(){

    _isNotificationsDisabled = Provider.of<UserDataProvider>(context, listen: false).userDataModel!.muteNotifications;
    _chatRequestNotificationsEnabled = Provider.of<UserDataProvider>(context, listen: false).userDataModel!.muteMessagesNotifications;
    _chatsNotificationsEnabled = Provider.of<UserDataProvider>(context, listen: false).userDataModel!.muteRequestMessagingNotifications;

    _chatRequestNotificationsEnabled = !_chatsNotificationsEnabled;
    _chatsNotificationsEnabled = !_chatsNotificationsEnabled;

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
              elevation: 0,
              centerTitle: false,
              systemOverlayStyle: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
              backgroundColor: Colors.grey.withOpacity(0),
              title: Text('Уведомления', style: TextStyle(fontSize: 24, color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Colors.grey : Colors.white),
              ),
              actions: [
                _showLoading ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color.fromRGBO(145, 10, 251, 5),
                    ),
                  ),
                ) : TextButton(
                  child: Text('Сохранить', style: TextStyle(color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Color.fromRGBO(145, 10, 251, 5) : Colors.purpleAccent)),
                  onPressed: () async {

                    setState((){
                      _showLoading = true;
                    });

                    var data = {
                      'mute_notifications' : _isNotificationsDisabled.toString(),
                      'mute_request_messaging_notifications' : (!_chatRequestNotificationsEnabled).toString(),
                      'mute_messages_notifications' : (!_chatsNotificationsEnabled).toString(),
                    };

                    await UnyAPI.create(Constants.SIMPLE_RESPONSE_CONVERTER).updateUser(token, data).whenComplete(() async {
                      await UnyAPI.create(Constants.ALL_USER_DATA_MODEL_CONVERTER_CONSTANT).getCurrentUser(token).then((value){
                        Provider.of<UserDataProvider>(context, listen: false).setUserDataModel(value.body!.user);

                        Navigator.pop(context);
                      });
                    });
                  },
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

  Widget mainBody(){
    return Column(
      children: [
        ListTile(
          title: Text('Приостановить уведомления', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          contentPadding: EdgeInsets.symmetric(horizontal: width / 20),
          trailing: Switch.adaptive(
            activeColor: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Color.fromRGBO(145, 10, 251, 5) : Colors.purpleAccent,
            value: _isNotificationsDisabled,
            onChanged: (value) async {

              setState(() {
                _isNotificationsDisabled = value;
              });

            },
          )
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: width / 18),
          child: Divider(
            thickness: 1,
          ),
        ),
        SizedBox(height: height / 50),
        Container(
          padding: EdgeInsets.only(left: width / 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Сообщения', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(
                'Получать уведомления о новых сообщениях и запросах на переписку',
                maxLines: 2,
                style: TextStyle(color: Colors.grey, fontSize: 17),
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text('Запросы на переписку', style: TextStyle(fontSize: 17)),
                contentPadding: EdgeInsets.only(right: 10),
                trailing: Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: _chatRequestNotificationsEnabled,
                    onChanged: (value) {
                      setState((){
                        _chatRequestNotificationsEnabled = !_chatRequestNotificationsEnabled;
                      });
                    },
                    shape: CircleBorder(),
                    checkColor: Colors.white,
                    side: BorderSide(
                      color: Colors.grey,
                    ),
                    splashRadius: UniversalPlatform.isIOS ? 2 : null,
                    activeColor: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Color.fromRGBO(145, 10, 251, 5) : Colors.purpleAccent,
                  ),
                ),
              ),
              ListTile(
                title: Text('Сообщения из чатов', style: TextStyle(fontSize: 17)),
                contentPadding: EdgeInsets.only(right: 10),
                trailing: Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: _chatsNotificationsEnabled,
                    onChanged: (value) {
                      setState((){
                        _chatsNotificationsEnabled = !_chatsNotificationsEnabled;
                      });
                    },
                    shape: CircleBorder(),
                    checkColor: Colors.white,
                    side: BorderSide(
                      color: Colors.grey,
                    ),
                    splashRadius: UniversalPlatform.isIOS ? 2 : null,
                    activeColor: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Color.fromRGBO(145, 10, 251, 5) : Colors.purpleAccent,
                  ),
                ),
              ),
            ],
          )
        ),
      ],
    );
  }
}