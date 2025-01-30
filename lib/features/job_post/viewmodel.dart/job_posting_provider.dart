import 'package:flutter/material.dart';
import 'package:recruiter_app/features/job_post/data/job_post_repository.dart';
import 'package:recruiter_app/features/job_post/model/job_post_model.dart';

class JobPostingProvider extends ChangeNotifier {
  List<JobPostModel>? jobLists;
  String error = '';
  List<JobPostModel> allJobs = [];
  List<JobPostModel> filteredJobs = [];
  bool isLoading = false;
  String searchQuery = '';

  void setSearchQuery(String query) {
    searchQuery = query;
    filterJobs();
    notifyListeners();
  }

  Future<void> fetchJobLists() async {
    try {
      final result = await JobPostRepository().fetchPostedJobs();
      if (result != null) {
        jobLists = result;
        allJobs = result;
        notifyListeners();
      } else {
        error = "error";
        notifyListeners();
      }
    } catch (e) {}
  }

  void filterJobs() {
    if (searchQuery.isEmpty) {
     filteredJobs = List.from(allJobs);
    } else {
     filteredJobs = allJobs.where((job) {
        final name = job.title?.toLowerCase() ?? '';
        // final email = seeker.seeker.personalData?.user.email?.toLowerCase() ?? '';
        // final phone = seeker.seeker.personalData?.user.phoneNumber?.toLowerCase() ?? '';
        // final query = _searchQuery.toLowerCase();

        return name.contains(searchQuery) 
        // ||
        //     email.contains(query) ||
        //     phone.contains(query)
            ;
      }).toList();
    }
  }

  Future<String?> postJob({required JobPostModel jobData}) async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await JobPostRepository().jobPostRepository(job: jobData);
      isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      print(e);
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<String?> editJobPost({required JobPostModel job}) async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await JobPostRepository().editJobPostRepository(job: job);
      isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      print(e);
      isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
