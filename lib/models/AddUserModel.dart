class AddUserModel {
  String? name;
  String? email;
  String? password;
  String? phoneNumber;
  String? image;
  String? isBusiness;

  String? subscription;
  int? uid;

  AddUserModel({
    this.email,
    this.name,
    this.password,
    this.phoneNumber,
    this.image,
    this.isBusiness,
    this.subscription,
    this.uid,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "name": name,
      "password": password,
      "phoneNumber": phoneNumber,
      "image": image,
      "isBusiness": isBusiness,
      "subscription": subscription,
      "uid": uid,
    };
  }

  factory AddUserModel.fromJson(Map<String, dynamic> json) {
    return AddUserModel(
      email: json["email"] ?? "",
      name: json["name"] ?? "",
      password: json["password"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      image: json["image"] ?? "",
      isBusiness: json["isBusiness"] ?? "",
      subscription: json["subscription"] ?? "",
      uid: json["uid"] ?? "",
    );
  }
}
