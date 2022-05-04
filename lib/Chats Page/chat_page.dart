import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class UserChatPage extends StatefulWidget{

  @override
  _UserChatPageState createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage>{

  late double height;
  late double width;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        return ResponsiveWrapper.builder(
          Scaffold(
            extendBodyBehindAppBar: false,
            appBar: AppBar(
              elevation: 0.5,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              centerTitle: false,
              toolbarHeight: 70,
              leadingWidth: 30,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: Colors.grey),
              ),
              title: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: height / 15,
                        width: width / 8,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage('assets/sample_pic.png'),
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high
                            ),
                            border: Border.all(
                              color: Colors.green,
                              width: 3,
                            )
                        ),
                      ),
                      Positioned(
                        top: height / 20,
                        left: width / 55,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: const Text('64 %', style: TextStyle(
                              color: Colors.white, fontSize: 11)),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(
                                Radius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Кристина Зеленская',
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                      Text(
                        'В сети',
                        style: TextStyle(fontSize: 15, color: Colors.green),
                      )
                    ],
                  )
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () => null,
                  icon: Icon(Icons.more_horiz, color: Colors.grey),
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
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/chats_background_image.png'),
                  fit: BoxFit.cover
              )
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            height: height / 12,
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: IconButton(
                    onPressed: () => null,
                    icon: Icon(Icons.attach_file, color: Colors.grey),
                    splashRadius: 10,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Container(
                    height: 45,
                    width: 390,
                    child: TextFormField(
                      cursorColor: Color.fromRGBO(145, 10, 251, 5),
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, bottom: height / 50),
                        filled: true,
                        hintText: 'Сообщение',
                        fillColor: Colors.grey.withOpacity(0.1),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                          onPressed: () => null,
                          splashRadius: 10,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(color: Colors.grey.withOpacity(0.1))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(color: Colors.grey.withOpacity(0.1))),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  bool isKeyboardOpened(){
    return MediaQuery.of(context).viewInsets.bottom != 0.0;
  }
}