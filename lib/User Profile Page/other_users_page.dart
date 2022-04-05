import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_platform/universal_platform.dart';

class OtherUsersPage extends StatefulWidget{

  @override
  _OtherUsersPage createState() => _OtherUsersPage();
}

class _OtherUsersPage extends State<OtherUsersPage>{

  late double height;
  late double width;

  FToast? _fToast;

  @override
  void initState() {
    super.initState();

    _fToast = FToast();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _fToast!.init(context);
    });
  }

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
                centerTitle: false,
                titleSpacing: 1,
                toolbarHeight: 100,
                title: Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Кристина З. 25',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      Text('Основатель Uny')
                    ],
                  ),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: IconButton(
                        icon: Icon(Icons.more_horiz),
                        onPressed: (){
                          showActionsSheet();
                        },
                      )
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: mainBody(),
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
      },
    );
  }

  Widget mainBody(){
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(100),
          ),
          child: Container(
            height: height * 0.43,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/user_pic.png'),
                fit: BoxFit.cover
              )
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(100)
          ),
          child: Container(
            height: height,
          ),
        )
      ],
    );
  }

  void showActionsSheet(){
    if(UniversalPlatform.isIOS){
      showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.arrowshape_turn_up_right, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('Поделиться'),
                    ],
                  )
                ),
                CupertinoActionSheetAction(
                  onPressed: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.doc_on_doc, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('Скопировать ссылку'),
                    ],
                  )
                ),
                CupertinoActionSheetAction(
                  onPressed: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('Пожаловаться'),
                    ],
                  )
                ),
                CupertinoActionSheetAction(
                  child: Row(
                    children: [
                      Icon(Icons.block_flipped, color: Colors.red),
                      SizedBox(width: 10),
                      Text('Заблокировать', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _showToast();
                  },
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.pop(context),
                child: Text('Отмена'),
              ),
            );
          }
      );
    }else if(UniversalPlatform.isAndroid){
      showModalBottomSheet(
          context: context,
          builder: (context){
            return Wrap(
              children: [
                Column(
                  children: [
                    ListTile(
                        title: Text('Поделиться'),
                        onTap: () => Navigator.pop(context),
                        leading: Icon(CupertinoIcons.arrowshape_turn_up_right),
                    ),
                    ListTile(
                        leading: Icon(CupertinoIcons.doc_on_doc),
                        title: Text('Скопировать ссылку'),
                        onTap: () => Navigator.pop(context)
                    ),
                    ListTile(
                        leading: Icon(Icons.error_outline),
                        title: Text('Пожаловаться'),
                        onTap: () {}
                    ),
                    ListTile(
                        leading: Icon(Icons.block_flipped, color: Colors.red),
                        title: Text('Заблокировать', style: TextStyle(color: Colors.red)),
                        onTap: () {
                          Navigator.pop(context);
                          _showToast();
                        }
                    ),
                    ListTile(
                        title: Text('Отмена'),
                        onTap: () => Navigator.pop(context)
                    ),
                  ],
                )
              ],
            );
          }
      );
    }
  }


  void _showToast(){
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.black,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Пользователь заблокирован", style: TextStyle(color: Colors.white)),
          Icon(Icons.block_flipped, color: Colors.red),
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