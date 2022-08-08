import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uny_app/API/uny_app_api.dart';
import 'package:uny_app/Cities/russia_city.dart';
import 'package:uny_app/Constants/constants.dart';
import 'package:uny_app/Data%20Models/User%20Data%20Model/user_data_model.dart';
import 'package:uny_app/Photo%20Video%20Upload%20Pages/upload_photo_page.dart';
import 'package:uny_app/Token%20Data/token_data.dart';

class AuthorizationInfoPage extends StatefulWidget{

  String? gender;

  AuthorizationInfoPage(this.gender);

  @override
  _AuthorizationInfoPageState createState() => _AuthorizationInfoPageState();
}

class _AuthorizationInfoPageState extends State<AuthorizationInfoPage>{

  FToast? _fToast;

  final String _warningIconAsset = 'assets/warning_icon.svg';

  FocusNode? locationFieldFocusNode;

  TextEditingController? nameTextController;
  TextEditingController? secondNameTextController;
  TextEditingController? dateOfBirthTextController;
  TextEditingController? locationTextController;

  bool? isNameFieldEmpty = false;
  bool? isSecondNameFieldEmpty = false;
  bool? isDateOfBirthFieldEmpty = false;
  bool? isLocationFieldEmpty = false;

  bool? isCorrectDate = true;

  DateTime _date = DateTime.now();

  late double mqHeight;
  late double mqWidth;

  bool _showLoading = false;

