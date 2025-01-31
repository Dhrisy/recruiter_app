import 'package:flutter/material.dart';
import 'package:recruiter_app/features/resdex/data/seeker_repository.dart';
import 'package:recruiter_app/features/resdex/model/job_response_model.dart';

class InterviewProvider extends ChangeNotifier {
  bool isLoading = false;
  String message = '';
  List<JobResponseModel>? seekerLists;



  Future<bool?> scheduleInterview({
    required int candidateId,
    required int jobId,
    required String date,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await SeekerRepository().scheduleInterview(
          candidateId: candidateId, jobId: jobId, date: date);
      if (result != null && result == "success") {
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        message = result!;
        notifyListeners();
        return false;
      }
    } catch (e) {
      return false;
    }
  }

 Future<bool?> fetchScheduleInterview() async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await SeekerRepository().fetchInterviewScheduled();
       print(result);
      if (result != null && result["message"] == "success") {
        isLoading = false;
        seekerLists = result["list"];
        notifyListeners();
       
        return true;
      } else {
        message = result!["message"];
        notifyListeners();
        return false;
      }
    } catch (e) {
      return false;
    }
  }


}
