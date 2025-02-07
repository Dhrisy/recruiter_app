import 'dart:convert';
import 'dart:developer';

import 'package:recruiter_app/features/job_post/model/job_post_model.dart';
import 'package:recruiter_app/services/jobs_service.dart';
import 'package:recruiter_app/services/refresh_token_service.dart';

class JobPostRepository {
  Future<String?> jobPostRepository({required JobPostModel job}) async {
    try {
      var response = await JobsService.jobPost(job: job);
      if (response != null) {
        if (response.statusCode == 201) {
          return "success";
        } else if (response.statusCode == 401) {
          await RefreshTokenService.refreshToken();
          final response2 = await JobsService.jobPost(job: job);
          if (response2 != null) {
            if (response2.statusCode == 201) {
              return "Job posted successfully!";
            } else {
              return "Something went wrong";
            }
          } else {
            return null;
          }
        } else {
          print("Unexpected error occurred. Status: ${response.statusCode}");
          return "Something went wrong";
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Error in job post: $e");
      rethrow;
    }
  }

  Future<List<JobPostModel>?> fetchPostedJobs(
      {int retryCount = 0, int maxRetries = 3}) async {
    try {
      // Attempt to fetch posted jobs
      var response = await JobsService.fetchPostedJobs();

    

      // Handle the success response
      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        List<JobPostModel> jobsList =
            responseData.map((job) => JobPostModel.fromJson(job)).toList();
            
        return jobsList;
      }

      // Handle unauthorized error and retry only for 401
      if (response.statusCode == 401 && retryCount < maxRetries) {
        await RefreshTokenService.refreshToken();
        return fetchPostedJobs(
            retryCount: retryCount + 1,
            maxRetries: maxRetries); // Recursive call for 401
      }
      return null;
    } catch (e) {
      return null; // Return null in case of exceptions
    }
  }

  Future<String?> editJobPostRepository(
      {required JobPostModel job,
      int retryCount = 0,
      int maxRetries = 3}) async {
    try {
      var response = await JobsService.editJobPost(job: job);
      print("Response of edit job ${response.body}");
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        await RefreshTokenService.refreshToken();
        return editJobPostRepository(
            job: job, retryCount: retryCount + 1, maxRetries: maxRetries);
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        return responseData["message"];
      }
    } catch (e) {
      print("Error in job post: $e");
      rethrow;
    }
  }

  Future<String?> deleteJobPostRepository(
      {required int jobId, int retryCount = 0, int maxRetries = 3}) async {
    try {
      var response = await JobsService.deleteJob(jobId: jobId);
      print("Response of delete job ${response.body}");
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        await RefreshTokenService.refreshToken();
        return deleteJobPostRepository(
            jobId: jobId, retryCount: retryCount + 1, maxRetries: maxRetries);
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        return responseData["message"];
      }
    } catch (e) {
      print("Error indelete job: $e");
      rethrow;
    }
  }
}
