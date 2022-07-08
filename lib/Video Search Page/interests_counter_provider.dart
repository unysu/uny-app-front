import 'package:flutter/material.dart';

class InterestsCounterProvider extends ChangeNotifier {

  int _counter = 0;
  bool _isPlaying = true;

  int get counter => _counter;
  bool get isPlaying => _isPlaying;


  void setPlay(bool play){
    _isPlaying = play;

    notifyListeners();
  }


  void incrementCounter(){
    _counter++;

    notifyListeners();
  }

  void decrementCounter(){

    _counter--;

    notifyListeners();
  }

  void resetCounter(){
    _counter = 0;

    notifyListeners();
  }

}