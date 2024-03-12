class AddCollectionModel {
  String? name;
  String? silver;
  String? gold;
  String? platinum;
  String? image;
  int? uid;

  AddCollectionModel({
    this.name,
    this.silver,
    this.gold,
    this.platinum,
    this.image,
    this.uid,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "silver": silver,
      "gold": gold,
      "platinum": platinum,
      "image": image,
      "uid": uid,
    };
  }

  factory AddCollectionModel.fromJson(Map<String, dynamic> json) {
    return AddCollectionModel(
      name: json["name"] ?? "",
      silver: json["silver"] ?? "",
      gold: json["gold"] ?? "",
      platinum: json["platinum"] ?? "",
      image: json["image"] ?? "",
      uid: json["uid"] ?? "",
    );
  }
}
