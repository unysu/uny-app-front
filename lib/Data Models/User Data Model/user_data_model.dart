import 'package:json_annotation/json_annotation.dart';

part 'user_data_model.g.dart';

@JsonSerializable()
class UserDataModel{

  @JsonKey(name: 'success')
  var success;

  @JsonKey(name: 'token')
  var token;

  @JsonKey(name: 'phone_number')
  var phoneNumber;

  @JsonKey(name: 'id')
  var id;

  @JsonKey(name: 'first_name')
  var firstName;

  @JsonKey(name: 'last_name')
  var lastName;

  @JsonKey(name: 'location')
  var location;

  @JsonKey(name: 'date_of_birth')
  var dateOfBirth;

  @JsonKey(name: 'about_me')
  var aboutMe;

  @JsonKey(name: 'gender')
  var gender;

  @JsonKey(name: 'who_can_see')
  var whoCanSee;

  @JsonKey(name: 'job')
  var job;

  @JsonKey(name: 'job_company')
  var jobCompany;

  @JsonKey(name: 'mute_notifications')
  var muteNotifications;

  @JsonKey(name: 'mute_request_messaging_notifications')
  var muteRequestMessagingNotifications;

  @JsonKey(name: 'mute_messages_notifications')
  var muteMessagesNotifications;

  UserDataModel({
     this.success,
     this.token,
     this.phoneNumber,
     this.id,
     this.firstName,
     this.lastName,
     this.location,
     this.dateOfBirth,
     this.aboutMe,
     this.gender,
     this.whoCanSee,
     this.job,
     this.jobCompany,
     this.muteNotifications,
     this.muteMessagesNotifications,
     this.muteRequestMessagingNotifications
  });


  factory UserDataModel.fromJson(Map<String, dynamic> json) => _$UserDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataModelToJson(this);

}