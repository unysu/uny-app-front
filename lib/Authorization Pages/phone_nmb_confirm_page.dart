import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uny_app/Authorization%20Pages/choose_gender_page.dart';

class PhoneNumberConfirmationPage extends StatefulWidget{
  @override
  _PhoneNumberConfirmationPageState createState() => _PhoneNumberConfirmationPageState();
}

class _PhoneNumberConfirmationPageState extends State<PhoneNumberConfirmationPage>{

  int counter = 59;

  bool? isWrong = false;
  bool? isDisabled = true;

  String? sampleCode = '4533';
  String? code;

  @override
  void initState() {
    super.initState();
    countDown();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper.builder(
      Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
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
      defaultScale: true,
      breakpoints: const [
        ResponsiveBreakpoint.resize(500, name: MOBILE),
      ],
    );
  }


  Widget mainBody(){
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple[400]!,
              Colors.blue[700]!
            ]
        )
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 40, top: 120, right: 79, bottom: !isKeyboardClosed() ? 100 : 200),
            child: SizedBox(
              height: 95,
              width: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Код из СМС', style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  SizedBox(
                    width: 295,
                    height: 56,
                    child: Text(
                      'Мы отправили код на твой номер телефона +7 (928) 291-29-21',
                      maxLines: 3,
                      style: TextStyle(fontSize: 17, color: Colors.grey),
                    ),
                  )
                ],
              ),
            )
          ),
          Padding(
            padding: EdgeInsets.only(left: 40, right: 40),
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Введите код', style: TextStyle(fontSize: 15, color: Colors.white)),
                  VerificationCode(
                    underlineColor: isWrong != true ? Colors.white : Colors.red,
                    cursorColor: isWrong != true ? Colors.white : Colors.red,
                    digitsOnly: true,
                    keyboardType: TextInputType.number,
                    textStyle: TextStyle(color: isWrong != true ? Colors.white : Colors.red, fontSize: 24),
                    length: 4,
                    itemSize: 85,
                    underlineWidth: 3,
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
                          onTap: counter == 0 ? () => {setState((){counter = 59; countDown();})} : null,
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
          ),
          Padding(
              padding: EdgeInsets.only(top: 50, bottom: !isKeyboardClosed() ? 10 : 30),
              child: Material(
                borderRadius: BorderRadius.circular(11),
                color: isDisabled == true ? Colors.white.withOpacity(0.3) : Colors.white,
                child: InkWell(
                  onTap: isDisabled == true ? null : (){
                    code != sampleCode ? setState((){
                      isWrong = true;
                    }) : setState((){
                      isWrong = false;
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GenderPage()));
                    });
                    },
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: Center(child: Text('Далее', style: TextStyle(color:isDisabled == true ? Colors.white.withOpacity(0.5) : Colors.black, fontSize: 17))),
                  ),
                ),
              )
          ),
          Padding(
            padding: EdgeInsets.only(top: !isKeyboardClosed() ? 30 : 230, left: 35, right: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 18.33,
                  height: 18.33,
                  child: Image.asset('assets/assistance.png'),
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
            )
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

  // Checking whether keyboard opened or closed
  bool isKeyboardClosed(){
    return MediaQuery.of(context).viewInsets.bottom == 0.0;
  }
}