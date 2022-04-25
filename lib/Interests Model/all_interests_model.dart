class AllInterestsModel{

  String? name;
  String? color;

  AllInterestsModel(this.name, this.color);
  AllInterestsModel._(this.name, this.color);

  factory AllInterestsModel.fromJson(Map<String, dynamic> json) =>
      AllInterestsModel._(
          json['name'],
          json['color']
      );
}