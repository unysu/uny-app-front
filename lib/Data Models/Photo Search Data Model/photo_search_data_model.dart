import 'package:json_annotation/json_annotation.dart';

import '../Interests Data Model/interests_data_model.dart';
import '../Media Data Model/media_data_model.dart';

part 'photo_search_data_model.g.dart';

@JsonSerializable()
class PhotoSearchDataModel{

  @JsonKey(name: 'success')
  var success;

  @JsonKey(name: 'matches')
  List<Matches>? matches;

  PhotoSearchDataModel({
    this.success,
    this.matches
  });

  PhotoSearchDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['matches'] != null) {
      matches = <Matches>[];
      json['matches'].forEach((v) {
        matches!.add(Matches.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (matches != null) {
      data['matches'] = matches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


@JsonSerializable()
class Matches{

  @JsonKey(name: 'id')
  var id;

  @JsonKey(name: 'first_name')
  var firstName;

  @JsonKey(name: 'last_name')
  var lastName;

  @JsonKey(name: 'age')
  var age;

  @JsonKey(name: 'gender')
  var gender;

  @JsonKey(name: 'location')
  var location;

  @JsonKey(name: 'zodiac_sign')
  var zodiacSign;

  @JsonKey(name: 'date_of_birth')
  var dateOfBirth;

  @JsonKey(name: 'match_percent')
  var matchPercent;

  @JsonKey(name: 'about_me')
  var aboutMe;

  @JsonKey(name: 'job')
  var job;

  @JsonKey(name: 'company')
  var company;

  @JsonKey(name: 'media')
  MediaDataModel? media;

  @JsonKey(name: 'interests')
  List<InterestsDataModel>? interests;

  Matches({
    this.id,
    this.firstName,
    this.lastName,
    this.age,
    this.gender,
    this.location,
    this.zodiacSign,
    this.dateOfBirth,
    this.aboutMe,
    this.interests,
    this.media,
    this.matchPercent
  });


  factory Matches.fromJson(Map<String, dynamic> json) => _$MatchesFromJson(json);

  Map<String, dynamic> toJson() => _$MatchesToJson(this);

}