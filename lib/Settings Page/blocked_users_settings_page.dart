import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';

class BlockedUsersSettingsPage extends StatefulWidget{

  @override
  _BlockedUsersSettingsPageState createState() => _BlockedUsersSettingsPageState();
}

class _BlockedUsersSettingsPageState extends State<BlockedUsersSettingsPage>{

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
            appBar: AppBar(
              elevation: 0,
              centerTitle: false,
              systemOverlayStyle: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
              backgroundColor: Colors.grey.withOpacity(0),
              title: Text('Черный список', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light ? Colors.grey : Colors.white),
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
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue
                  ),
                ),
                Text('Анастасия К.', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                Container(
                  height: height / 24,
                  width: width / 3,
                  child: Center(
                    child: Text('Разблокировать', style: TextStyle(fontSize: 15)),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(
                          color: Colors.grey,
                          width: 0.5
                      )
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        );
      }
    );
  }
}