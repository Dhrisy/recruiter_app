import 'package:recruiter_app/features/resdex/model/seeker_model.dart';

class InterviewModel {
  final int? id;
  final SeekerModel seekerData;
  final String? scheduledOn;
  final String? createdOn;

  InterviewModel(
      {this.id, required this.seekerData, this.createdOn, this.scheduledOn});

  factory InterviewModel.fromJson(Map<String, dynamic> json) {
    return InterviewModel(
        seekerData: SeekerModel.fromJson(json["candidate"]),
        id: json["id"],
        createdOn: json["created_on"] ?? "",
        scheduledOn: json["schedule"] ?? "");
  }
}
