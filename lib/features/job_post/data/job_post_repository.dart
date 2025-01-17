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
        print("Response: ${response.statusCode}, ${response.body}");

        if (response.statusCode == 201) {
          return "success";
        } else if (response.statusCode == 401) {
          print("Unauthorized, attempting token refresh...");
          await RefreshTokenService.refreshToken();
          final response2 = await JobsService.jobPost(job: job);
          if (response2 != null) {
            print("Retry Response: ${response2.statusCode}, ${response2.body}");

            if (response2.statusCode == 201) {
              return "Job posted successfully!";
            } else {
              print("Failed to post job. Status: ${response.statusCode}");
              return "Something went wrong";
            }
          }
        } else {
          print("Unexpected error occurred. Status: ${response.statusCode}");
          return "Something went wrong";
        }
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
      log("Response of added jobs: ${response.statusCode}, ${response.body}");

      // Handle the success response
      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        List<JobPostModel> jobsList =
            responseData.map((job) => JobPostModel.fromJson(job)).toList();
        return jobsList;
      }

      // Handle unauthorized error and retry only for 401
      if (response.statusCode == 401 && retryCount < maxRetries) {
        print("Unauthorized (401). Refreshing token and retrying...");
        await RefreshTokenService.refreshToken();
        return fetchPostedJobs(
            retryCount: retryCount + 1,
            maxRetries: maxRetries); // Recursive call for 401
      }

      // Handle other failure cases
      print("Failed to fetch jobs. Status: ${response.statusCode}");
      return null;
    } catch (e) {
      print("An error occurred: $e");
      return null; // Return null in case of exceptions
    }
  }

  // Future<List<JobPostModel>?> fetchPostedJobs(
  //     {int retryCount = 0, int maxRetries = 3}) async {
  //   try {
  //     // Attempt to fetch the posted jobs
  //     var response = await JobsService.fetchPostedJobs();
  //     print("Response of added jobs: ${response.statusCode}, ${response.body}");

  //     // Handle the success response
  //     if (response.statusCode == 200) {
  //       List<dynamic> responseData = jsonDecode(response.body);
  //       List<JobPostModel> jobsList =
  //           responseData.map((job) => JobPostModel.fromJson(job)).toList();

  //       return jobsList;
  //     }

  //     // Handle unauthorized error and attempt token refresh
  //     else if (response.statusCode == 401) {
  //       await RefreshTokenService.refreshToken();
  //       return fetchPostedJobs(
  //           retryCount: retryCount + 1,
  //           maxRetries: maxRetries); // Recursive call after token refresh
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     print("An error occurred: $e");

  //     // Retry logic
  //     if (retryCount < maxRetries) {
  //       print("Retrying... Attempt ${retryCount + 1} of $maxRetries");
  //       return fetchPostedJobs(
  //           retryCount: retryCount + 1,
  //           maxRetries: maxRetries); // Recursive call for retry
  //     } else {
  //       print("Max retry attempts reached. Unable to fetch jobs.");
  //       return null;
  //     }
  //   }
  // }
}