  @override
  void initState() {
    super.initState();

    _fToast = FToast();

    nameTextController = TextEditingController();
    secondNameTextController = TextEditingController();
    dateOfBirthTextController = TextEditingController();
    locationTextController = TextEditingController();

    locationFieldFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fToast!.init(context);
    });
  }

  @override
  void dispose() {
    super.dispose();

    nameTextController!.dispose();
    secondNameTextController!.dispose();
    dateOfBirthTextController!.dispose();
    locationTextController!.dispose();

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
                    locationFieldFocusNode!.unfocus();
                  },
                )
            ),
          maxWidth: 800,
          minWidth: 450,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: MOBILE),
          ],
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
              colors: const [
                Color.fromRGBO(165, 21, 215, 5),
                Color.fromRGBO(38, 78, 215, 5)
              ]
          )
      ),
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(top: mqHeight / 8, left: mqWidth * 0.1, right: mqWidth * 0.4),
              child: SizedBox(
                height: 60,
                width: 250,
                child: Column(
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
                )
              )
          ),
          Container(
            padding: EdgeInsets.only(top: mqHeight / 20, left: mqWidth * 0.1, right: mqWidth * 0.5),
            child: Text('Основные данные', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1),
          ),
          Container(
            padding: EdgeInsets.only(top: mqWidth / 16, left: mqWidth * 0.1, right: mqWidth * 0.1),
            child: TextFormField(
              controller: nameTextController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.done,
              style: TextStyle(color: Colors.white),
              textCapitalization: TextCapitalization.sentences,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z\u0401\u0451\u0410-\u044f/g]")),
                FilteringTextInputFormatter.deny(RegExp("/"))
              ],
              maxLength: 40,
              decoration: InputDecoration(
                counterText: "",
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
              maxLength: 40,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.sentences,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z\u0401\u0451\u0410-\u044f/g]")),
                FilteringTextInputFormatter.deny(RegExp("/"))
              ],
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                counterText: "",
                hintText: 'Фамилия',
                hintStyle: TextStyle(fontSize: 17, color: isSecondNameFieldEmpty != true ? Colors.white : Colors.red),
                fillColor: Colors.white.withOpacity(0.3),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: isSecondNameFieldEmpty != true  ? Colors.white.withOpacity(0.5) : Colors.red),
                  borderRadius: BorderRadius.circular(15),
                ),

                focusedBorder:  OutlineInputBorder(
                  borderSide: BorderSide(color: isSecondNameFieldEmpty != true ? Colors.white.withOpacity(0.5) : Colors.red),
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
              textInputAction: TextInputAction.done,
              style: TextStyle(color: Colors.white),
              readOnly: true,
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
              onTap: () => showDatePicker()
            ),
          ),

          isNameFieldEmpty! || isSecondNameFieldEmpty! || isDateOfBirthFieldEmpty! || isLocationFieldEmpty!
              ? Padding(
            padding: EdgeInsets.only(left: 30, top: 12),
            child: Row(
              children: const [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Icon(Icons.error, color: Colors.red),
                ),
                SizedBox(width: 3),
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
            child: TypeAheadField<String>(
              direction: AxisDirection.up,
              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                borderRadius: BorderRadius.circular(20)
              ),
              textFieldConfiguration: TextFieldConfiguration(
                controller: locationTextController,
                focusNode: locationFieldFocusNode,
                cursorColor: Colors.white,
                maxLength: 40,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.sentences,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z\u0401\u0451\u0410-\u044f/g]")),
                  FilteringTextInputFormatter.deny(RegExp("/"))
                ],
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  counterText: "",
                  hintText: 'Название города',
                  hintStyle: TextStyle(fontSize: 17, color: isLocationFieldEmpty != true ? Colors.white : Colors.red),
                  fillColor: Colors.white.withOpacity(0.3),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: isLocationFieldEmpty != true  ? Colors.white.withOpacity(0.5) : Colors.red),
                    borderRadius: BorderRadius.circular(15),
                  ),

                  focusedBorder:  OutlineInputBorder(
                    borderSide: BorderSide(color: isLocationFieldEmpty != true  ? Colors.white.withOpacity(0.5) : Colors.red),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onChanged: (value){
                  setState(() {
                    isLocationFieldEmpty = false;
                  });
                },
              ),
              itemBuilder: (context, city){
                return ListTile(
                  title: Text(city),
                );
              },

              onSuggestionSelected: (city){
                locationTextController!.value = locationTextController!.value.copyWith(text: city);
              },

              noItemsFoundBuilder: (context){
                return Container(
                  child: Center(
                    child: Text('Город не найден'),
                  )
                );
              },

              suggestionsCallback: (pattern){
                return RussianCities.getCities(pattern);
              }
            )
          ),
          Container(
              padding: EdgeInsets.only(top: mqHeight * 0.02),
              child: Material(
                borderRadius: BorderRadius.circular(11),
                color: Colors.white,
                child: InkWell(
                  onTap: () async {
                    validate();

                    if(!isNameFieldEmpty! && !isSecondNameFieldEmpty! && !isDateOfBirthFieldEmpty! && !isLocationFieldEmpty!){
                      setState(() {
                        _showLoading = true;
                      });


                      String name = nameTextController!.text;
                      String lastName = secondNameTextController!.text;
                      String birthDay = dateOfBirthTextController!.text;
                      String location = locationTextController!.text;
                      String gender = widget.gender!;

                      String token = 'Bearer ' + TokenData.getUserToken();

                      var data = {
                        'first_name' : name,
                        'last_name' : lastName,
                        'location' : location,
                        'date_of_birth' : birthDay,
                        'gender' : gender
                      };

                      Response<UserDataModel> updateUserResponse = await UnyAPI.create(Constants.USER_DATA_MODEL_CONVERTER_CONSTANT).updateUser(token, data);

                      if(updateUserResponse.body!.success == true){
                        setState(() {
                          _showLoading = false;
                        });

                        Navigator.push(context, MaterialPageRoute(builder: (context) => UploadPhotoPage()));
                      }else{
                        setState(() {
                          _showLoading = false;
                        });
                      }
                    }
                  },
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: Center(
                        child: !_showLoading
                         ? Text('Далее', style: TextStyle(color: Colors.black, fontSize: 17))
                         : SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                    ),
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
    if(nameTextController!.text.isEmpty){
      setState(() {
        isNameFieldEmpty = true;
      });
    }

    if(secondNameTextController!.text.isEmpty){
      setState(() {
        isSecondNameFieldEmpty = true;
      });
    }

    if(dateOfBirthTextController!.text.isEmpty){
      setState(() {
        isDateOfBirthFieldEmpty = true;
      });
    }

    if(locationTextController!.text.isEmpty){
      setState(() {
        isLocationFieldEmpty = true;
      });
    }
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
                    SizedBox(
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
                        onPressed: () {
                          if(DateTime.now().year - (_date.year) < 18){
                            _showToast();
                          }else if(DateTime.now().year - (_date.year) > 100){
                            _showToast();
                          }else{
                            setState(() {
                              isDateOfBirthFieldEmpty = false;
                            });

                            var formatter = DateFormat('dd-MM-yyyy');
                            var date = formatter.format(_date);
                            dateOfBirthTextController!.value = dateOfBirthTextController!.value.copyWith(text: date);

                            Navigator.pop(context);
                          }
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

  void _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.black,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Возраст должен быть от 18 до 100", style: TextStyle(color: Colors.white)),
          SizedBox(
            height: 20,
            width: 20,
            child: Center(child: SvgPicture.asset(_warningIconAsset)),
          )
        ],
      ),
    );

    _fToast!.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
    );
  }
}