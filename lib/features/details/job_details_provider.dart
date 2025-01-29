import 'package:flutter/material.dart';
import 'package:recruiter_app/features/details/job_details_repository.dart';
import 'package:recruiter_app/features/resdex/data/seeker_repository.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';

class JobDetailsProvider extends ChangeNotifier {
  List<SeekerModel>? seekerLists;
  String message = '';

  List<SeekerModel>? invitedSeekersLists;
  Map<String, dynamic>? seekersMap;
  String invitedMessage = '';

  Map<String, dynamic>? response;

  Future<void> fetchSeekersJobApplied({required int? jobId}) async {
    try {
      final result =
          await JobDetailsRepository().fetchAllAppliedSeekers(jobId: jobId);
      if (result == null) {
        message = "error";

        notifyListeners();
      } else {
        seekerLists = result["list"];
        message = result["message"] == "success" ? "" : result["message"];

        notifyListeners();
      }
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
        invitedSeekersLists = result["list"];
        invitedMessage =
            result["message"] == "success" ? "" : result["message"];

        notifyListeners();
      }
    } catch (e) {
      invitedMessage = e.toString();
      notifyListeners();
    }
  }
}
