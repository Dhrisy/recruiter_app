import 'package:recruiter_app/features/job_post/model/job_post_model.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';

class InvitedSeekerWithJob {
  final int? id;
  final SeekerModel seeker;
  final JobPostModel job;
  final bool read;

  InvitedSeekerWithJob({
    required this.seeker,
    required this.job,
    required this.read,
    this.id
  });

  factory InvitedSeekerWithJob.fromJson(Map<String, dynamic> json) {
   
    return InvitedSeekerWithJob(
      id: json["id"],
      seeker: SeekerModel.fromJson(json['candidate']),
      job: JobPostModel.fromJson(json['job']),
      read: json['read'] ?? false,
    );
  }
}