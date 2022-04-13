import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_platform/universal_platform.dart';

class PrivacySettingsPage extends StatefulWidget {

  @override
  _PrivacySettingsState createState() => _PrivacySettingsState();
}

class _PrivacySettingsState extends State<PrivacySettingsPage>{

  late double height;
  late double width;

  bool _toAllUsers = false;
  bool _onlyMen = false;
  bool _onlyWomen = false;
  bool _other = false;

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
              title: Text('Приватность', style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold)),
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: height / 30, horizontal: width / 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Кому видна моя страница?', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)),
          SizedBox(height: height / 50),
          ListTile(
            title: Text('Всем пользователям', style: TextStyle(fontSize: 17)),
            contentPadding: EdgeInsets.only(left: 0),
            trailing: Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: _toAllUsers,
                onChanged: (value) {
                  setState((){
                    _toAllUsers = value!;
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
            title: Text('Мужчинам', style: TextStyle(fontSize: 17)),
            contentPadding: EdgeInsets.only(left: 0),
            trailing: Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: _onlyMen,
                onChanged: (value) {
                  setState((){
                    _onlyMen = value!;
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
            title: Text('Женщинам', style: TextStyle(fontSize: 17)),
            contentPadding: EdgeInsets.only(left: 0),
            trailing: Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: _onlyWomen,
                onChanged: (value) {
                  setState((){
                    _onlyWomen = value!;
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
            title: Text('Другое', style: TextStyle(fontSize: 17)),
            contentPadding: EdgeInsets.only(left: 0),
            trailing: Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: _other,
                onChanged: (value) {
                  setState((){
                    _other = value!;
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
          )
        ],
      ),
    );
  }
}