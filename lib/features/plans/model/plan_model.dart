class PlanModel {
    int id;
    String title;
    Description description;
    int posts;
    String duration;
    String audience;
    int rate;
    bool feature;
    DateTime createdOn;

    PlanModel({
        required this.id,
        required this.title,
        required this.description,
        required this.posts,
        required this.duration,
        required this.audience,
        required this.rate,
        required this.feature,
        required this.createdOn,
    });

    factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
        id: json["id"],
        title: json["title"],
        description: Description.fromJson(json["description"]),
        posts: json["posts"],
        duration: json["duration"],
        audience: json["audience"],
        rate: json["rate"],
        feature: json["feature"],
        createdOn: DateTime.parse(json["created_on"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description.toJson(),
        "posts": posts,
        "duration": duration,
        "audience": audience,
        "rate": rate,
        "feature": feature,
        "created_on": createdOn.toIso8601String(),
    };
}

class Description {
    String? ss;
    String? descOne;
    String? descTwo;

    Description({
        this.ss,
        this.descOne,
        this.descTwo,
    });

    factory Description.fromJson(Map<String, dynamic> json) => Description(
        ss: json["ss"],
        descOne: json["descOne"],
        descTwo: json["descTwo"],
    );

    Map<String, dynamic> toJson() => {
        "ss": ss,
        "descOne": descOne,
        "descTwo": descTwo,
    };
}
