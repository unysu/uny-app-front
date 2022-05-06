// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uny_app_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$UnyAPI extends UnyAPI {
  _$UnyAPI([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = UnyAPI;

  @override
  Future<Response<AuthModel>> auth(dynamic data) {
    final $url = '/auth';
    final $body = data;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<AuthModel, AuthModel>($request);
  }

  @override
  Future<Response<UserDataModel>> confirmCode(dynamic data) {
    final $url = '/login';
    final $body = data;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<UserDataModel, UserDataModel>($request);
  }

  @override
  Future<Response<AuthModel>> resendSMS(dynamic data) {
    final $url = '/resend_sms';
    final $body = data;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<AuthModel, AuthModel>($request);
  }

  @override
  Future<Response<AuthModel>> removeAccount(String token) {
    final $url = '/user/remove_account';
    final $headers = {
      'Authorization': token,
    };

    final $request = Request('POST', $url, client.baseUrl, headers: $headers);
    return client.send<AuthModel, AuthModel>($request);
  }
}
