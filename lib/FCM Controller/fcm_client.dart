import 'package:chopper/chopper.dart';

part 'fcm_client.chopper.dart';

@ChopperApi()
abstract class FCMClient extends ChopperService{

  @Post(path: '/fcm/send', headers: {'Content-Type' : 'text/plain'})
  Future<Response> notify(@Header('Authorization') String key, @Body() var data);

  static FCMClient create(){
    final client = ChopperClient(
      baseUrl: 'https://fcm.googleapis.com',
      services: [_$FCMClient()],
      converter: const JsonConverter(),
    );

    return _$FCMClient(client);
  }
}