class AdsModel {
  String? image;
  int? uid;

  AdsModel({
    this.image,
    this.uid,
  });

  Map<String, dynamic> toJson() {
    return {
      "image": image,
      "uid": uid,
    };
  }

  factory AdsModel.fromJson(Map<String, dynamic> json) {
    return AdsModel(
      image: json["image"] ?? "",
      uid: json["uid"] ?? "",
    );
  }
}
