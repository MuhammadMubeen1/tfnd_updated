class AddEventModel {
  String? image;
  String? name;
  String? address;
  String? discription;

  String? slot;
  String? price;
  String? Location;

  String? longitude;
  String? latitude;
  String? date;
  String? time;
  String? remaining;

  int? uid;

  AddEventModel({
    this.image,
    this.slot,
    this.remaining,
    this.price,
    this.Location,
    this.name,
    this.address,
    this.discription,
    this.longitude,
    this.latitude,
    this.date,
    this.time,
    this.uid,
  });

  Map<String, dynamic> toJson() {
    return {
      "slot": slot,
      "remaining": remaining,
      "price": price,
      "location": Location,
      "image": image,
      "discription": discription,
      "name": name,
      "address": address,
      "longitude": longitude,
      "latitude": latitude,
      "date": date,
      "time": time,
      "uid": uid,
    };
  }

  factory AddEventModel.fromJson(Map<String, dynamic> json) {
    return AddEventModel(
      slot: json["slot"] ?? "",
      price: json["price"] ?? "",
      remaining: json["remaining"] ?? "",
      Location: json["location"] ?? "",
      image: json["image"] ?? "",
      name: json["name"] ?? "",
      address: json["address"] ?? "",
      longitude: json["longitude"] ?? "",
      latitude: json["latitude"] ?? "",
      discription: json["discription"] ?? "",
      date: json["date"] ?? "",
      time: json["time"] ?? "",
      uid: json["uid"] ?? "",
    );
  }
}
