import 'package:chopper/chopper.dart';

part 'uny_app_api.chopper.dart';

@ChopperApi()
abstract class UnyAPI extends ChopperService{

  static UnyAPI api(){
    JsonConverter? converter;

    final client = ChopperClient(
      baseUrl: 'http://54.209.251.199/api',
      services: [_$UnyAPI()],
      converter: converter
    );

    return _$UnyAPI(client);
  }
}