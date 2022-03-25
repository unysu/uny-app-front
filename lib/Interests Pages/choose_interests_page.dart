import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class InterestsPage extends StatefulWidget{

  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage>{

  late double height;
  late double width;

  bool _isSearching = false;

  bool _isFamilyEnabled = true;
  bool _isCareerEnabled = false;
  bool _isSportEnabled = false;
  bool _isTravelingEnabled = false;
  bool _isGeneralEnabled = false;


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
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Container(
                  height: height / 20,
                  padding: EdgeInsets.only(right: width / 20),
                  child: TextFormField(
                    cursorColor: Color.fromRGBO(145, 10, 251, 5),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: height / 50),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      prefixIcon: _isSearching != true ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.search, color: Colors.grey),
                          Text('Поиск интересов', style: TextStyle(fontSize: 17, color: Colors.grey))
                        ],
                      ) : null,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.1))
                      ),

                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.1))
                      ),
                    ),
                    onTap: (){
                      setState(() {
                        _isSearching = true;
                      });
                    },
                    onChanged: (value){
                      if(value.length == 0){
                        setState(() {
                          _isSearching = false;
                        });
                      }else{
                        setState(() {
                          _isSearching = true;
                        });
                      }
                    },
                  ),
                ),
                centerTitle: true,
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

  Widget mainBody(){
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: height / 7, left: width / 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      child: Image.asset('assets/unlocked.png'),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text('Семья', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    SizedBox(width: 5),
                    Container(
                      width: width / 8,
                      height: 2,
                      color: _isCareerEnabled ? Colors.green : Colors.grey.withOpacity(0.5),
                    ),
                    SizedBox(width: 5)
                  ],
                ),
                Row(
                  children: [
                    _isCareerEnabled ? Container(
                      height: 35,
                      width: 35,
                      child: Image.asset('assets/unlocked.png'),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.lightBlue,
                      ),
                    ) : Icon(CupertinoIcons.lock_circle_fill, color: Colors.grey, size: 40),
                    SizedBox(width: 5),
                    Text('Карьера', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    SizedBox(width: 5),
                    Container(
                      width: width / 8,
                      height: 2,
                      color: _isCareerEnabled ? Colors.lightBlue : Colors.grey.withOpacity(0.5),
                    ),
                    SizedBox(width: 5),
                  ],
                ),
                Row(
                  children: [
                    _isSportEnabled ? Container(
                      height: 35,
                      width: 35,
                      child: Image.asset('assets/unlocked.png'),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueAccent,
                      ),
                    ) : Icon(CupertinoIcons.lock_circle_fill, color: Colors.grey, size: 40),
                    SizedBox(width: 5),
                    Text('Спорт', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    SizedBox(width: 5),
                    Container(
                      width: width / 8,
                      height: 2,
                      color: _isCareerEnabled ? Colors.blueAccent : Colors.grey.withOpacity(0.5),
                    )
                  ],
                ),
                Row(
                  children: [
                    _isTravelingEnabled ? Container(
                      height: 35,
                      width: 35,
                      child: Image.asset('assets/unlocked.png'),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueAccent,
                      ),
                    ) : Icon(CupertinoIcons.lock_circle_fill, color: Colors.grey, size: 40),
                    SizedBox(width: 5),
                    Text('Путешествия', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    SizedBox(width: 5),
                    Container(
                      width: width / 8,
                      height: 2,
                      color: _isCareerEnabled ? Colors.blueAccent : Colors.grey.withOpacity(0.5),
                    ),
                    SizedBox(width: 5),
                  ],
                ),
                Row(
                  children: [
                    _isGeneralEnabled ? Container(
                      height: 35,
                      width: 35,
                      child: Image.asset('assets/unlocked.png'),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.deepPurpleAccent,
                      ),
                    ) : Icon(CupertinoIcons.lock_circle_fill, color: Colors.grey, size: 40),
                    SizedBox(width: 5),
                    Text('Общее', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    SizedBox(width: 5),
                  ],
                ),
              ],
            ),
          )
        ),
        SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: width * 0.78,
              height: 26,
              padding: EdgeInsets.only(left: width / 20),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.green[100],
                  color: Colors.green,
                  value: 0.5,
                ),
              )
            ),
            Container(
              height: 50,
              width: 100,
              child: Center(
                child: Text('Далее', style: TextStyle(fontSize: 15, color: Colors.white)),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.deepPurpleAccent,
                    Colors.blue
                  ]
                )
              ),
            )
          ],
        ),
        SizedBox(height: height / 25),
        Center(
          child: Text(
              'Выберите минимум один интерес для продолжения',
            style: TextStyle(fontSize: 15, color: Colors.grey.withOpacity(0.7)),
          ),
        ),
        SizedBox(height: height / 100),
        Divider(
          thickness: 1,
          color: Colors.grey.withOpacity(0.5),
        )
      ],
    );
  }
}