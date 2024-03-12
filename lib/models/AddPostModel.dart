class AddPostModel {
  String description;
  String image;
  String name;
  String date;
  int uid;
  int commentCount;
  int likeCount;
  List<String> likedBy;
  List<String> commentList; // Add commentList property

  AddPostModel({
    required this.description,
    required this.image,
    required this.name,
    required this.date,
    required this.commentCount,
    required this.uid,
    required this.likeCount,
    required this.commentList, // Update the constructor to include commentList
    required this.likedBy,
  });

  factory AddPostModel.fromJson(Map<String, dynamic> json) {
    return AddPostModel(
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      commentCount:
          json['commentCount'] ?? 0, // Provide a default value for commentCount
      uid: json['uid'] is int ? json['uid'] : 0,
      likeCount: _parseLikeCount(json['likeCount']),
      likedBy: List<String>.from(json['likedBy'] ?? []),
      commentList:
          List<String>.from(json['commentList'] ?? []), // Parse commentList
    );
  }

  static int _parseLikeCount(dynamic likeCount) {
    if (likeCount is int) {
      return likeCount;
    } else if (likeCount is String) {
      try {
        return int.parse(likeCount);
      } catch (e) {
        return 0;
      }
    } else {
      return 0;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'image': image,
      'name': name,
      'date': date,
      'uid': uid,
      'likeCount': likeCount,
      'likedBy': likedBy,
      'commentCount': commentCount,
      'commentList': commentList, // Include commentList in the JSON output
    };
  }
}
