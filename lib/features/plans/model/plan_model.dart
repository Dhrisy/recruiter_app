class PlanModel {
    int id;
    String title;
    Description description;
    int posts;
    String duration;
    String audience;
    bool resdex;
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
        required this.resdex,
        required this.rate,
        required this.feature,
        required this.createdOn,
    });

factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
    id: json["id"] ?? 0,
    title: json["title"] ?? "",
    description: json["description"] != null 
        ? Description.fromJson(json["description"])
        : Description(),
    posts: json["posts"] ?? 0,
    duration: json["duration"] ?? "",
    audience: json["audience"] ?? "",
    resdex: json["resdex"] ?? false,
    rate: json["rate"] ?? 0,
    feature: json["feature"] ?? false,
    createdOn: json["created_on"] != null 
        ? DateTime.parse(json["created_on"])
        : DateTime.now(),
);

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description.toJson(),
        "posts": posts,
        "duration": duration,
        "audience": audience,
        "resdex": resdex,
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

    factory Description.fromJson(dynamic json) {
      if (json is String) {
        return Description(ss: json);
      }
      if (json is Map<String, dynamic>) {
        return Description(
          ss: json["ss"],
          descOne: json["descOne"],
          descTwo: json["descTwo"],
        );
      }
      return Description();
    }

    Map<String, dynamic> toJson() => {
        "ss": ss,
        "descOne": descOne,
        "descTwo": descTwo,
    };
}
