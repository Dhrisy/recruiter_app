import 'package:flutter/material.dart';
import 'package:recruiter_app/features/job_post/data/job_post_repository.dart';
import 'package:recruiter_app/features/job_post/model/job_post_model.dart';
import 'package:recruiter_app/features/settings/data/settings_repository.dart';
import 'package:recruiter_app/services/settings/suggestion_service.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';

class SettingsProvider with ChangeNotifier {
  final SuggestionService _feedbackService = SuggestionService();
  bool isDeleting = false;

  List<JobPostModel>? jobsLists;
  String message = '';
  Map<String, dynamic>? subcription;

  Future<void> submitFeedback(String suggestion, BuildContext context) async {
    try {
      final isSuccess = await _feedbackService.sendFeedback(suggestion);

      if (isSuccess) {
        CommonSnackbar.show(context,
            message: "Suggestion submitted successfully!");
      } else {
        CommonSnackbar.show(context,
            message: "Failed to submit suggestion. Please try again later.");
      }
    } catch (e) {
      CommonSnackbar.show(context, message: "An error occurred: $e");
    }
  }

  Future<void> fetchClosedJobs() async {
    try {
      final result = await JobPostRepository().fetchPostedJobs();
      if (result != null) {
        jobsLists = result.where((item) => item.status == false).toList();
        notifyListeners();
      } else {
        message = "Something went wrong!";
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      notifyListeners();
    }
  }



Future<Map<String, dynamic>?>   fetchSubscriptions() async{
  
}


Future<void> deleteAccount(BuildContext context) async {
    isDeleting = true; // Set loading state to true
    notifyListeners(); // Notify listeners to update the UI

    try {
      // Call the repository method to delete the account
      await SettingsRepository.deleteUser(context: context);

      // If successful, the repository will handle navigation and Snackbar
    } catch (e) {
      // Handle any errors that occur during the deletion process
      print("Error deleting account: $e");
    } finally {
      isDeleting = false; // Reset loading state
      notifyListeners(); // Notify listeners to update the UI
    }
  }


}
