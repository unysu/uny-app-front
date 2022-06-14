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

  @override
  Future<Response<dynamic>> getInterests(String token) {
    final $url = '/user/get_interests';
    final $headers = {
      'Authorization': token,
    };

    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<UserDataModel>> updateUser(String token, dynamic data) {
    final $url = '/user/update_user';
    final $headers = {
      'Authorization': token,
    };

    final $body = data;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<UserDataModel, UserDataModel>($request);
  }

  @override
  Future<Response<AllUserDataModel>> getCurrentUser(String token) {
    final $url = '/user/get_user';
    final $headers = {
      'Authorization': token,
    };

    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<AllUserDataModel, AllUserDataModel>($request);
  }

  @override
  Future<Response<UpdatedInterestsModel>> removeInterests(
      String token, dynamic data) {
    final $url = '/user/remove_interests';
    final $headers = {
      'Authorization': token,
    };

    final $body = data;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<UpdatedInterestsModel, UpdatedInterestsModel>($request);
  }

  @override
  Future<Response<PhotoSearchDataModel>> getUserPhotoSearch(
      String token, dynamic data) {
    final $url = '/user/filter_match_users_with_percent';
    final $headers = {
      'Authorization': token,
    };

    final $body = data;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<PhotoSearchDataModel, PhotoSearchDataModel>($request);
  }

  @override
  Future<Response<dynamic>> uploadMedia(String token, dynamic data) {
    final $url = '/user/upload_media';
    final $headers = {
      'Authorization': token,
    };

    final $body = data;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> addInterests(String token, dynamic data) {
    final $url = '/user/add_interests';
    final $headers = {
      'Authorization': token,
    };

    final $body = data;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> editAboutMe(String token, dynamic data) {
    final $url = '/user/update_user';
    final $headers = {
      'Authorization': token,
    };

    final $body = data;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateMedia(String token, dynamic data) {
    final $url = '/user/update_media';
    final $headers = {
      'Authorization': token,
    };

    final $body = data;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteMedia(String token, dynamic data) {
    final $url = '/user/remove_media';
    final $headers = {
      'Authorization': token,
    };

    final $body = data;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }
}
