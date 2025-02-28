import 'package:recruiter_app/features/job_post/model/job_post_model.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';

class JobResponseModel {
  final int id;
  final SeekerModel seeker;
  final JobPostModel job;
  final String status;
  final String viewed;

  JobResponseModel(
      {required this.id,
      required this.seeker,
      required this.job,
      required this.status,
      required this.viewed});

  factory JobResponseModel.fromJson(Map<String, dynamic> json) {
    return JobResponseModel(
        id: json["id"] ?? 0,
        viewed: json["viewed"].toString(),
        status: json["status"] ?? "",
        seeker: SeekerModel.fromJson(json["candidate"]),
        job: JobPostModel.fromJson(json["job"]));
  }
}
