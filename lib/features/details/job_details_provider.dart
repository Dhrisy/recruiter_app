import 'package:flutter/material.dart';
import 'package:recruiter_app/features/details/job_details_repository.dart';
import 'package:recruiter_app/features/resdex/data/seeker_repository.dart';
import 'package:recruiter_app/features/resdex/model/interview_model.dart';
import 'package:recruiter_app/features/resdex/model/invite_seeker_model.dart';
import 'package:recruiter_app/features/resdex/model/job_response_model.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';

class JobDetailsProvider extends ChangeNotifier {
  List<JobResponseModel>? seekerLists;
  String message = '';
  bool isLoading = false;
 
  Map<String, dynamic>? seekersMap;
  

  Map<String, dynamic>? response;
  Future<List<SeekerModel>?>? lists;

// interview
  List<InterviewModel>? interviewedSeekerLists;
  String interviewMessage = '';

  // invited
  List<InvitedSeekerWithJob>? invitedSeekerLists;
  String invitedMessage = '';

  List<JobResponseModel>? filteredSeekerLists; // Filtered list

  Future<void> fetchSeekersJobApplied({required int? jobId}) async {
    try {
      final result =
          await JobDetailsRepository().fetchAllAppliedSeekers(jobId: jobId);
      if (result == null) {
        message = "error";

        notifyListeners();
      } else {
        // seekerLists = result["list"];
        filteredSeekerLists = result["list"];
        message = result["message"] == "success" ? "" : result["message"];

        notifyListeners();
      }

      print("tt   $message,  ${seekerLists}");
    } catch (e) {
      message = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchSeekersInvitedToJob({required int? jobId}) async {
    try {
      final result =
          await JobDetailsRepository().fetchInvitedSeekers(jobId: jobId);
      if (result == null) {
        invitedMessage = "error";

        notifyListeners();
      } else {
        invitedSeekerLists = result["list"];
        invitedMessage =
            result["message"] == "success" ? "" : result["message"];

        notifyListeners();
      }
    } catch (e) {
      invitedMessage = e.toString();
      notifyListeners();
    }
  }





  void filterSeekers({String? keyword, String? location, String? gender}) {
    if (filteredSeekerLists == null || filteredSeekerLists!.isEmpty) return;

    filteredSeekerLists = filteredSeekerLists!.where((seeker) {
      final matchesKeyword = keyword == null ||
          (seeker.seeker.personalData?.personal.city
                  ?.toLowerCase()
                  .contains(keyword.toLowerCase()) ??
              false);

      final matchesLocation = location == null ||
          (seeker.seeker.personalData?.personal.city
                  ?.toLowerCase()
                  .contains(location.toLowerCase()) ??
              false);
      print(seeker.seeker.personalData?.personal.gender?.toLowerCase());
      final matchesGender = gender == null ||
          (seeker.seeker.personalData?.personal.gender?.toLowerCase() ==
              gender.toLowerCase());

      return matchesKeyword && matchesLocation && matchesGender;
    }).toList();

    notifyListeners();
  }

  Future<void> fetchInterviewScheduledSeekers({ int? jobId}) async {
    try {
      final result =
          await JobDetailsRepository().fetchInterviewScheduledSeekers(jobId: jobId);
      if (result == null) {
        interviewMessage = "error";

        notifyListeners();
      } else {
        interviewedSeekerLists = result["list"];
        interviewMessage =
            result["message"] == "success" ? "" : result["message"];

        notifyListeners();
      }
    } catch (e) {
      interviewMessage = e.toString();
      notifyListeners();
    }
  }
}
