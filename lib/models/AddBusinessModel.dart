class AddBusinessModel {
  String? name;
  String? category;
  String? description;
  String? discount;
  String? image;
  String? date;
  int? uid;
  String? email;

  AddBusinessModel({
    this.category,
    this.name,
    this.email,
    this.description,
    this.discount,
    this.image,
    this.date,
    this.uid,
  });

  Map<String, dynamic> toJson() {
    return {
      "category": category,
      "email": email,
      "name": name,
      "description": description,
      "discount": discount,
      "image": image,
      "date": date,
      "uid": uid,
    };
  }

  factory AddBusinessModel.fromJson(Map<String, dynamic> json) {
    return AddBusinessModel(
      category: json["category"] ?? "",
      email: json["email"] ?? '',
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      discount: json["discount"] ?? "",
      image: json["image"] ?? "",
      date: json["date"] ?? "",
      uid: json["uid"] ?? "",
    );
  }
}
