import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_platform/universal_platform.dart';

class AuthorizationInfoPage extends StatefulWidget{
  @override
  _AuthorizationInfoPageState createState() => _AuthorizationInfoPageState();
}

class _AuthorizationInfoPageState extends State<AuthorizationInfoPage>{

  TextEditingController nameTextController = TextEditingController();
  TextEditingController secondNameTextController = TextEditingController();
  TextEditingController dateOfBirthTextController = TextEditingController();
  TextEditingController locationTextController = TextEditingController();

  bool? isNameFieldEmpty = false;
  bool? isSecondNameFieldEmpty = false;
  bool? isDateOfBirthFieldEmpty = false;
  bool? isLocationFieldEmpty = false;

  DateTime _date = DateTime.now();

  @override
  void dispose() {
    super.dispose();

    nameTextController.dispose();
    secondNameTextController.dispose();
    dateOfBirthTextController.dispose();
    locationTextController.dispose();
  }

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

  Widget mainBody(){
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
              padding: EdgeInsets.only(left: 40, right: 79, top: !isKeyboardClosed() ? 100 : 130),
              child: SizedBox(
                height: 95,
                width: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Как тебя зовут? 😇', style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    SizedBox(
                      width: 295,
                      height: 56,
                      child: Text(
                        'Укажи свои имя, возраст',
                        maxLines: 3,
                        style: TextStyle(fontSize: 17, color: Colors.grey),
                      ),
                    )
                  ],
                ),
              )
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 200),
            child: Text('Основные данные', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1),
          ),
          Padding(
            padding: EdgeInsets.only(left: 38, right: 38, top: 12),
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
          Padding(
            padding: EdgeInsets.only(left: 38, right: 38, top: 12),
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
          Padding(
            padding: EdgeInsets.only(left: 38, right: 38, top: 12),
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
          Padding(
            padding: EdgeInsets.only(top: 30, left: 38, right: 211),
            child: Text('Местоположение', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.only(left: 38, right: 38, top: 15),
            child: TextFormField(
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
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 250),
              child: Material(
                borderRadius: BorderRadius.circular(11),
                color: Colors.white,
                child: InkWell(
                  onTap: () => validate(),
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

  // Showing date picker depends on platform
  void showDatePicker(){
    if(UniversalPlatform.isIOS){
       showCupertinoModalPopup(
         context: context,
         builder: (context){
           return Align(
             alignment: Alignment.bottomCenter,
             child: ClipRRect(
               borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
               child: Container(
                 color: Colors.white,
                 height: 350,
                 child: Column(
                   children: [
                     CupertinoDatePicker(
                       dateOrder: DatePickerDateOrder.dmy,
                       initialDateTime: _date,
                       mode: CupertinoDatePickerMode.date,
                       onDateTimeChanged: (dateTime){
                         setState(() {
                           _date = dateTime;
                         });
                       },
                     ),

                   ],
                 )
               ),
             ),
           );
         }
       );
    }
  }

  // Checking whether keyboard opened or closed
  bool isKeyboardClosed(){
    return MediaQuery.of(context).viewInsets.bottom == 0.0;
  }
}