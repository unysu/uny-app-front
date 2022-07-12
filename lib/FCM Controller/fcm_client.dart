import 'package:chopper/chopper.dart';

part 'fcm_client.chopper.dart';

@ChopperApi()
abstract class FCMClient extends ChopperService{

  static const String _key = 'AAAA7snOl3w:APA91bFkFfPKwfNHGHjWZztNSoJEN9Z21l-YOQzz8YGn9rMImD7ujteGG3XVET38zLH_5CvxUj5AoGRMAipf17TZ6x8aJTJbA_gs3XSybzkwJyrueDFx8kG151I0SLijihDjD_3h9pvq';

  @Post(path: '/fcm/send', headers: {
    'Authorization' : 'key=$_key',
    'Content-Type' : 'text/plain'
  })
  Future<Response> notify(@Body() var data);

  static FCMClient create(){
    final client = ChopperClient(
      baseUrl: 'https://fcm.googleapis.com',
      services: [_$FCMClient()],
      converter: const JsonConverter(),
    );

    return _$FCMClient(client);
  }
}