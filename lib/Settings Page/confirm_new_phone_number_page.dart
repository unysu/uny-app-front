import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_framework/responsive_framework.dart';


class ConfirmNewPhoneNumberPage extends StatefulWidget {

  String? phoneNumber;

  ConfirmNewPhoneNumberPage({
    required this.phoneNumber
  });

  @override
  _ConfirmNewPhoneNumberPageState createState() => _ConfirmNewPhoneNumberPageState(phoneNumber: phoneNumber);
}


class _ConfirmNewPhoneNumberPageState extends State<ConfirmNewPhoneNumberPage> {

  String? phoneNumber;

  _ConfirmNewPhoneNumberPageState({
    required this.phoneNumber
  });

  late double height;
  late double width;

  int counter = 59;

  bool? isWrong = false;
  bool? isDisabled = true;

  String? sampleCode = '0000';
  String? code;

  FToast? _fToast;

  @override
  void initState() {
    super.initState();

    countDown();

    _fToast = FToast();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _fToast!.init(context);
    });
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
              title: Text('Сменить номер', style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold)),
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: Colors.grey),
              ),
            ),
            body: GestureDetector(
              child: mainBody(),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
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
      color: Colors.grey.withOpacity(0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: height / 20, left: width / 15, right: width / 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Код из СМС', style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                SizedBox(
                  width: width * 0.8,
                  child: Text(
                    'Мы отправили код на твой новый номер телефона +7 $phoneNumber',
                    maxLines: 3,
                    style: TextStyle(fontSize: 17, color: Colors.grey),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: height / 6, left: width * 0.1, right: width * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Введите код для смены номера телефона', style: TextStyle(fontSize: 14, color: Colors.black)),
                VerificationCode(
                  underlineColor: isWrong != true ? Color.fromRGBO(145, 10, 251, 5) : Colors.red,
                  cursorColor: isWrong != true ? Color.fromRGBO(145, 10, 251, 5) : Colors.red,
                  digitsOnly: true,
                  keyboardType: TextInputType.number,
                  textStyle: TextStyle(color: isWrong != true ? Color.fromRGBO(145, 10, 251, 5) : Colors.red, fontSize: 24),
                  length: 4,
                  itemSize:  width / 5.5,
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
                          onTap: counter == 0 ? () => {setState((){counter = 59; countDown();})} : null,
                          child: Text(
                              'Отправить повторно ',
                              style: TextStyle(fontSize: 17, color: counter == 0 ? Colors.black : Colors.grey)
                          ),
                        ),
                        counter != 0 ? Text(
                            '($counterс)',
                            style: TextStyle(fontSize: 17, color: counter == 0 ? Colors.black : Colors.grey)
                        ) : Container()
                      ],
                    )
                )
              ],
            ),
          ),
          SizedBox(height: height / 18),
          Container(
              padding: EdgeInsets.only(bottom: width / 100),
              alignment: Alignment.center,
              width: 300,
              height: 50,
              child: Material(
                borderRadius: BorderRadius.circular(11),
                color: Color.fromRGBO(145, 10, 251, 5),
                child: InkWell(
                  onTap: isDisabled == false ? (){
                    if(sampleCode != code){
                      setState(() {
                        isWrong = true;
                      });
                    }else{
                      Navigator.pop(context);
                      Navigator.pop(context);
                      _showToast();
                    }
                  } : null,
                  child: Container(
                    child: Center(child: Text('Сменить номер', style: TextStyle(
                        color: Colors.white.withOpacity(0.9), fontSize: 17))),
                  ),
                ),
              )
          )
        ],
      ),
    );
  }

  void countDown() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        --counter;
      });

      if(counter == 0){
        timer.cancel();
      }
    });
  }

  void _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.black,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Вы успешно сменили номер телефона", style: TextStyle(color: Colors.white)),
          Container(
            height: 20,
            width: 20,
            child: Center(child: Icon(Icons.check, color: Colors.black, size: 15)),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green
            ),
          )
        ],
      ),
    );

    _fToast!.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
    );
  }
}