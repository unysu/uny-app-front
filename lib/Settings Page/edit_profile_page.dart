import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

class EditProfilePage extends StatefulWidget{
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  late double height;
  late double width;

  TextEditingController? _nameTextController;
  TextEditingController? _secondNameTextController;
  TextEditingController? _telephoneTextController;
  TextEditingController? _birthDateTextController;

  FocusNode? _nameTextFocusNode;
  FocusNode? _secondNameTextFocusNode;

  String _genderString = 'Женский';

  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();

    _nameTextController = TextEditingController();
    _secondNameTextController = TextEditingController();
    _telephoneTextController = TextEditingController();
    _birthDateTextController = TextEditingController();

    _nameTextFocusNode = FocusNode();
    _secondNameTextFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    _nameTextController!.dispose();
    _secondNameTextController!.dispose();
    _telephoneTextController!.dispose();
    _birthDateTextController!.dispose();

    _nameTextFocusNode!.dispose();
    _secondNameTextFocusNode!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
       height = constraints.maxHeight;
       width = constraints.maxWidth;
       return ResponsiveWrapper.builder(
         Scaffold(
           appBar: AppBar(
             elevation: 0,
             centerTitle: false,
             backgroundColor: Colors.grey.withOpacity(0),
             title: Text('Редактировать профиль', style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold)),
             leading: IconButton(
               onPressed: () => Navigator.pop(context),
               icon: Icon(Icons.arrow_back, color: Colors.grey),
             ),
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width / 20, vertical: height / 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Основная информация', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)),
          Container(
              padding: EdgeInsets.only(top: height / 50),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameTextController,
                    focusNode: _nameTextFocusNode,
                    cursorColor: Color.fromRGBO(145, 10, 251, 5),
                    style: TextStyle(color: Colors.black),
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Имя:', style: TextStyle(
                            fontSize: 17,
                            color: _nameTextFocusNode!.hasFocus ? Color.fromRGBO(145, 10, 251, 5) : Colors.grey)),
                      ),
                      prefixIconConstraints: BoxConstraints(minWidth: 10, minHeight: 10),
                      hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
                      fillColor: Colors.grey.withOpacity(0.3),
                      filled: true,
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(15),
                      ),

                      focusedBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onTap: (){
                      _secondNameTextFocusNode!.unfocus();

                      Focus.of(context).requestFocus(_nameTextFocusNode);
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _secondNameTextController,
                    focusNode: _secondNameTextFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.right,
                    cursorColor: Color.fromRGBO(145, 10, 251, 5),
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Фамилия:', style: TextStyle(
                            fontSize: 17,
                            color: _secondNameTextFocusNode!.hasFocus ? Color.fromRGBO(145, 10, 251, 5) : Colors.grey)),
                      ),
                      prefixIconConstraints: BoxConstraints(minWidth: 10, minHeight: 10),
                      hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
                      fillColor: Colors.grey.withOpacity(0.3),
                      filled: true,
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(15),
                      ),

                      focusedBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onTap: () {
                      _nameTextFocusNode!.unfocus();

                      Focus.of(context).requestFocus(_secondNameTextFocusNode);
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    readOnly: true,
                    cursorColor: Color.fromRGBO(145, 10, 251, 5),
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Пол:', style: TextStyle(fontSize: 17, color: Colors.grey)),
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: DropdownButton<String>(
                          value: _genderString,
                          icon: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.grey),
                          underline: Container(),
                          items: [
                            DropdownMenuItem(
                              value: 'Мужской',
                              child: Text('Мужской', style: TextStyle(fontSize: 17, color: Colors.black)),
                            ),
                            DropdownMenuItem(
                              value: 'Женский',
                              child:  Text('Женский', style: TextStyle(fontSize: 17, color: Colors.black)),
                            ),
                            DropdownMenuItem(
                              value: 'Другое',
                              child:  Text('Другое', style: TextStyle(fontSize: 17, color: Colors.black)),
                            )
                          ],
                          onChanged: (value){
                            setState(() {
                              _genderString = value!;
                            });
                          },
                        )
                      ),
                      prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                      suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                      hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
                      fillColor: Colors.grey.withOpacity(0.3),
                      filled: true,
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(15),
                      ),

                      focusedBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _telephoneTextController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    cursorColor: Color.fromRGBO(145, 10, 251, 5),
                    textAlign: TextAlign.right,
                    readOnly: true,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      suffixIcon: Container(
                        child: IconButton(
                          icon: Icon(Icons.keyboard_arrow_right_rounded, color: Colors.grey),
                          onPressed: () => null,
                        ),
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Телефон:', style: TextStyle(fontSize: 17, color: Colors.grey)),
                      ),
                      prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                      suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                      hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
                      fillColor: Colors.grey.withOpacity(0.3),
                      filled: true,
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(15),
                      ),

                      focusedBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _birthDateTextController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    cursorColor: Color.fromRGBO(145, 10, 251, 5),
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today_outlined, color: Color.fromRGBO(145, 10, 251, 5)),
                        onPressed: () => showDatePicker(),
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Дата рождения:', style: TextStyle(fontSize: 17, color: Colors.grey)),
                      ),
                      prefixIconConstraints: BoxConstraints(minWidth: 10, minHeight: 10),
                      hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
                      fillColor: Colors.grey.withOpacity(0.3),
                      filled: true,
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(15),
                      ),

                      focusedBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }

  void showDatePicker(){
    showCupertinoModalPopup(
        context: context,
        builder: (context){
          return Material(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            child: Container(
                height: (width / 2) * 1.9,
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
                          Container(width: width / 8),
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
                          var formatter = DateFormat('dd.MM.yyyy');
                          var date = formatter.format(_date);
                          _birthDateTextController!.value = _birthDateTextController!.value.copyWith(text: date);

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
}