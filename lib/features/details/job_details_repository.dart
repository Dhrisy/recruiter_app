import 'dart:convert';

import 'package:recruiter_app/features/resdex/model/seeker_model.dart';
import 'package:recruiter_app/services/refresh_token_service.dart';
import 'package:recruiter_app/services/seeker_services/seeker_service.dart';

class JobDetailsRepository {
  Future<Map<String, dynamic>?> fetchAllAppliedSeekers({
    int? jobId,
    int retryCount = 0,
    int maxRetries = 3,
  }) async {
    try {
      final response = await SeekerService.fetchRespondedSeeker(jobId: jobId);
print("respnse fo applied seekers ${response.body}");
      if (response.statusCode == 200) {
        // final List<dynamic>  responseData = jsonDecode(response.body);
        final List<dynamic> responseData = jsonDecode(response.body);
        List<SeekerModel> seekerLists = responseData
            .map((item) => SeekerModel.fromJson(item['candidate']))
            .toList();
        return {"list": seekerLists, "message": "success"};
      } else if (response.statusCode == 401) {
        await RefreshTokenService.refreshToken();
        return fetchAllAppliedSeekers(
          jobId: jobId,
          retryCount: retryCount + 1,
          maxRetries: maxRetries,
        );
      } else if (response.statusCode == 409) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return {"message": responseData["message"]};
      } else {
        return null;
      }
    } catch (e) {
      print("error  $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchInvitedSeekers({
    int? jobId,
    int retryCount = 0,
    int maxRetries = 3,
  }) async {
    try {
      final response = await SeekerService.fetchInvitedCandidates(jobId: jobId);

      if (response.statusCode == 200) {
        // final List<dynamic>  responseData = jsonDecode(response.body);
        final List<dynamic> responseData = jsonDecode(response.body);
        List<SeekerModel> seekerLists = responseData
            .map((item) => SeekerModel.fromJson(item['candidate']))
            .toList();
        return {"list": seekerLists, "message": "success"};
      } else if (response.statusCode == 401) {
        await RefreshTokenService.refreshToken();
        return fetchInvitedSeekers(
          jobId: jobId,
          retryCount: retryCount + 1,
          maxRetries: maxRetries,
        );
      } else if (response.statusCode == 409) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return {"message": responseData["message"]};
      } else {
        return null;
      }
    } catch (e) {
      print("error  $e");
      return null;
    }
  }



   Future<Map<String, dynamic>?> fetchInterviewScheduledSeekers({
    int? jobId,
    int retryCount = 0,
    int maxRetries = 3,
  }) async {
    try {
      final response = await SeekerService.fetchInvitedCandidates(jobId: jobId);

      if (response.statusCode == 200) {
        // final List<dynamic>  responseData = jsonDecode(response.body);
        final List<dynamic> responseData = jsonDecode(response.body);
        List<SeekerModel> seekerLists = responseData
            .map((item) => SeekerModel.fromJson(item['candidate']))
            .toList();
        return {"list": seekerLists, "message": "success"};
      } else if (response.statusCode == 401) {
        await RefreshTokenService.refreshToken();
        return fetchInvitedSeekers(
          jobId: jobId,
          retryCount: retryCount + 1,
          maxRetries: maxRetries,
        );
      } else if (response.statusCode == 409) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return {"message": responseData["message"]};
      } else {
        return null;
      }
    } catch (e) {
      print("error  $e");
      return null;
    }
  }
}
