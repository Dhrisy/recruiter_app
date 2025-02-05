class ApiLists {
  static const String baseUrl = "https://job.emergiogames.com/api";
  static const String imageBaseUrl = "https://job.emergiogames.com/";

  static String registerEndPoint = "$baseUrl/user/register";
  static String mobieLoginEndPoint = "$baseUrl/user/mobile_login";
  static String emailLoginEndPoint = "$baseUrl/user/email_login";
  static String companyDetailAddEndPoint = "$baseUrl/company/";
  static String refreshTokenEndPoint = "$baseUrl/user/refresh";
  static String jobPostEndPoint = "$baseUrl/jobs/";
  static String deleteJobPostEndPoint = "$baseUrl/jobs/delete_job";
  static String mobileOtpRetryEndPoint = "$baseUrl/user/retry_otp";
  static String mobileOtpVerifyEndPoint = "$baseUrl/user/mobile_otp_verify";
  static String companyEndPoint = "$baseUrl/user/mobile_otp_verify";
  static String forgotPwEndPoint = "$baseUrl/user/forgot_password";
  static String allSeekersEndPoint = "$baseUrl/recruiter_actions/all_seekers";
  static String resdexSeekersEndPoint = "$baseUrl/recruiter_actions/resdex";
  static String respondedSeekerEndPoint =
      "$baseUrl/job-actions/job_applications";
  static String emailOtpVerifyEndPoint = "$baseUrl/user/email_verify";
  static String emailSentOtpEndPoint = "$baseUrl/user/send_email_otp";
  static String saveCandidateEndPoint =
      "$baseUrl/recruiter_actions/save_candidates";
  static String fetchSaveCandidateEndPoint =
      "$baseUrl/recruiter_actions/saved_candidates";
  static String createEmailTemaplteEndPoint =
      "$baseUrl/recruiter_actions/create_template";
  static String fetchEmailTemplated =
      "$baseUrl/recruiter_actions/email_templates";
  static String updateEmailTemplated =
      "$baseUrl/recruiter_actions/update_template";
  static String deleteEmailTemplated =
      "$baseUrl/recruiter_actions/delete_template";
  static String candidateInvitedEndpoint =
      "$baseUrl/recruiter_actions/candidates_invited";
  static String inviteEndpoint = "$baseUrl/recruiter_actions/invite_candidates";
  static String scheduleInterviewEndpoint =
      "$baseUrl/recruiter_actions/schedule_interview";

  static String updateJobPostEndPoint = "$baseUrl/jobs/edit";
  static String fetchScheduleInterviewEndpoint =
      "$baseUrl/recruiter_actions/interviews_scheduled";

  static String oneSignalEndPoint = "$baseUrl/user/onesignal";
  static String recruiterCountsEndPoint =
      "$baseUrl/recruiter_actions/recruiter_counts";
  static String editComapany = "$baseUrl/company/edit";
  static String suggestionEndPoint = "$baseUrl/common/suggestion";
  static String notification = "$baseUrl/common/notification";
  static String deleteNotification = "$baseUrl/common/delete_notification";
  static String updateJobApplications =
      "$baseUrl/job-actions/update_job_applications";
  static String fetchSubscriptions = "$baseUrl/common/subscriptions";
  static String editUser = "$baseUrl/user/";
    static String changePassword = "$baseUrl/user/change_password";

    static String banners = "$baseUrl/common/banners";
}
