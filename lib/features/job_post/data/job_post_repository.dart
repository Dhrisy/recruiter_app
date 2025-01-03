import 'package:recruiter_app/features/job_post/model/job_post_model.dart';
import 'package:recruiter_app/services/jobs_service.dart';
import 'package:recruiter_app/services/refresh_token_service.dart';

class JobPostRepository {
  Future<String?> jobPostRepository({required JobPostModel job}) async {
    try {
      var response = await JobsService.jobPost(job: job);
      print("Response: ${response.statusCode}, ${response.body}");

      if (response.statusCode == 201) {
        return "success";
      } else if (response.statusCode == 401) {
        print("Unauthorized, attempting token refresh...");
        await RefreshTokenService.refreshToken();
        response = await JobsService.jobPost(job: job);
        print("Retry Response: ${response.statusCode}, ${response.body}");

        if (response.statusCode == 201) {
          return "Job posted successfully!";
        } else {
          print("Failed to post job. Status: ${response.statusCode}");
          return "Something went wrong";
        }
      } else {
        print("Unexpected error occurred. Status: ${response.statusCode}");
        return "Something went wrong";
      }
    } catch (e) {
      print("Error in job post: $e");
      rethrow;
    }
  }
}
