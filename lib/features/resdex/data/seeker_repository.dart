import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/features/job_post/model/job_post_model.dart';
import 'package:recruiter_app/features/resdex/model/invite_seeker_model.dart';
import 'package:recruiter_app/features/resdex/model/job_response_model.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';
import 'package:recruiter_app/main.dart';
import 'package:recruiter_app/services/refresh_token_service.dart';
import 'package:recruiter_app/services/seeker_services/search_seeker_service.dart';
import 'package:recruiter_app/services/seeker_services/seeker_service.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';

class SeekerRepository {
  Future<List<SeekerModel>?> fetchAllSeekers() async {
    try {
      final response = await SeekerService.fetchAllSeekers();
      print(
          "Response of fetch all seekers ${response.statusCode},  ${response.body}");
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);

        // Use SeekerModel.fromJson to directly convert each item
        List<SeekerModel> seekerData =
            responseData.map((item) => SeekerModel.fromJson(item)).toList();

        return seekerData;
      } else {
        return null;
      }
    } catch (e) {
      print("Unexpected error: $e");
      return null;
    }
  }

  Future<List<SeekerModel>?> searchSeeker({
    required List<String> keyWords,
    String experienceYear = "0",
    String experienceMonth = "0",
    String location = '',
    String nationality = '',
    String miniSalary = "0",
    String maxiSalary = "0",
    String gender = '',
    String education = '',
  }) async {
    try {
      final response = await SearchSeekerService().searchSeeker(
        keyWords: keyWords,
        education: education,
        experienceMonth: experienceMonth,
        experienceYear: experienceYear,
        gender: gender,
        location: location,
        maxiSalary: maxiSalary,
        miniSalary: miniSalary,
        nationality: nationality,
      );
      final _token =
          await CustomFunctions().retrieveCredentials("refresh_token");
      print("Response of $_token   ${response.statusCode},  ${response.body}");
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);

        // Use SeekerModel.fromJson to directly convert each item
        List<SeekerModel> seekerData =
            responseData.map((item) => SeekerModel.fromJson(item)).toList();

        return seekerData;
      } else {
        return null;
      }
    } catch (e) {
      print("repo catch error $e");
      return null;
    }
  }

  Future<List<JobResponseModel>?> fetchAllAppliedSeekers({
    int? jobId,
    int retryCount = 0,
    int maxRetries = 3,
  }) async {
    try {
      final response = await SeekerService.fetchRespondedSeeker(jobId: jobId);
      print(
          "Response of applied seeker ${response.statusCode}, ${response.body}");

      if (response.statusCode == 200) {
        // final List<dynamic>  responseData = jsonDecode(response.body);
        final List<dynamic> responseData = jsonDecode(response.body);
        // List<SeekerModel> seekerLists = responseData
        //     .map((item) => SeekerModel.fromJson(item['candidate']))
        //     .toList();

        List<JobResponseModel> seekerLists = responseData.map((item) => JobResponseModel.fromJson(item)).toList();

        return seekerLists;
      } else if (response.statusCode == 401) {
        await RefreshTokenService.refreshToken();
        return fetchAllAppliedSeekers(
          jobId: jobId,
          retryCount: retryCount + 1,
          maxRetries: maxRetries,
        );
      } 
      else {
        return null;
      }
    } catch (e) {
      print("error  $e");
      return null;
    }
  }



  // Future<List<SeekerModel>?> fetchAllAppliedSeekers({
  //   int? jobId,
  //   int retryCount = 0,
  //   int maxRetries = 3,
  // }) async {
  //   try {
  //     final response = await SeekerService.fetchRespondedSeeker(jobId: jobId);
  //     print(
  //         "Response of applied seeker ${response.statusCode}, ${response.body}");

  //     if (response.statusCode == 200) {
  //       // final List<dynamic>  responseData = jsonDecode(response.body);
  //       final List<dynamic> responseData = jsonDecode(response.body);
  //       List<SeekerModel> seekerLists = responseData
  //           .map((item) => SeekerModel.fromJson(item['candidate']))
  //           .toList();
  //       return seekerLists;
  //     } else if (response.statusCode == 401) {
  //       await RefreshTokenService.refreshToken();
  //       return fetchAllAppliedSeekers(
  //         jobId: jobId,
  //         retryCount: retryCount + 1,
  //         maxRetries: maxRetries,
  //       );
  //     } 
  //     else {
  //       return null;
  //     }
  //   } catch (e) {
  //     print("error  $e");
  //     return null;
  //   }
  // }




  Future<bool?> saveCandidate({
    required int id,
    required BuildContext context,
    int retryCount = 0,
    int maxRetries = 3,
  }) async {
    try {
      final response = await SeekerService.saveSeeker(id: id);
      
     final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        CommonSnackbar.show(context, message: responseData["message"]);
        return true;
      } else if (response.statusCode == 401 && retryCount < maxRetries) {
        await RefreshTokenService.refreshToken();
        return saveCandidate(
          context: context,
          id: id,
          retryCount: retryCount + 1,
          maxRetries: maxRetries,
        );
      } else {
        print(
            "Failed to save candidate: ${responseData['message'] ?? 'Unknown error'}");
        return false;
      }
    } catch (e, stackTrace) {
      print("Error in saveCandidate: $e");
      print("Stack trace: $stackTrace");
      return false;
    }
  }

