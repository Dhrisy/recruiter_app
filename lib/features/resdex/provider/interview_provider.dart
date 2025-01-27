import 'package:flutter/material.dart';
import 'package:recruiter_app/features/resdex/data/seeker_repository.dart';

class InterviewProvider extends ChangeNotifier {
  bool isLoading = false;
  String message = '';

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
}
