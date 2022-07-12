import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/API/uny_app_api.dart';
import 'package:uny_app/Constants/constants.dart';
import 'package:uny_app/Providers/user_data_provider.dart';
import 'package:uny_app/Token%20Data/token_data.dart';

class PrivacySettingsPage extends StatefulWidget {

  @override
  _PrivacySettingsState createState() => _PrivacySettingsState();
}

class _PrivacySettingsState extends State<PrivacySettingsPage>{

  late String token;

  late double height;
  late double width;

  bool _toAllUsers = false;
  bool _onlyMen = false;
  bool _onlyWomen = false;
  bool _other = false;

  bool _showLoading = false;

  @override
  void initState(){

    String? privacy = Provider.of<UserDataProvider>(context, listen: false).userDataModel!.whoCanSee;

   if(privacy == null){
     _toAllUsers = true;
   }else{
     switch(privacy){
       case 'male':
         _onlyMen = true;
         break;
       case 'female':
         _onlyWomen = true;
         break;
       case 'male-female':
         _onlyMen = true;
         _onlyWomen = true;
         break;
       case 'male-other':
         _onlyMen = true;
         _other = true;
         break;
       case 'female-other':
         _onlyWomen = true;
         _other = true;
         break;
       case 'other':
         _other = true;
         break;

     }
   }

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
              backgroundColor: Colors.grey.withOpacity(0),
              title: Text('Приватность', style: TextStyle(fontSize: 24, color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: Colors.grey),
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
                  child: Text('Сохранить', style: TextStyle(color: Color.fromRGBO(145, 10, 251, 5))),
                  onPressed: () async {
                    setState((){
                      _showLoading = true;
                    });

                    late Map<String, String?> data;

                    if(_toAllUsers){
                      data = {
                        'who_can_see' : null
                      };
                    }else if(_onlyMen && _onlyWomen){
                      data = {
                        'who_can_see' : 'male-female'
                      };
                    }else if(_onlyMen && _other){
                      data = {
                        'who_can_see' : 'male-other'
                      };
                    }else if(_onlyWomen && _other){
                      data = {
                        'who_can_see' : 'female-other'
                      };
                    } else if(_onlyMen){
                      data = {
                        'who_can_see' : 'male'
                      };
                    }else if(_onlyWomen){
                      data = {
                        'who_can_see' : 'female'
                      };
                    }

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
    return Container(
      padding: EdgeInsets.symmetric(vertical: height / 30, horizontal: width / 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Кому видна моя страница?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          SizedBox(height: height / 50),
          ListTile(
            title: Text('Всем пользователям', style: TextStyle(fontSize: 17)),
            contentPadding: EdgeInsets.only(left: 0),
            trailing: Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: _toAllUsers,
                onChanged: (value) async {
                  setState((){
                    _toAllUsers = value!;

                    _onlyMen = false;
                    _onlyWomen = false;
                    _other = false;
                  });

                  var data = {
                    'who_can_see' : null
                  };

                  await UnyAPI.create(Constants.SIMPLE_RESPONSE_CONVERTER).updateUser(token, data);
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
                onChanged: (value) async {
                  setState((){
                    _onlyMen = value!;

                    _toAllUsers = false;
                  });

                  if(_onlyMen && _onlyWomen && _other){
                    setState((){
                      _toAllUsers = true;

                      _onlyMen = false;
                      _onlyWomen = false;
                      _other = false;
                    });
                  }
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

                    _toAllUsers = false;
                  });

                  if(_onlyMen && _onlyWomen && _other){
                    setState((){
                      _toAllUsers = true;

                      _onlyMen = false;
                      _onlyWomen = false;
                      _other = false;
                    });
                  }
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

                    _toAllUsers = false;
                  });

                  if(_onlyMen && _onlyWomen && _other){
                    setState((){
                      _toAllUsers = true;

                      _onlyMen = false;
                      _onlyWomen = false;
                      _other = false;
                    });
                  }
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