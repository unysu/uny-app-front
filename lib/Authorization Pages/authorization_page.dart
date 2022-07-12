import 'package:chopper/chopper.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uny_app/API/uny_app_api.dart';
import 'package:uny_app/Authorization%20Pages/phone_nmb_confirm_page.dart';
import 'package:uny_app/Constants/constants.dart';
import 'package:uny_app/Data%20Models/Auth%20Data%20Models/auth_model.dart';

class AuthorizationPage extends StatefulWidget{
  const AuthorizationPage({Key? key}) : super(key: key);

  @override
  _AuthorizationPageState createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage>{

  final String _googleImg = 'assets/google_auth.svg';
  final String _mailruImg = 'assets/mail_auth.svg';
  final String _yandexImg = 'assets/yandex_auth.svg';
  final String _vkImg = 'assets/vk_auth.svg';
  final String _fbImg = 'assets/fb_auth.svg';
  final String _okImg = 'assets/ok_auth.svg';

  String _phoneNumberCodeString = '+7';

  FocusNode? focusNode;

  MaskedTextController? phoneNumberTextController;

  bool isDisabled = true;
  bool validate = false;
  bool showLoading = false;

  late double mqWidth;
  late double mqHeight;


  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();
    phoneNumberTextController = MaskedTextController(
        mask: '(000) 000-00-00'
    );
  }

  @override
  void dispose() {
    super.dispose();

    focusNode!.dispose();
    phoneNumberTextController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper.builder(
      Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            backgroundColor: Colors.transparent,
          ),
          body: GestureDetector(
            child: authBody(),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              focusNode!.unfocus();
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

  Widget authBody(){
    mqWidth = MediaQuery.of(context).size.width;
    mqHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
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
                Text('Привет! 👋', style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                SizedBox(
                  width: mqWidth * 0.9,
                  child: Text(
                    'Введи номер телефона, чтобы войти или зарегистрироваться, если ты новенький!',
                    maxLines: 3,
                    style: TextStyle(fontSize: 17, color: Colors.grey),
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.only(top: mqHeight / 5, left: mqWidth * 0.1, right: mqWidth * 0.1, bottom: mqHeight / 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Номер телефона', style: TextStyle(fontSize: 15, color: validate == true ? Colors.red : Colors.white)),
                        TextFormField(
                          controller: phoneNumberTextController,
                          focusNode: focusNode,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.white,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                              hintText: _phoneNumberCodeString == '+7'
                                  ? ('(XXX) XXX-XX-XX')
                                  : ('(XX) XXX-XXXX'),
                              hintStyle: const TextStyle(color: Colors.grey),
                              prefixIcon: DropdownButton<String>(
                                isExpanded: false,
                                value: _phoneNumberCodeString,
                                icon: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.grey),
                                underline: Container(),
                                items: const [
                                  DropdownMenuItem(
                                    value: '+7',
                                    child: Text('+7', style: TextStyle(fontSize: 17, color: Colors.black)),
                                  ),
                                  DropdownMenuItem(
                                    value: '+971',
                                    child: Text('+971', style: TextStyle(fontSize: 17, color: Colors.black)),
                                  )
                                ],
                                onChanged: (value){
                                  setState(() {
                                    _phoneNumberCodeString = value!;
                                  });

                                  if(value == '+971'){
                                    phoneNumberTextController!.updateMask('(00) 000-0000');
                                  }else{
                                    phoneNumberTextController!.updateMask('(000) 000-00-00');
                                  }
                                },
                              ),
                              alignLabelWithHint: true,
                              errorText: validate == true && _phoneNumberCodeString == '+7'
                                  ? 'Номер должен содержать 10 цифр' : validate == true && _phoneNumberCodeString == '+971' ? 'Номер должен содержать 9 цифр' : null,
                              errorStyle: TextStyle(color: Colors.red, fontSize: 15),
                              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                              suffixIcon: focusNode!.hasFocus ? SizedBox(
                                  child:SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: IconButton(
                                        onPressed: (){
                                          phoneNumberTextController!.clear();
                                          setState(() {
                                            isDisabled = true;
                                          });
                                        },
                                        icon: Icon(CupertinoIcons.clear_thick_circled, color: Colors.white.withOpacity(0.5))
                                    ),
                                  )
                              ) : null,
                              suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)
                              )
                          ),
                          onTap: () {
                            FocusScope.of(context).requestFocus(focusNode);
                          },
                          onChanged: (value) {
                            if(_phoneNumberCodeString == '+7'){
                              if(value.length != 15 || value == ''){
                                setState(() {
                                  validate = true;
                                  isDisabled = true;
                                });
                              }else{
                                setState(() {
                                  validate = false;
                                  isDisabled = false;
                                });
                              }
                            }else{
                              if(value.length != 13 || value == ''){
                                setState(() {
                                  validate = true;
                                  isDisabled = true;
                                });
                              }else{
                                setState(() {
                                  validate = false;
                                  isDisabled = false;
                                });
                              }
                            }
                          },
                        )
                      ],
                    )
                ),
                AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    curve: Curves.easeIn,
                    padding: EdgeInsets.only(top: mqHeight / 50, left: mqWidth * 0.3, right: mqWidth * 0.3, bottom: mqHeight / 30),
                    child: Material(
                      borderRadius: BorderRadius.circular(11),
                      color: validate == true || isDisabled == true ? Colors.white.withOpacity(0.3) : Colors.white,
                      child: InkWell(
                        onTap: validate == true || isDisabled == true ? null : () async {
                          setState(() {
                            showLoading = true;
                          });

                          final output = phoneNumberTextController!.text.replaceAll(RegExp(r"[^\s\w]"), '');
                          final number = output.replaceAll(' ', '');

                          var data = {
                            'phone_number' : '+7' + number
                          };

                          Response<AuthModel> response = await UnyAPI.create(Constants.AUTH_MODEL_CONVERTER_CONSTANT).auth(data);

                          if(response.body!.success == true) {
                            showLoading = false;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PhoneNumberConfirmationPage(phoneNumber: phoneNumberTextController!.text))
                            );
                          }else{
                            setState(() {
                              showLoading = false;
                            });
                          }
                        },
                        child: SizedBox(
                          width: 200,
                          height: 50,
                          child: Center(
                              child: !showLoading
                                    ? Text('Готово', style: TextStyle(color: validate == true || isDisabled == true ? Colors.white.withOpacity(0.5) : Colors.black, fontSize: 17))
                                    : SizedBox(
                                       height: 30,
                                       width: 30,
                                       child: CircularProgressIndicator(
                                         color: Colors.black,
                                         strokeWidth: 2,
                                       ),
                                     )
                                 ),
                             ),
                         )
                      ),
                   )
                ],
              ),
          ),
          Container(
            padding: EdgeInsets.only(top: mqHeight * 0.15, right: mqWidth * 0.1, left: mqWidth * 0.1),
            child: Text.rich(
              TextSpan(
                  text: 'Нажимая "Готово", вы подтверждаете ',
                  style: TextStyle(color: Colors.white),
                  children: const [
                    TextSpan(
                        text: 'согласие с условиями использования UnyApp ',
                        style: TextStyle(color: Colors.lightBlue)
                    ),
                    TextSpan(
                        text: 'и ',
                        style: TextStyle(color: Colors.white)
                    ),
                    TextSpan(
                      text: 'политикой о данных пользователей',
                      style: TextStyle(color: Colors.lightBlue),
                    )
                  ]
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}