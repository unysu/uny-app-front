import 'package:flutter/material.dart';

class ChatCounterProvider extends ChangeNotifier{

  int _chatCount = 0;
  List<bool>? _selectedMessagesList;


  int get chatCount => _chatCount;
  List<bool> get selectedMessagesList => _selectedMessagesList!;


  void setCheckBoxList(List<bool>? selectedMessagesList){
    _selectedMessagesList = selectedMessagesList;

    notifyListeners();
  }

  void changeSelectedMessageValue(int index, bool value){
    _selectedMessagesList![index] = value;

    notifyListeners();
  }

  bool getMessageIndexValue(int index){
    return _selectedMessagesList![index];
  }


  void addCount(){

    _chatCount++;

    notifyListeners();
  }


  void decrementCount(){

    _chatCount--;

    notifyListeners();
  }


  void resetCount(){
    _chatCount = 0;

    notifyListeners();
  }


}