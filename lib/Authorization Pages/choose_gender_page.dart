
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uny_app/Authorization%20Pages/authorization_info_page.dart';

class GenderPage extends StatefulWidget{
  @override
  _GenderPageState createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage>{

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper.builder(
      Scaffold(
          resizeToAvoidBottomInset: false,
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

  Widget mainBody() {
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
                padding: EdgeInsets.only(left: 40, top: 130, right: 79, bottom: 130),
                child: SizedBox(
                  height: 95,
                  width: 500,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Укажи свой пол ☺', style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                      SizedBox(height: 6),
                      SizedBox(
                        width: 295,
                        height: 56,
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
            width: 500,
            height: 500,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  width: 150,
                  left: 60,
                  bottom: 380,
                  child:  Column(
                    children: [
                      Image.asset('assets/woman.png'),
                      Text('Женский', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                Positioned(
                    width: 150,
                    height: 150,
                    left: 170,
                    top: 150,
                    child: Image.asset('assets/logo_no_background.png')
                ),
                Positioned(
                    width: 150,
                    height: 130,
                    left: 100,
                    bottom: 0,
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
                    width: 150,
                    height: 180,
                    left: 300,
                    bottom: 230,
                    child: Column(
                      children: [
                        Image.asset('assets/man.png'),
                        Text('Мужской', style: TextStyle(color: Colors.white))
                      ],
                    ),
                ),
                Positioned(
                    width: 150,
                    height: 180,
                    left: 250,
                    bottom: 20,
                    child: Image.asset('assets/heart.png'),
                ),
                Positioned(
                  width: 150,
                  height: 180,
                  left: 35,
                  bottom: 160,
                  child: Image.asset('assets/pc.png'),
                ),
                Positioned(
                  width: 130,
                  height: 180,
                  bottom: 150,
                  child: Image.asset('assets/money.png'),
                ),
                Positioned(
                  width: 150,
                  height: 180,
                  left: 208,
                  bottom: 270,
                  child: Image.asset('assets/heart_1.png'),
                ),
                Positioned(
                  width: 150,
                  height: 180,
                  left: 235,
                  bottom: 350,
                  child: Image.asset('assets/avatar.png'),
                ),
                Positioned(
                  width: 150,
                  height: 180,
                  left: 138,
                  bottom: 100,
                  child: Image.asset('assets/dot.png'),
                ),
                Positioned(
                  width: 150,
                  height: 180,
                  left: 138,
                  bottom: 335,
                  child: Image.asset('assets/dot.png'),
                ),
                Positioned(
                  width: 150,
                  height: 180,
                  left: 10,
                  bottom: 205,
                  child: Image.asset('assets/dot.png'),
                ),
                Positioned(
                  left: 60,
                  child: Image.asset('assets/gender_page_lines.png'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void nextPage(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => AuthorizationInfoPage()));
  }
}