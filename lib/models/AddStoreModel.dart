class AddStoreModel {
  String? name;
  String? image;
  int? uid;

  AddStoreModel({
    this.name,
    this.image,
    this.uid,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "image": image,
      "uid": uid,
    };
  }

  factory AddStoreModel.fromJson(Map<String, dynamic> json) {
    return AddStoreModel(
      name: json["name"] ?? "",
      image: json["image"] ?? "",
      uid: json["uid"] ?? "",
    );
  }
}
