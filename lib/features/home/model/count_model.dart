class CountModel {
  double profileCompletionPercentage;
  Map<String, dynamic> emptyModels;
  List<dynamic> modelsWithEmptyFields;
  int remainingJobsCount;
  int usedJobsCount;
  int interviewScheduledCount;
  int applicationCount;
  int activeJobsCount;
  int inactiveJobsCount;

  CountModel({
    required this.profileCompletionPercentage,
    required this.emptyModels,
    required this.modelsWithEmptyFields,
    required this.remainingJobsCount,
    required this.usedJobsCount,
    required this.interviewScheduledCount,
    required this.applicationCount,
    required this.activeJobsCount,
    required this.inactiveJobsCount,
  });

  factory CountModel.fromJson(Map<String, dynamic> json) {
    return CountModel(
        profileCompletionPercentage: json["profile_completion_percentage"],
        emptyModels: json["empty_models"],
        modelsWithEmptyFields: json["models_with_empty_fields"],
        remainingJobsCount: json["remaining_jobs_count"],
        usedJobsCount: json["used_jobs_count"],
        interviewScheduledCount: json["interview_scheduled_count"],
        applicationCount: json["application_count"],
        activeJobsCount: json["active_jobs_count"],
        inactiveJobsCount: json["inactive_jobs_count"]);
  }
}
