class ElementData {
  int? id;
  String? type;
  String? name;
  int? userId;
  String? description;
  String? image;
  String? date;
  String? createdAt;

  ElementData({
    this.id,
    this.type,
    this.name,
    this.userId,
    this.description,
    this.image,
    this.date,
    this.createdAt,
  });

  ElementData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    userId = json['user_id'];
    description = json['description'];
    image = json['image'];
    date = json['date'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['name'] = name;
    data['user_id'] = userId;
    data['description'] = description;
    data['image'] = image;
    data['date'] = date;
    data['created_at'] = createdAt;
    return data;
  }
}

class ElementResponse {
  bool? success;
  List<ElementData>? data;
  String? message;

  ElementResponse({this.success, this.data, this.message});

  ElementResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ElementData>[];
      json['data'].forEach((v) {
        data!.add(ElementData.fromJson(v));
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