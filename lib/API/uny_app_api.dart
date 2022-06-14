import 'package:chopper/chopper.dart';
import 'package:uny_app/Constants/constants.dart';
import 'package:uny_app/Data%20Models/Auth%20Data%20Models/auth_model.dart';
import 'package:uny_app/Data%20Models/User%20Data%20Model/all_user_data_model.dart';
import 'package:uny_app/Data%20Models/User%20Data%20Model/user_data_model.dart';
import 'package:uny_app/Json%20Converter/json_converter.dart';
import '../Data Models/Photo Search Data Model/photo_search_data_model.dart';
import '../Data Models/Updated Interests Model/updated_interests_model.dart';

part 'uny_app_api.chopper.dart';

@ChopperApi()
abstract class UnyAPI extends ChopperService{

  @Post(path: '/auth')
  Future<Response<AuthModel>> auth(@Body() var data);

  @Post(path: '/login')
  Future<Response<UserDataModel>> confirmCode(@Body() var data);

  @Post(path: '/resend_sms')
  Future<Response<AuthModel>> resendSMS(@Body() var data);

  @Post(path: '/user/remove_account')
  Future<Response<AuthModel>> removeAccount(@Header('Authorization') String token);

  @Get(path: '/user/get_interests')
  Future<Response> getInterests(@Header('Authorization') String token);

  @Post(path: '/user/update_user')
  Future<Response<UserDataModel>> updateUser(@Header('Authorization') String token, @Body() var data);

  @Get(path: '/user/get_user')
  Future<Response<AllUserDataModel>> getCurrentUser(@Header('Authorization') String token);

  @Post(path: '/user/remove_interests')
  Future<Response<UpdatedInterestsModel>> removeInterests(@Header('Authorization') String token, @Body() var data);

  @Post(path: '/user/filter_match_users_with_percent')
  Future<Response<PhotoSearchDataModel>> getUserPhotoSearch(@Header('Authorization') String token, @Body() var data);

  @Post(path: '/user/upload_media')
  Future<Response> uploadMedia(@Header('Authorization') String token, @Body() var data);

  @Post(path: '/user/add_interests')
  Future<Response> addInterests(@Header('Authorization') String token, @Body() var data);

  @Post(path: '/user/update_user')
  Future<Response> editAboutMe(@Header('Authorization') String token, @Body() var data);

  @Post(path: '/user/update_media')
  Future<Response> updateMedia(@Header('Authorization') String token, @Body() var data);

  @Post(path: '/user/remove_media')
  Future<Response> deleteMedia(@Header('Authorization') String token, @Body() var data);


  static UnyAPI create(String converterCode){
    JsonConverter? converter;

    switch(converterCode){
      case Constants.SIMPLE_RESPONSE_CONVERTER:
        converter = JsonConverter();
        break;
      case Constants.AUTH_MODEL_CONVERTER_CONSTANT:
        converter = JsonToTypeConverter({
          AuthModel: (json) => AuthModel.fromJson(json)
        });
        break;
      case Constants.USER_DATA_MODEL_CONVERTER_CONSTANT:
        converter = JsonToTypeConverter({
          UserDataModel: (json) => UserDataModel.fromJson(json)
        });
        break;
      case Constants.ALL_USER_DATA_MODEL_CONVERTER_CONSTANT:
        converter = JsonToTypeConverter({
          AllUserDataModel: (json) => AllUserDataModel.fromJson(json)
        });
        break;
      case Constants.INTERESTS_MODEL_CONVERTER:
        converter = JsonToTypeConverter({
          UpdatedInterestsModel: (json) => UpdatedInterestsModel.fromJson(json)
        });
        break;
      case Constants.PHOTO_SEARCH_MODEL_CONVERTER:
        converter = JsonToTypeConverter({
          PhotoSearchDataModel: (json) => PhotoSearchDataModel.fromJson(json)
        });
        break;
    }

    final client = ChopperClient(
      baseUrl: 'http://54.209.251.199/api',
      services: [_$UnyAPI()],
      converter: converter
    );

    return _$UnyAPI(client);
  }
}