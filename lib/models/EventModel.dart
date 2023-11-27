class Events {
  bool? success;
  List<EventData>? data;
  String? message;

  Events({this.success, this.data, this.message});

  Events.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <EventData>[];
      json['data'].forEach((v) {
        data!.add(EventData.fromJson(v));
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

class EventData {
  int? id;
  String? type;
  String? name;
  int? userId;
  String? description;
  String? image;
  DateTime? date;
  int? deleted;
  DateTime? createdAt;
  DateTime? dupdatedAt;

  EventData({
    this.id,
    this.type,
    this.name,
    this.userId,
    this.description,
    this.image,
    this.date,
    this.deleted,
    this.createdAt,
    this.dupdatedAt,
  });

  EventData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    userId = json['userId'];
    description = json['description'];
    image = json['image'];
    date = json['date'];
    deleted = json['deleted'];
    createdAt = json['createdAt'];
    dupdatedAt = json['dupdatedAt'];
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
    data['createdAt'] = createdAt;
    data['dupdatedAt'] = dupdatedAt;
    return data;
  }
}
