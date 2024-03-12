class packageModel {
  String? silver;
  String? gold;
  String? platinum;
  int? uid;

  packageModel({
    this.silver,
    this.gold,
    this.platinum,
    this.uid,
  });

  Map<String, dynamic> toJson() {
    return {
      "silver": silver,
      "gold": gold,
      "platinum": platinum,
      "uid": uid,
    };
  }

  factory packageModel.fromJson(Map<String, dynamic> json) {
    return packageModel(
      silver: json["silver"] ?? "",
      gold: json["gold"] ?? "",
      platinum: json["platinum"] ?? "",
      uid: json["uid"] ?? "",
    );
  }
}
