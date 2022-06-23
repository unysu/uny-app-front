import 'package:flutter/cupertino.dart';
import 'package:uny_app/Data%20Models/Interests%20Data%20Model/interests_data_model.dart';
import 'package:uny_app/Data%20Models/Media%20Data%20Model/media_data_model.dart';
import 'package:uny_app/Data%20Models/User%20Data%20Model/user_data_model.dart';

class UserDataProvider extends ChangeNotifier{

  UserDataModel? _userDataModel;
  MediaDataModel? _mediaDataModel;

  List<InterestsDataModel>? _interestsDataModel;

  UserDataModel? get userDataModel => _userDataModel;
  MediaDataModel? get mediaDataModel => _mediaDataModel;

  List<InterestsDataModel>? get interestsDataModel => _interestsDataModel;

  void setUserDataModel(UserDataModel? dataModel){
    _userDataModel = dataModel;

    notifyListeners();
  }

  void setMediaDataModel(MediaDataModel? _mediaDataModelList){
    if(_mediaDataModelList != null){
      _mediaDataModel = _mediaDataModelList;
    }

    notifyListeners();
  }

  void setInterestsDataModel(List<InterestsDataModel>? _interestsDataModelList){
    _interestsDataModel = _interestsDataModelList;

    notifyListeners();
  }
}