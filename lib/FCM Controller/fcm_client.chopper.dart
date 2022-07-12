// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_client.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$FCMClient extends FCMClient {
  _$FCMClient([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = FCMClient;

  @override
  Future<Response<dynamic>> notify(dynamic data) {
    final $url = '/fcm/send';
    final $headers = {
      'Authorization':
          'key=AAAA7snOl3w:APA91bFkFfPKwfNHGHjWZztNSoJEN9Z21l-YOQzz8YGn9rMImD7ujteGG3XVET38zLH_5CvxUj5AoGRMAipf17TZ6x8aJTJbA_gs3XSybzkwJyrueDFx8kG151I0SLijihDjD_3h9pvq',
      'Content-Type': 'text/plain',
    };

    final $body = data;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }
}
