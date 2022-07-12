import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/Report%20Types/report_types.dart';

class ReportPageAndroid extends StatefulWidget{
  @override
  _ReportPageAndroidState createState() => _ReportPageAndroidState();
}

class _ReportPageAndroidState extends State<ReportPageAndroid>{


  late double height;
  late double width;

  Reports? _reports;

  @override
  void initState() {
    super.initState();

    _reports = Reports.init();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        return Sizer(
          builder: (context, orientation, deviceType) {
            return ResponsiveWrapper.builder (
                Scaffold(
                  appBar: AppBar(
                    centerTitle: false,
                    backgroundColor: Colors.white,
                    title: Text('Пожаловаться', style:
                    TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black)),
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: mainBody(),
                  ),
                )
            );
          },
        );
      },
    );
  }


  Widget mainBody(){
    return SizedBox(
        height: height,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                'Выберите причину жалобы',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: width / 20),
              width: width,
              height: height * 0.8,
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Спам',
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: _reports!.isSpam,
                            onChanged: (value) {
                              setState((){
                                _reports!.isSpam = value!;
                              });
                            },
                            shape: CircleBorder(),
                            checkColor: Colors.white,
                            side: BorderSide(
                              color: Colors.grey,
                            ),
                            splashRadius: UniversalPlatform.isIOS ? 2 : null,
                            activeColor: Color.fromRGBO(145, 10, 251, 5)
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Оскорбление',
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: _reports!.isAbuse,
                            onChanged: (value) {
                              setState((){
                                _reports!.isAbuse = value!;
                              });
                            },
                            shape: CircleBorder(),
                            checkColor: Colors.white,
                            side: BorderSide(
                              color: Colors.grey,
                            ),
                            splashRadius: UniversalPlatform.isIOS ? 2 : null,
                            activeColor: Color.fromRGBO(145, 10, 251, 5),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Материал для взрослых',
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: _reports!.isAdultContent,
                            onChanged: (value) {
                              setState((){
                                _reports!.isAdultContent = value!;
                              });
                            },
                            shape: CircleBorder(),
                            checkColor: Colors.white,
                            side: BorderSide(
                              color: Colors.grey,
                            ),
                            splashRadius: UniversalPlatform.isIOS ? 2 : null,
                            activeColor: Color.fromRGBO(145, 10, 251, 5),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Детская порнография',
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: _reports!.isChildPorn,
                            onChanged: (value) {
                              setState((){
                                _reports!.isChildPorn = value!;
                              });
                            },
                            shape: CircleBorder(),
                            checkColor: Colors.white,
                            side: BorderSide(
                              color: Colors.grey,
                            ),
                            splashRadius: UniversalPlatform.isIOS ? 2 : null,
                            activeColor: Color.fromRGBO(145, 10, 251, 5),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Пропаганда наркотиков',
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: _reports!.isDrugPropoganda,
                            onChanged: (value) {
                              setState((){
                                _reports!.isDrugPropoganda = value!;
                              });
                            },
                            shape: CircleBorder(),
                            checkColor: Colors.white,
                            side: BorderSide(
                              color: Colors.grey,
                            ),
                            splashRadius: UniversalPlatform.isIOS ? 2 : null,
                            activeColor: Color.fromRGBO(145, 10, 251, 5),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Жестокий и шокирующий контент',
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: _reports!.isViolentContent,
                            onChanged: (value) {
                              setState((){
                                _reports!.isViolentContent = value!;
                              });
                            },
                            shape: CircleBorder(),
                            checkColor: Colors.white,
                            side: BorderSide(
                              color: Colors.grey,
                            ),
                            splashRadius: UniversalPlatform.isIOS ? 2 : null,
                            activeColor: Color.fromRGBO(145, 10, 251, 5),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Призыв к травле',
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: _reports!.isCallForPersecution,
                            onChanged: (value) {
                              setState((){
                                _reports!.isCallForPersecution = value!;
                              });
                            },
                            shape: CircleBorder(),
                            checkColor: Colors.white,
                            side: BorderSide(
                              color: Colors.grey,
                            ),
                            splashRadius: UniversalPlatform.isIOS ? 2 : null,
                            activeColor: Color.fromRGBO(145, 10, 251, 5),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Призыв к суициду',
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: _reports!.isSuicideCall,
                            onChanged: (value) {
                              setState((){
                                _reports!.isSuicideCall = value!;
                              });
                            },
                            shape: CircleBorder(),
                            checkColor: Colors.white,
                            side: BorderSide(
                              color: Colors.grey,
                            ),
                            splashRadius: UniversalPlatform.isIOS ? 2 : null,
                            activeColor: Color.fromRGBO(145, 10, 251, 5),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Жестокое обращение с животными',
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: _reports!.isRudeToAnimals,
                            onChanged: (value) {
                              setState((){
                                _reports!.isRudeToAnimals = value!;
                              });
                            },
                            shape: CircleBorder(),
                            checkColor: Colors.white,
                            side: BorderSide(
                              color: Colors.grey,
                            ),
                            splashRadius: UniversalPlatform.isIOS ? 2 : null,
                            activeColor: Color.fromRGBO(145, 10, 251, 5),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Введение в заблуждение',
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: _reports!.isMisLeading,
                            onChanged: (value) {
                              setState((){
                                _reports!.isMisLeading = value!;
                              });
                            },
                            shape: CircleBorder(),
                            checkColor: Colors.white,
                            side: BorderSide(
                              color: Colors.grey,
                            ),
                            splashRadius: UniversalPlatform.isIOS ? 2 : null,
                            activeColor: Color.fromRGBO(145, 10, 251, 5),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Мошенничество',
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: _reports!.isFraud,
                            onChanged: (value) {
                              setState((){
                                _reports!.isFraud = value!;
                              });
                            },
                            shape: CircleBorder(),
                            checkColor: Colors.white,
                            side: BorderSide(
                              color: Colors.grey,
                            ),
                            splashRadius: UniversalPlatform.isIOS ? 2 : null,
                            activeColor: Color.fromRGBO(145, 10, 251, 5),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Экстремизм',
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: _reports!.isExtreme,
                            onChanged: (value) {
                              setState((){
                                _reports!.isExtreme = value!;
                              });
                            },
                            shape: CircleBorder(),
                            checkColor: Colors.white,
                            side: BorderSide(
                              color: Colors.grey,
                            ),
                            splashRadius: UniversalPlatform.isIOS ? 2 : null,
                            activeColor: Color.fromRGBO(145, 10, 251, 5),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Враждебные высказывания',
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: _reports!.isHostileRemark,
                            onChanged: (value) {
                              setState((){
                                _reports!.isHostileRemark = value!;
                              });
                            },
                            shape: CircleBorder(),
                            checkColor: Colors.white,
                            side: BorderSide(
                              color: Colors.grey,
                            ),
                            splashRadius: UniversalPlatform.isIOS ? 2 : null,
                            activeColor: Color.fromRGBO(145, 10, 251, 5),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: height / 25),
                  ClipRRect(
                    child: Container(
                      height: 50,
                      width: 200,
                      child: Center(
                        child: Text(
                          'Пожаловаться',
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(145, 10, 251, 5),
                          borderRadius: BorderRadius.all(Radius.circular(11))
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        )
    );
  }
}