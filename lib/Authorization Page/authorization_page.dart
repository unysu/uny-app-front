import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AuthorizationPage extends StatefulWidget{
  const AuthorizationPage({Key? key}) : super(key: key);

  @override
  _AuthorizationPageState createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage>{

  Image googleImg = Image.asset('assets/google.png');
  Image fbImg = Image.asset('assets/fb.png');
  Image mailruImg = Image.asset('assets/mailru.png');
  Image yandexImg = Image.asset('assets/yandex.png');
  Image okImg = Image.asset('assets/ok.png');
  Image vkImg = Image.asset('assets/vk.png');


  FocusNode? focusNode;

  TextEditingController? textController;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    focusNode!.dispose();
    textController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper.builder(
      Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          child: authBody(),
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            focusNode!.unfocus();
          },
        )
      ),
      defaultScale: true,
      breakpoints: const [
        ResponsiveBreakpoint.resize(500, name: MOBILE),
      ],
    );
  }

  Widget authBody(){
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple,
                Colors.blueAccent
              ]
          )
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 40, top: 120, right: 79, bottom: focusNode!.hasFocus ? 200 : 350),
            child: SizedBox(
              height: 95,
              width: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Привет! 👋', style: TextStyle(fontSize: 24, color: Colors.white)),
                  SizedBox(height: 6),
                  SizedBox(
                    width: 295,
                    height: 56,
                    child: Text(
                      'Введи номер телефона, чтобы войти или зарегистрироваться, если ты новенький!',
                      maxLines: 3,
                      style: TextStyle(fontSize: 17, color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 40, right: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Номер телефона', style: TextStyle(fontSize: 15, color: Colors.white)),
                  TextFormField(
                    controller: textController,
                    focusNode: focusNode,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: ('(XXX) XXX-XX-XX'),
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Text('+7 ', style: TextStyle(color: Colors.white, fontSize: 15)),
                      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                      suffixIcon: focusNode!.hasFocus ? IconButton(onPressed: (){textController!.clear();}, icon: Icon(CupertinoIcons.clear_thick_circled, color: Colors.white.withOpacity(0.5))) : null,
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
                  )
                ],
              )
          ),
          focusNode!.hasFocus ? Container() : Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Material(
                    color: Colors.white.withOpacity(0.1), // Button color
                    child: InkWell(// Splash color
                      onTap: () {},
                      child: SizedBox(width: 50, height: 50, child: googleImg),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ClipOval(
                  child: Material(
                    color: Colors.white.withOpacity(0.1), // Button color
                    child: InkWell(// Splash color
                      onTap: () {},
                      child: SizedBox(width: 50, height: 50, child: mailruImg),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ClipOval(
                  child: Material(
                    color: Colors.white.withOpacity(0.1), // Button color
                    child: InkWell(// Splash color
                      onTap: () {},
                      child: SizedBox(width: 50, height: 50, child: yandexImg),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ClipOval(
                  child: Material(
                    color: Colors.white.withOpacity(0.1), // Button color
                    child: InkWell(// Splash color
                      onTap: () {},
                      child: SizedBox(width: 50, height: 50, child: vkImg),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ClipOval(
                  child: Material(
                    color: Colors.white.withOpacity(0.1), // Button color
                    child: InkWell(// Splash color
                      onTap: () {},
                      child: SizedBox(width: 50, height: 50, child: fbImg),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ClipOval(
                  child: Material(
                    color: Colors.white.withOpacity(0.1), // Button color
                    child: InkWell(// Splash color
                      onTap: () {},
                      child: SizedBox(width: 50, height: 50, child: okImg),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40, bottom: focusNode!.hasFocus ? 10 : 30),
            child: SizedBox(
              width: 200,
              height: 50,
              child: FloatingActionButton.extended(
                onPressed: null,
                label: const Text('Готово'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                ),
              ),
            )
          ),
          focusNode!.hasFocus ? Container() : const Padding(
            padding: EdgeInsets.only(left: 35, right: 35),
            child: Text.rich(
                TextSpan(
                    text: 'Нажимая "Готово", вы подтверждаете ',
                    style: TextStyle(color: Colors.white),
                    children: [
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