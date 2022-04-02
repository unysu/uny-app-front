import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uny_app/Authorization%20Pages/authorization_info_page.dart';

class GenderPage extends StatefulWidget{
  @override
  _GenderPageState createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage>{

  late double mqHeight;
  late double mqWidth;

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
      defaultScale: true,
      breakpoints: [
        const ResponsiveBreakpoint.resize(480, name: MOBILE),
        const ResponsiveBreakpoint.resize(720, name: MOBILE)
      ]
    );
  }

  Widget mainBody() {
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
        children: [
          Padding(
              padding: EdgeInsets.only(top: mqHeight / 7, left: mqWidth * 0.1, right: mqWidth * 0.3, bottom: mqHeight * 0.1),
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Укажи свой пол ☺', style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    SizedBox(
                      width: mqWidth * 0.7,
                      child: Text(
                        'Это нужно, чтобы мы могли правильно подобрать тебе единомышленника',
                        maxLines: 3,
                        style: TextStyle(fontSize: 17, color: Colors.grey),
                      ),
                    )
                  ],
                ),
              )
          ),
          Container(
            height: 500,
            child: LayoutBuilder(
              builder: (context, constraint){
                double height = constraint.maxHeight;
                double width = constraint.maxWidth;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned (
                      left: height / 6,
                      bottom: width * 0.8,
                      child:  GestureDetector(
                        onTap: () => nextPage(),
                        child: Column(
                          children: [
                            Image.asset('assets/woman.png'),
                            Text('Женский', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      )
                    ),
                    Positioned(
                      left: height / 2.7,
                      bottom: width / 2.2,
                      child: Image.asset('assets/logo_no_background.png'),
                    ),
                    Positioned(
                        left: height / 4.2,
                        bottom: width / 18,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => nextPage(),
                              child: Image.asset('assets/another_gender.png'),
                            ),
                            Text('Другое', style: TextStyle(color: Colors.white))
                          ],
                        )
                    ),
                    Positioned(
                        right: height / 10,
                        bottom: width / 2,
                        child: GestureDetector(
                          excludeFromSemantics: false,
                          onTap: () => nextPage(),
                          child: Column(
                            children: [
                              Image.asset('assets/man.png'),
                              Text('Мужской', style: TextStyle(color: Colors.white))
                            ],
                          ),
                        )
                    ),
                    Positioned(
                      right: height / 4,
                      bottom: width / 5.7,
                      child: Image.asset('assets/heart.png'),
                    ),
                    Positioned(
                      left: height / 6.3,
                      bottom: width * 0.5,
                      child: Image.asset('assets/pc.png'),
                    ),
                    Positioned(
                      left: height / 12,
                      bottom: width / 2.2,
                      child: Image.asset('assets/money.png'),
                    ),
                    Positioned(
                      right: height / 2.9,
                      bottom: width / 1.36,
                      child: Image.asset('assets/heart_1.png'),
                    ),
                    Positioned(
                      right: height / 3.5,
                      bottom: width / 1.10,
                      child: Image.asset('assets/avatar.png'),
                    ),
                    Positioned(
                      right: height / 2.1,
                      bottom: width / 1.152,
                      child: Image.asset('assets/dot.png'),
                    ),
                    Positioned(
                      right: height / 2.05,
                      bottom: width / 2.5,
                      child: Image.asset('assets/dot.png'),
                    ),
                    Positioned(
                      left: height / 7,
                      bottom: width / 1.57,
                      child: Image.asset('assets/dot.png'),
                    ),
                    Positioned(
                      left: height / 11,
                      top: width / 22,
                      child: Image.asset('assets/gender_page_lines.png'),
                    )
                  ],
                );
              },
            )
          )
        ],
      ),
    );
  }

  void nextPage(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => AuthorizationInfoPage()));
  }
}