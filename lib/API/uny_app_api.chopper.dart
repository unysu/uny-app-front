// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uny_app_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
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
  Future<Response<PhotoSearchDataModel>> searchUserByName(
      String token, dynamic data) {
    final $url = '/user/search_by_name';
    final $headers = {
      'Authorization': token,
    };

    final $body = data;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<PhotoSearchDataModel, PhotoSearchDataModel>($request);
  }

  @override
  Future<Response<FilterUserDataModel>> filterUsers(
      String token, dynamic data) {
    final $url = '/user/search_user';
    final $headers = {
      'Authorization': token,
    };

    final $body = data;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<FilterUserDataModel, FilterUserDataModel>($request);
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
  Future<Response<dynamic>> startChat(String token, dynamic data) {
    final $url = '/user/start_chat';
    final $headers = {
      'Authorization': token,
    };

    final $body = data;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<AllChatsModel>> getAllChats(String token, dynamic data) {
    final $url = '/user/get_all_messages';
    final $headers = {
      'Authorization': token,
    };

    final $body = data;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<AllChatsModel, AllChatsModel>($request);
  }

  @override
  Future<Response<RoomMessagesModel>> getRoomMessages(
      String token, int id, String date) {
    final $url = '/user/get_message_by_chat_room_id';
    final $params = <String, dynamic>{'chat_room_id': id, 'older_from': date};
    final $headers = {
      'Authorization': token,
    };

    final $request = Request('POST', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<RoomMessagesModel, RoomMessagesModel>($request);
  }

  @override
  Future<Response<Message>> sendMessage(String token, dynamic data) {
    final $url = '/user/send_message';
    final $headers = {
      'Authorization': token,
    };

    final $body = data;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<Message, Message>($request);
  }

  @override
  Future<Response<Message>> editMessage(String token, dynamic data) {
    final $url = '/user/edit_message';
    final $headers = {
      'Authorization': token,
    };

    final $body = data;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<Message, Message>($request);
  }

  @override
  Future<Response<Message>> deleteMessage(String token, dynamic data) {
    final $url = '/user/remove_message';
    final $headers = {
      'Authorization': token,
    };

    final $body = data;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<Message, Message>($request);
  }

  @override
  Future<Response<Message>> clearChat(String token, dynamic data) {
    final $url = '/user/remove_chat_room_messages';
    final $headers = {
      'Authorization': token,
    };

    final $body = data;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<Message, Message>($request);
  }

  @override
  Future<Response<dynamic>> deleteChatRoom(String token, dynamic data) {
    final $url = '/user/remove_chat_room';
    final $headers = {
      'Authorization': token,
    };

    final $body = data;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Matches>> getUserById(String token, String userId) {
    final $url = '/user/get_user_by_id';
    final $params = <String, dynamic>{'user_id': userId};
    final $headers = {
      'Authorization': token,
    };

    final $request = Request('POST', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<Matches, Matches>($request);
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
  Future<Response<AllUserDataModel>> getCurrentUser(String token) {
    final $url = '/user/get_user';
    final $headers = {
      'Authorization': token,
    };

    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<AllUserDataModel, AllUserDataModel>($request);
  }

  @override
  Future<Response<MediaDataModel>> getMedia(String token) {
    final $url = '/user/get_all_media';
    final $headers = {
      'Authorization': token,
    };

    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<MediaDataModel, MediaDataModel>($request);
  }
}
