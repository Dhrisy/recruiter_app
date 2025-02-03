class NotificationModel {
  int id;
  Noti noti;
  bool read;

  NotificationModel({
    required this.id,
    required this.noti,
    required this.read,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        noti: Noti.fromJson(json["noti"]),
        read: json["read"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "noti": noti.toJson(),
        "read": read,
      };
}

class Noti {
  String title;
  String description;
  String image;
  String url;
  DateTime createdOn;

  Noti({
    required this.title,
    required this.description,
    required this.image,
    required this.url,
    required this.createdOn,
  });

  factory Noti.fromJson(Map<String, dynamic> json) => Noti(
        title: json["title"],
        description: json["description"],
        image: json["image"],
        url: json["url"],
        createdOn: DateTime.parse(json["created_on"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "image": image,
        "url": url,
        "created_on": createdOn.toIso8601String(),
      };
}