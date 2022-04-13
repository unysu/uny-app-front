import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_platform/universal_platform.dart';

class NotificationsSettingsPage extends StatefulWidget{
  @override
  _NotificationsSettingsPageState createState() => _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {

  late double height;
  late double width;

  bool _isNotificationsDisabled = false;

  bool _chatRequestNotificationsEnabled = false;
  bool _chatsNotificationsEnabled = true;

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
              backgroundColor: Colors.grey.withOpacity(0),
              title: Text('Уведомления', style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold)),
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: Colors.grey),
              ),
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
          trailing: UniversalPlatform.isIOS ? CupertinoSwitch(
            activeColor: Color.fromRGBO(145, 10, 251, 5),
            value: _isNotificationsDisabled,
            onChanged: (value){
              setState(() {
                _isNotificationsDisabled = value;
              });
            },
          ) : Switch(
            activeColor: Color.fromRGBO(145, 10, 251, 5),
            value: _isNotificationsDisabled,
            onChanged: (value){
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
              Text('Сообщения', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)),
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
                        _chatRequestNotificationsEnabled = value!;
                      });
                    },
                    shape: CircleBorder(),
                    checkColor: Colors.white,
                    side: BorderSide(
                      color: Colors.grey,
                    ),
                    splashRadius: UniversalPlatform.isIOS ? 2 : null,
                    activeColor: Color.fromRGBO(145, 10, 251, 5),
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
                        _chatsNotificationsEnabled = value!;
                      });
                    },
                    shape: CircleBorder(),
                    checkColor: Colors.white,
                    side: BorderSide(
                      color: Colors.grey,
                    ),
                    splashRadius: UniversalPlatform.isIOS ? 2 : null,
                    activeColor: Color.fromRGBO(145, 10, 251, 5),
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