// fetch saved candidates
  Future<List<SeekerModel>?> fetchSavedCandidate({
    int retryCount = 0,
    int maxRetries = 3,
  }) async {
    try {
      final response = await SeekerService.fetchSavedSeeker();
      log("Response of fetch save seeker: ${response.statusCode}, ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);

        // Use SeekerModel.fromJson to directly convert each item
        List<SeekerModel> seekerData =
            responseData.map((item) => SeekerModel.fromJson(item)).toList();

        return seekerData;
      } else if (response.statusCode == 401 && retryCount < maxRetries) {
        await RefreshTokenService.refreshToken();
        return fetchSavedCandidate();
      } else {
        print("Failed to save candidate: ");
        return null;
      }
    } catch (e, stackTrace) {
      print("Error in saveCandidate: $e");
      print("Stack trace: $stackTrace");
      return null;
    }
  }

// fetch invited candidates
  Future<List<InvitedSeekerWithJob>?> fetchAllInvitedSeekers({
    String? jobId,
    int retryCount = 0,
    int maxRetries = 3,
  }) async {
    try {
      final response = await SeekerService.fetchInvitedCandidates();
      print(
          "Response of invited seeker ${response.statusCode}, ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
       
        print(responseData.runtimeType);
        List<InvitedSeekerWithJob> seekerWithJobList = responseData
            .map((dynamic item) =>
                InvitedSeekerWithJob.fromJson(Map<String, dynamic>.from(item)))
            .toList();

        return seekerWithJobList;
      } else if (response.statusCode == 401) {
        await RefreshTokenService.refreshToken();
        return fetchAllInvitedSeekers(
          jobId: jobId,
          retryCount: retryCount + 1,
          maxRetries: maxRetries,
        );
      } else {
        return null;
      }
    } catch (e) {
      print("error  $e");
      return null;
    }
  }

  // delete invited seeker
  Future<String?> deleteInvitedSeeker({
    required int id,
    int retryCount = 0,
    int maxRetries = 3,
  }) async {
    try {
      final response = await SeekerService.deleteInvitedCandidate(id: id);
      print("delete invite ${response.statusCode},  ${response.body}");

      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        await RefreshTokenService.refreshToken();
        return deleteInvitedSeeker(
          id: id,
          retryCount: retryCount + 1,
          maxRetries: maxRetries,
        );
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        return responseData["message"];
      }
    } catch (e) {
      return null;
    }
  }



  // schedule interview
  Future<String?>  scheduleInterview({
    required int candidateId,
    required int jobId,
    required String date,
    int retryCount = 0,
    int maxRetries = 3,

  }) async{
    try {
      final response = await SeekerService.scheduleInterviewCandidate(jobId: jobId, seekerId: candidateId, date: date);
      print("Response of schedule interview ${response.statusCode},  ${response.body}");
      if(response.statusCode == 200){
        return "success";
      }else if(response.statusCode == 401){
        await RefreshTokenService.refreshToken();
        return scheduleInterview(
          candidateId: candidateId, jobId: jobId, date: date, retryCount: retryCount + 1, maxRetries: maxRetries);

      }else{
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData["message"];
      }

    } catch (e) {
      return e.toString();
    }
  }
}
