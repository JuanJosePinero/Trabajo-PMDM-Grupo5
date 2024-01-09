class ExerciceData {
  int? id;
  String? name;
  String? improvement;
  String? type;
  String? explanation;
  String? image;
  String? audio;
  String? video;
  int? deleted;
  String? createdAt;
  String? updatedAt;

  ExerciceData({
    this.id,
    this.name,
    this.improvement,
    this.type,
    this.explanation,
    this.image,
    this.audio,
    this.video,
    this.deleted,
    this.createdAt,
    this.updatedAt,
  });

  ExerciceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    improvement = json['improvement'];
    type = json['type'];
    explanation = json['explanation'];
    image = json['image'];
    audio = json['audio'];
    video = json['video'];
    deleted = json['deleted'];
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
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ExerciceResponse {
  bool? success;
  List<ExerciceData>? data;
  String? message;

  ExerciceResponse({this.success, this.data, this.message});

  ExerciceResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ExerciceData>[];
      json['data'].forEach((v) {
        data!.add(ExerciceData.fromJson(v));
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
