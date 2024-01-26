class ExerciseData {
  int? id;
  String? name;
  String? improvement;
  String? type;
  String? explanation;
  String? image;
  String? audio;
  String? video;
  int? deleted;
  int? made;
  String? createdAt;
  String? updatedAt;

  ExerciseData({
    this.id,
    this.name,
    this.improvement,
    this.type,
    this.explanation,
    this.image,
    this.audio,
    this.video,
    this.deleted,
    this.made,
    this.createdAt,
    this.updatedAt,
  });

  ExerciseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    improvement = json['improvement'];
    type = json['type'];
    explanation = json['explanation'];
    image = json['image'];
    audio = json['audio'];
    video = json['video'];
    deleted = json['deleted'];
    made = json['made'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['improvement'] = improvement;
    data['type'] = type;
    data['explanation'] = explanation;
    data['image'] = image;
    data['audio'] = audio;
    data['video'] = video;
    data['deleted'] = deleted;
    data['made'] = made;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ExerciseResponse {
  bool? success;
  List<ExerciseData>? data;
  String? message;

  ExerciseResponse({this.success, this.data, this.message});

  ExerciseResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ExerciseData>[];
      json['data'].forEach((v) {
        data!.add(ExerciseData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}
