import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uny_app/Authorization%20Pages/authorization_page.dart';


void main() {
  runApp(const MaterialApp(
    home: SplashScreenPage(),
  ));
}

class SplashScreenPage extends StatefulWidget{
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>{

 @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthorizationPage())
        )
     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
            width: 150,
            height: 150,
            child: Image.asset('assets/logo.png')
        ),
      )
    );
  }
}




