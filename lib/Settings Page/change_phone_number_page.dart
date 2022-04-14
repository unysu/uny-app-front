import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uny_app/Settings%20Page/confirm_new_phone_number_page.dart';

class ChangePhoneNumberPage extends StatefulWidget{

  @override
  _ChangePhoneNumberPageState createState() => _ChangePhoneNumberPageState();
}

class _ChangePhoneNumberPageState extends State<ChangePhoneNumberPage>{


  MaskedTextController? _phoneNumberTextController;

  FocusNode? focusNode;

  bool? isDisabled = true;
  bool? validate = false;

  late double height;
  late double width;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();

    _phoneNumberTextController = MaskedTextController(mask: '(000) 000-00-00');
  }

  @override
  void dispose() {
    super.dispose();

    focusNode!.dispose();

    _phoneNumberTextController!.dispose();
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
                backgroundColor: Colors.white,
                title: Text('Номер телефона', style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold)),
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, color: Colors.grey),
                ),
              ),
              body: GestureDetector(
                child: mainBody(),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  focusNode!.unfocus();
                },
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
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: height / 20, left: width / 15, right: width / 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('У вас новый номер?', style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                SizedBox(
                  child: Text(
                    'Укажите его здесь. Он будет использоваться для входа в приложение',
                    maxLines: 2,
                    style: TextStyle(fontSize: 17, color: Colors.grey),
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.only(top: height / 5, left: width * 0.1, right: width * 0.1, bottom: height / 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Номер телефона', style: TextStyle(fontSize: 15, color: validate == true ? Colors.red : focusNode!.hasFocus ? Color.fromRGBO(145, 10, 251, 5) : Colors.black)),
                        TextFormField(
                          controller: _phoneNumberTextController,
                          focusNode: focusNode,
                          style: const TextStyle(color: Colors.black),
                          keyboardType: TextInputType.number,
                          cursorColor: Color.fromRGBO(145, 10, 251, 5),
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                              hintText: ('(XXX) XXX-XX-XX'),
                              hintStyle: const TextStyle(color: Colors.grey),
                              prefixIcon: const Text('+7 ', style: TextStyle(color: Colors.black, fontSize: 15)),
                              alignLabelWithHint: true,
                              errorText: validate == true ? 'Номер должен содержать 11 цифр' : null,
                              errorStyle: TextStyle(color: Colors.red, fontSize: 15),
                              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                              suffixIcon: focusNode!.hasFocus ? SizedBox(
                                  child:Container(
                                    height: 40,
                                    width: 40,
                                    child: IconButton(
                                        onPressed: (){
                                          _phoneNumberTextController!.clear();
                                          setState(() {
                                            isDisabled = true;
                                          });
                                        },
                                        icon: Icon(CupertinoIcons.clear_thick_circled, color: Colors.grey)
                                    ),
                                  )
                              ) : null,
                              suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromRGBO(145, 10, 251, 5))
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)
                              )
                          ),
                          onTap: () {
                            FocusScope.of(context).requestFocus(focusNode);
                          },
                          onChanged: (value) {
                            if(value.length != 15 || value == ''){
                              setState(() {
                                validate = true;
                                isDisabled = true;
                              });
                            }else{
                              setState(() {
                                validate = false;
                                isDisabled = false;
                              });
                            }
                          },
                        )
                      ],
                    )
                ),
              ],
            ),
          ),
          SizedBox(height: height / 20),
          Container(
              padding: EdgeInsets.only(bottom: width / 100),
              alignment: Alignment.center,
              width: 300,
              height: 50,
              child: Material(
                borderRadius: BorderRadius.circular(11),
                color: Color.fromRGBO(145, 10, 251, 5),
                child: InkWell(
                  onTap: isDisabled == false ? (){
                    Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => ConfirmNewPhoneNumberPage())
                    );
                  } : null,
                  child: Container(
                    child: Center(child: Text('Продолжить', style: TextStyle(
                        color: Colors.white.withOpacity(0.9), fontSize: 17))),
                  ),
                ),
              )
          )
        ],
      ),
    );
  }
}