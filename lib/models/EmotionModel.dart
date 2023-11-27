class Emotions {
  bool? success;
  List<EmotionData>? data;
  String? message;

  Emotions({this.success, this.data, this.message});

  Emotions.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <EmotionData>[];
      json['data'].forEach((v) {
        data!.add(EmotionData.fromJson(v));
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

class EmotionData {
  int? id;
  String? type;
  String? name;
  int? userId;
  String? description;
  String? image;
  DateTime? date;
  int? deleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  EmotionData(
      {this.id,
      this.type,
      this.name,
      this.userId,
      this.description,
      this.image,
      this.date,
      this.deleted,
      this.createdAt,
      this.updatedAt});

  EmotionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    userId = json['userId'];
    description = json['description'];
    image = json['image'];
    date = json['date'];
    deleted = json['deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['name'] = name;
    data['userId'] = userId;
    data['description'] = description;
    data['image'] = image;
    data['date'] = date;
    data['deleted'] = deleted;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
