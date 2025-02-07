class SubscriptionModel {
  final int? id;
  final PlanModel plan;
  final int remainingPosts;
  final String transactionId;
  final String subscribedOn;

  SubscriptionModel({
    this.id,
    required this.subscribedOn,
    required this.plan,
    required this.remainingPosts,
    required this.transactionId,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
        subscribedOn: json["subscribed_on"],
        plan: PlanModel.fromJson(json["plan"]),
        remainingPosts: json["remaining_posts"],
        transactionId: json["transaction_id"],
        id: json["id"]);
  }
}

class PlanModel {
  final int? id;
  final String title;
  final Map<String, dynamic> description;
  final int numberOfPosts;
  final String duration;
  final int price;
  final bool isFeatured;
  final String? createdOn;

  PlanModel(
      {this.id,
      this.createdOn,
      required this.description,
      required this.duration,
      required this.isFeatured,
      required this.numberOfPosts,
      required this.price,
      required this.title});

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
        description: json["description"],
        duration: json["duration"],
        isFeatured: json["feature"],
        numberOfPosts: json["posts"],
        price: json["rate"],
        title: json["title"],
        createdOn: json["created_on"],
        id: json["id"]);
  }
}
