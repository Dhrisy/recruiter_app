import 'package:recruiter_app/features/job_post/model/job_post_model.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';

class JobResponseModel {
  final int id;
  final SeekerModel seeker;
  final JobPostModel job;

  JobResponseModel({required this.id, required this.seeker, required this.job});

  factory JobResponseModel.fromJson(Map<String, dynamic> json) {
    return JobResponseModel(
        id: json["id"], 
        seeker: SeekerModel.fromJson(json["candidate"]),
        job: JobPostModel.fromJson(json["job"])
        );
  }
}
