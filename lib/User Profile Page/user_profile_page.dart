import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class UserProfilePage extends StatefulWidget{

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>{

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
             extendBodyBehindAppBar: true,
             appBar: AppBar(
               elevation: 0,
               automaticallyImplyLeading: false,
               systemOverlayStyle: SystemUiOverlayStyle.light,
               backgroundColor: Colors.transparent,
             ),
             body: mainBody(),
           ),
           defaultScale: true,
           breakpoints: [
             const ResponsiveBreakpoint.resize(480, name: MOBILE),
             const ResponsiveBreakpoint.autoScale(720, name: MOBILE)
           ]
       );
      },
    );
  }

  Widget mainBody() {
    return Column(
      children: [
        Align(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20)
            ),
            child: Container(
              height: height / 4.8,
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
              child: Container(
                padding: EdgeInsets.only(left: width / 20, top: height / 20),
                child: Row(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      child: Image.asset('assets/sample_pic.png', fit: BoxFit.cover),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Мой профиль', style: TextStyle(color: Colors.white, fontSize: 17)),
                            SizedBox(width: width / 2.5),
                            IconButton(
                              icon: Icon(Icons.settings, color: Colors.white),
                              onPressed: () => null,
                            )
                          ],
                        ),
                        Text('Кристина З. 23 🇷🇺', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 3),
                        Text('Менеджер-логист в логистической к...', style: TextStyle(fontSize: 15, color: Colors.grey))
                      ],
                    )
                  ],
                ),
              )
            ),
          )
        ),
        SizedBox(height: height / 25),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Мои интересы', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)),
              InkWell(
                onTap: () => null,
                child: Text('Редактировать', style: TextStyle(fontSize: 17, color: Color.fromRGBO(145, 10, 251, 5))),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 100,
        ),
        Divider(
          height: 1,
          color: Colors.grey,
        ),
        SizedBox(height: 15),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('О себе', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)),
                Container(
                  height: 30,
                  width: 110,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.edit, color: Color.fromRGBO(145, 10, 251, 5), size: 20),
                      Text('Изменить', style: TextStyle(fontSize: 15, color: Colors.black))
                    ],
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Colors.grey,
                          width: 0.5
                      )
                  ),
                )
              ],
          ),
        ),
        SizedBox(height: 15),
        Stack(
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'В то время некий безымянный печатник создал большую коллекцию размеров и форм шрифтов, используя Lorem Ipsum для распечатки образцов. Lorem Ipsum не только успешно пережил без заметных',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                  overflow: TextOverflow.fade,
                  maxLines: 4,
                )
            ),
            Padding(
              padding: EdgeInsets.only(top: height / 17, left: width / 1.1),
              child: InkWell(
                onTap: () => null,
                child: Row(
                  children: [
                    Text('Ещё', style: TextStyle(fontSize: 15, color: Color.fromRGBO(145, 10, 251, 5))),
                    Icon(Icons.arrow_drop_down, color: Color.fromRGBO(145, 10, 251, 5))
                  ],
                ),
              )
            )
          ],
        ),
        SizedBox(height: 25),
        Divider(
          thickness: 8,
          color: Colors.grey.withOpacity(0.1),
        )
      ],
    );
  }
}