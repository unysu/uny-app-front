import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uny_app/API/uny_app_api.dart';
import 'package:uny_app/Authorization%20Pages/choose_gender_page.dart';
import 'package:uny_app/Constants/constants.dart';
import 'package:uny_app/Data%20Models/Auth%20Data%20Models/auth_model.dart';
import 'package:uny_app/Data%20Models/User%20Data%20Model/user_data_model.dart';
import 'package:uny_app/Token%20Data/token_data.dart';
import 'package:uny_app/User%20Profile%20Page/user_profile_page.dart';

class PhoneNumberConfirmationPage extends StatefulWidget{

  String? phoneNumber;

  PhoneNumberConfirmationPage({
    required this.phoneNumber
  });

  @override
  _PhoneNumberConfirmationPageState createState() => _PhoneNumberConfirmationPageState();
}

class _PhoneNumberConfirmationPageState extends State<PhoneNumberConfirmationPage> {

  int counter = 59;

  bool? isWrong = false;
  bool? isDisabled = true;
  bool? showLoading = false;

  String? sampleCode = '0000';
  String? code;

  late double mqHeight;
  late double mqWidth;
  
  final String _assistanceImage = 'assets/assistance.svg';

  @override
  void initState() {
    super.initState();
    countDown();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper.builder(
        Scaffold(
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: GestureDetector(
              child: mainBody(),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
            )
        ),
      maxWidth: 800,
      minWidth: 450,
      defaultScale: true,
      breakpoints: [
        ResponsiveBreakpoint.resize(450, name: MOBILE),
        ResponsiveBreakpoint.autoScale(800, name: MOBILE),
      ],
    );
  }


  Widget mainBody(){
    mqHeight = MediaQuery.of(context).size.height;
    mqWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(165, 21, 215, 5),
                Color.fromRGBO(38, 78, 215, 5)
              ]
          )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: EdgeInsets.only(top: mqHeight * 0.04, left: mqWidth * 0.1, right: mqWidth * 0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Код из СМС', style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                SizedBox(
                  width: mqWidth * 0.8,
                  child: Text(
                    'Мы отправили код на твой номер телефона +7 ${widget.phoneNumber}',
                    maxLines: 3,
                    style: TextStyle(fontSize: 17, color: Colors.grey),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: mqHeight * 0.1, left: mqWidth * 0.1, right: mqWidth * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Введите код', style: TextStyle(fontSize: 17, color: Colors.white)),
                VerificationCode(
                  underlineColor: isWrong != true ? Colors.white : Colors.red,
                  cursorColor: isWrong != true ? Colors.white : Colors.red,
                  digitsOnly: true,
                  keyboardType: TextInputType.number,
                  textStyle: TextStyle(color: isWrong != true ? Colors.white : Colors.red, fontSize: 24),
                  length: 4,
                  itemSize:  mqWidth / 5.5,
                  underlineWidth: 2,
                  underlineUnfocusedColor: isWrong != true ? Colors.grey : Colors.red,
                  onCompleted: (String value) {
                    code = value;
                    setState(() {
                      isDisabled = false;
                    });
                  },

                  onEditing: (bool value) {
                    if(value){
                      setState(() {
                        isDisabled = true;
                        isWrong = false;
                      });
                    }
                  },
                ),
                Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: counter == 0 ? () async {
                            final output = widget.phoneNumber!.replaceAll(RegExp(r"[^\s\w]"), '');
                            final number = output.replaceAll(' ', '');

                            var data = {
                              'phone_number' : '+7' + number
                            };

                            Response<AuthModel> response = await UnyAPI.create(Constants.AUTH_MODEL_CONVERTER_CONSTANT).resendSMS(data);

                            setState((){
                              counter = 59;
                              countDown();
                            });
                          } : null,
                          child: Text(
                              'Отправить повторно ',
                              style: TextStyle(fontSize: 17, color: counter == 0 ? Colors.white : Colors.grey)
                          ),
                        ),
                        counter != 0 ? Text(
                            '($counterс)',
                            style: TextStyle(fontSize: 17, color: counter == 0 ? Colors.white : Colors.grey)
                        ) : Container()
                      ],
                    )
                )
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: mqHeight / 30),
              child: Material(
                borderRadius: BorderRadius.circular(11),
                color: isDisabled == true ? Colors.white.withOpacity(0.3) : Colors.white,
                child: InkWell(
                  onTap: isDisabled == true ? null : () async {
                    setState(() {
                      showLoading = true;
                    });

                    final output = widget.phoneNumber!.replaceAll(RegExp(r"[^\s\w]"), '');
                    final number = output.replaceAll(' ', '');

                    var data = {
                      'phone_number' : '+7' + number,
                      'auth_code' : code!
                    };

                    Response<UserDataModel> response = await UnyAPI.create(Constants.USER_DATA_MODEL_CONVERTER_CONSTANT).confirmCode(data);
                    UserDataModel userData = response.body!;

                    if(userData.success == true && userData.firstName == null){
                      setState((){
                        isWrong = false;
                        showLoading = false;
                      });

                      TokenData.setUserToken(userData.token);

                      Navigator.push(context, MaterialPageRoute(builder: (context) => GenderPage()));
                    }else if(userData.success == true && userData.firstName != null){
                      setState((){
                        isWrong = false;
                        showLoading = false;
                      });

                      TokenData.setUserToken(userData.token);

                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage()));
                    }else{
                      setState(() {
                        isWrong = true;
                        showLoading = false;
                      });
                    }
                  },
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: Center(
                        child: !showLoading!
                        ? Text('Далее', style: TextStyle(color: isDisabled == true ? Colors.white.withOpacity(0.5) : Colors.black, fontSize: 17))
                        : Container(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                    ),
                  ),
                ),
              )
          ),
          Padding(
            padding: EdgeInsets.only(top: mqHeight / 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  child: SvgPicture.asset(_assistanceImage)
                ),
                const SizedBox(width: 8.33),
                Text.rich(
                  TextSpan(
                      text: 'Не приходит код? ',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                      children: [
                        TextSpan(
                          text: 'Мы поможем!',
                          style: TextStyle(color: Colors.white, fontSize: 17, decoration: TextDecoration.underline),
                        ),
                      ]
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void countDown(){
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        --counter;
      });

      if(counter == 0){
        timer.cancel();
      }
    });
  }

}