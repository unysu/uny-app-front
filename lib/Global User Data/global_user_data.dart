import 'package:uny_app/Data%20Models/User%20Data%20Model/all_user_data_model.dart';

class GlobalUserData{

  static AllUserDataModel? _userDataModel;


  static updateModel(AllUserDataModel? allUserDataModel){
    _userDataModel = allUserDataModel;
  }

  static AllUserDataModel? getUserDataModel(){
    return _userDataModel;
  }
}