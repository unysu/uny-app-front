import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_platform/universal_platform.dart';

class AllPhotosPage extends StatefulWidget {

  @override
  _AllPhotosPageState createState() => _AllPhotosPageState();
}

class _AllPhotosPageState extends State<AllPhotosPage> {

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
            body: mainBody(),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Color.fromRGBO(44, 44, 49, 10),
              title: Text('Фотография', style: TextStyle(color: Colors.white)),
              centerTitle: true,
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: IconButton(
                    icon: Icon(Icons.more_horiz),
                    onPressed: (){
                      if(UniversalPlatform.isIOS){
                        showCupertinoModalPopup(
                          context: context,
                          builder: (context){
                            return showPicOptions();
                          }
                        );
                      }else if(UniversalPlatform.isAndroid){
                        showModalBottomSheet(
                          context: context,
                          builder: (context){
                            return showPicOptions();
                          }
                        );
                      }
                    },
                  )
                )
              ],
              leading: Padding(
                padding: EdgeInsets.only(left: 10),
                child:  FittedBox(
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Text('Закрыть', style: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
              leadingWidth: width / 5,
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
      color: Colors.black,
      child: Wrap(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: height,
              enlargeCenterPage: true,
              scrollPhysics: PageScrollPhysics(),
              viewportFraction: 1,
              scrollDirection: Axis.horizontal,
            ),
            items: List.generate(10, (index){
              return Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/sample_user_pic.png'),
                      fit: BoxFit.cover,
                    )
                ),
              );
            }),
          ),
        ],
      )
    );
  }

  Widget showPicOptions(){
    return Material(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
      child: Container(
        height: height * 0.35,
        padding: EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35), topRight: Radius.circular(35)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: width / 8),
                  Text('Действия', style:
                  TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(CupertinoIcons.clear_thick_circled),
                    color: Colors.grey.withOpacity(0.5),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),
            ListTile(
              title: Text('Скачать фотографию'),
              leading: Icon(CupertinoIcons.arrow_down_to_line_alt),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 20),
            ),
            ListTile(
              title: Text('Сделать фотографией профиля'),
              leading: Icon(Icons.account_box_outlined),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 20),
              onTap: () => null,
            ),
            Divider(
              thickness: 5,
              color: Colors.grey.withOpacity(0.2),
            ),
            ListTile(
              title: Text('Удалить фотографию', style: TextStyle(color: Colors.red)),
              leading: Icon(Icons.delete_forever_outlined, color: Colors.red),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 20),
              onTap: () => null,
            ),
          ],
        ),
      ),
    );
  }
}