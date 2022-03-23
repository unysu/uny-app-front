import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uny_app/Photo%20Video%20Upload%20Pages/upload_photo_page.dart';

class AuthorizationInfoPage extends StatefulWidget{
  @override
  _AuthorizationInfoPageState createState() => _AuthorizationInfoPageState();
}

class _AuthorizationInfoPageState extends State<AuthorizationInfoPage>{

  FocusNode? locationFieldFocusNode;

  TextEditingController nameTextController = TextEditingController();
  TextEditingController secondNameTextController = TextEditingController();
  TextEditingController dateOfBirthTextController = TextEditingController();
  TextEditingController locationTextController = TextEditingController();

  bool? isNameFieldEmpty = false;
  bool? isSecondNameFieldEmpty = false;
  bool? isDateOfBirthFieldEmpty = false;
  bool? isLocationFieldEmpty = false;

  DateTime _date = DateTime.now();

  late double mqHeight;
  late double mqWidth;

  @override
  void initState() {
    super.initState();
    locationFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    nameTextController.dispose();
    secondNameTextController.dispose();
    dateOfBirthTextController.dispose();
    locationTextController.dispose();

    locationFieldFocusNode!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        mqHeight = constraints.maxHeight;
        mqWidth = constraints.maxWidth;
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
                    locationFieldFocusNode!.unfocus();
                  },
                )
            ),
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.resize(480, name: MOBILE),
              const ResponsiveBreakpoint.autoScale(720, name: MOBILE)
            ]
        );
      }
    );
  }

  Widget mainBody(){
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
          AnimatedPadding(
            curve: Curves.decelerate,
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.only(top: locationFieldFocusNode!.hasFocus ? mqHeight / 500 : mqHeight / 7, left: mqWidth * 0.1, right: mqWidth * 0.4),
              child: AnimatedContainer(
                curve: Curves.easeOutExpo,
                duration: Duration(milliseconds: 150),
                height: 60,
                width: 250,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 150),
                  child: animateWidget(),
                  transitionBuilder: (widget, transition){
                    return ScaleTransition(scale: transition, child: widget);
                  },
                ),
              )
          ),
          Container(
            padding: EdgeInsets.only(top: mqHeight / 15, left: mqWidth * 0.1, right: mqWidth * 0.5),
            child: Text('Основные данные', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1),
          ),
          Container(
            padding: EdgeInsets.only(top: mqWidth / 16, left: mqWidth * 0.1, right: mqWidth * 0.1),
            child: TextFormField(
              controller: nameTextController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Имя',
                hintStyle: TextStyle(fontSize: 17, color: isNameFieldEmpty != true ? Colors.white : Colors.red),
                fillColor: Colors.white.withOpacity(0.3),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: isNameFieldEmpty != true ? Colors.white.withOpacity(0.5) : Colors.red),
                  borderRadius: BorderRadius.circular(15),
                ),

                focusedBorder:  OutlineInputBorder(
                  borderSide: BorderSide(color: isNameFieldEmpty != true ? Colors.white.withOpacity(0.5) : Colors.red),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onChanged: (value){
                setState(() {
                  isNameFieldEmpty = false;
                });
              },
            ),
          ),
          SizedBox(height: mqHeight * 0.01),
          Padding(
            padding: EdgeInsets.only(left: mqWidth * 0.1, right: mqWidth * 0.1),
            child: TextFormField(
              controller: secondNameTextController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Фамилия',
                hintStyle: TextStyle(fontSize: 17, color: isSecondNameFieldEmpty != true ? Colors.white : Colors.red),
                fillColor: Colors.white.withOpacity(0.3),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: isSecondNameFieldEmpty != true  ? Colors.white.withOpacity(0.5) : Colors.red),
                  borderRadius: BorderRadius.circular(15),
                ),

                focusedBorder:  OutlineInputBorder(
                  borderSide: BorderSide(color: isSecondNameFieldEmpty != true  ? Colors.white.withOpacity(0.5) : Colors.red),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onChanged: (value){
                setState(() {
                  isSecondNameFieldEmpty = false;
                });
              },
            ),
          ),
          SizedBox(height: mqHeight * 0.01),
          Padding(
            padding: EdgeInsets.only(left: mqWidth * 0.1, right: mqWidth * 0.1),
            child: TextFormField(
              controller: dateOfBirthTextController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Дата рождения',
                hintStyle: TextStyle(fontSize: 17, color: isDateOfBirthFieldEmpty != true ? Colors.white : Colors.red),
                fillColor: Colors.white.withOpacity(0.3),
                filled: true,
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today_outlined),
                  color: Colors.white.withOpacity(0.5),
                  onPressed: () => showDatePicker(),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: isDateOfBirthFieldEmpty != true ? Colors.white.withOpacity(0.5) : Colors.red),
                  borderRadius: BorderRadius.circular(15),
                ),

                focusedBorder:  OutlineInputBorder(
                  borderSide: BorderSide(color: isDateOfBirthFieldEmpty != true ? Colors.white.withOpacity(0.5) : Colors.red),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onChanged: (value){
                setState(() {
                  isDateOfBirthFieldEmpty = false;
                });
              },
            ),
          ),

          isNameFieldEmpty! || isSecondNameFieldEmpty! || isDateOfBirthFieldEmpty! || isLocationFieldEmpty!
              ? Padding(
            padding: EdgeInsets.only(left: 30, top: 12),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  child: Icon(Icons.error, color: Colors.red),
                ),
                const SizedBox(width: 3),
                Text('Поля не должны быть пустыми', style: TextStyle(color: Colors.red, fontSize: 15))
              ],
            ),
          ) : Container(),
          Container(
            padding: EdgeInsets.only(top: mqHeight * 0.04, left: mqWidth * 0.1, right: mqWidth * 0.5),
            child: Text('Местоположение', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: EdgeInsets.only(top: mqHeight / 50, left: mqWidth * 0.1, right: mqWidth * 0.1),
            child: TextFormField(
              focusNode: locationFieldFocusNode,
              controller: locationTextController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Название города',
                hintStyle: TextStyle(fontSize: 17, color: isLocationFieldEmpty != true ? Colors.white : Colors.red),
                fillColor: Colors.white.withOpacity(0.3),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: isLocationFieldEmpty != true ? Colors.white.withOpacity(0.5) : Colors.red),
                  borderRadius: BorderRadius.circular(15),
                ),

                focusedBorder:  OutlineInputBorder(
                  borderSide: BorderSide(color: isLocationFieldEmpty != true ? Colors.white.withOpacity(0.5) : Colors.red),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onChanged: (value){
                setState(() {
                  isLocationFieldEmpty = false;
                });
              },
              onTap: (){
                FocusScope.of(context).requestFocus(locationFieldFocusNode);
              },
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: mqHeight * 0.03),
              child: Material(
                borderRadius: BorderRadius.circular(11),
                color: Colors.white,
                child: InkWell(
                  onTap: (){
                    validate();

                    if(!isNameFieldEmpty! && !isSecondNameFieldEmpty! && !isDateOfBirthFieldEmpty! && !isLocationFieldEmpty!){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UploadPhotoPage()));
                    }
                  },
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: Center(child: Text('Далее', style: TextStyle(color: Colors.black, fontSize: 17))),
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }


  // Validate whether fields are empty or not
  void validate(){
    if(nameTextController.text.isEmpty){
      setState(() {
        isNameFieldEmpty = true;
      });
    }

    if(secondNameTextController.text.isEmpty){
      setState(() {
        isSecondNameFieldEmpty = true;
      });
    }

    if(dateOfBirthTextController.text.isEmpty){
      setState(() {
        isDateOfBirthFieldEmpty = true;
      });
    }

    if(locationTextController.text.isEmpty){
      setState(() {
        isLocationFieldEmpty = true;
      });
    }
  }

  Widget animateWidget(){
    return locationFieldFocusNode!.hasFocus ? Container() : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Как тебя зовут? 😇', style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(height: 6),
        SizedBox(
          child: Text(
            'Укажи свои имя, возраст',
            maxLines: 3,
            style: TextStyle(fontSize: 17, color: Colors.grey),
          ),
        )
      ],
    );
  }

  // Showing date picker depends on platform
  void showDatePicker(){
      showCupertinoModalPopup(
          context: context,
          builder: (context){
            return Material(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: Container(
                  height: (mqWidth / 2) * 1.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(width: mqWidth / 8),
                            Text('Дата рождения', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            Container(
                              child: IconButton(
                                icon: Icon(
                                  CupertinoIcons.clear_thick_circled,
                                  color: Colors.grey.withOpacity(0.5)),
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 200,
                        width: 500,
                        child: CupertinoDatePicker(
                          dateOrder: DatePickerDateOrder.dmy,
                          initialDateTime: _date,
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (dateTime){
                            setState(() {
                              _date = dateTime;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 500,
                        padding: EdgeInsets.only(left: 24, right: 24, top: 20),
                        child: FloatingActionButton.extended(
                          onPressed: (){
                            setState(() {
                              isDateOfBirthFieldEmpty = false;
                            });

                            var formatter = DateFormat('dd/MM/yyyy');
                            var date = formatter.format(_date);
                            dateOfBirthTextController.value = dateOfBirthTextController.value.copyWith(text: date);

                            Navigator.pop(context);
                          },
                          label: Text('Готово', style: TextStyle(fontSize: 17, color: Colors.white)),
                          backgroundColor: Color.fromRGBO(145, 10, 251, 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(11))
                          ),
                        ),
                      )
                    ],
                  )
              ),
            );
          }
      );
  }

  // Checking whether keyboard opened or closed
  bool isKeyboardClosed(){
    return MediaQuery.of(context).viewInsets.bottom == 0.0;
  }
}