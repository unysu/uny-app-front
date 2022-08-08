import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';

class SupportPage extends StatefulWidget{

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage>{

  late double height;
  late double width;

  TextEditingController? _topicTextController;
  TextEditingController? _emailTextController;
  TextEditingController? _problemTextController;

  @override
  void initState() {
    super.initState();

    _topicTextController = TextEditingController();
    _emailTextController = TextEditingController();
    _problemTextController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    _topicTextController!.dispose();
    _emailTextController!.dispose();
    _problemTextController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        return ResponsiveWrapper.builder(
          Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0,
              centerTitle: false,
              systemOverlayStyle: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
              backgroundColor: Colors.grey.withOpacity(0),
              title: Text('Оставить обращение', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Colors.black : Colors.white)),
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Colors.grey : Colors.white),
              ),
            ),
            body: SingleChildScrollView(
              child: mainBody(),
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

  Widget mainBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width / 20),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: height / 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Основная информация', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                Container(
                    padding: EdgeInsets.only(top: height / 50),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _topicTextController,
                          cursorColor: Color.fromRGBO(145, 10, 251, 5),
                          style: TextStyle(color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Colors.black : Colors.white),
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText: 'Тема обращения',
                            hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
                            fillColor: Colors.grey.withOpacity(0.3),
                            filled: true,
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
                          controller: _emailTextController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          cursorColor: Color.fromRGBO(145, 10, 251, 5),
                          style: TextStyle(color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Colors.black : Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Ваш email',
                            hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
                            fillColor: Colors.grey.withOpacity(0.3),
                            filled: true,
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
                SizedBox(height: height / 30),
                Text('Основная информация', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(height: height / 80),
                Container(
                  child: TextFormField(
                    controller: _problemTextController,
                    cursorColor: Color.fromRGBO(145, 10, 251, 5),
                    textInputAction: TextInputAction.done,
                    style: TextStyle(color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Colors.black : Colors.white),
                    maxLines: 15,
                    decoration: InputDecoration(
                      hintText: 'Опишите здесь вашу проблему',
                      fillColor: Colors.grey.withOpacity(0.2),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height / 35),
                Container(
                  height: height / 18,
                  child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.attach_file, color: Color.fromRGBO(145, 10, 251, 5)),
                          SizedBox(width: 5),
                          Text('Прикрепить файл', style: TextStyle(fontSize: 17))
                        ],
                      )
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(
                          color: Colors.grey,
                          width: 0.5
                      )
                  ),
                ),
                SizedBox(height: height / 15),
                InkWell(
                  onTap: () => null,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: Container(
                        width: 400,
                        height: 50,
                        color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Color.fromRGBO(145, 10, 251, 5) : Colors.purpleAccent,
                        child: Center(
                          child: Text('Отправить', style: TextStyle(
                              color: Colors.white, fontSize: 17)),
                        )
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text.rich(
                  TextSpan(
                    text: 'Нажимая "Отправить", вы подтверждаете согласие с ',
                    children: const [
                      TextSpan(
                          text: 'условиями использования UnyApp',
                          style: TextStyle(color: Colors.blue)
                      )
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}