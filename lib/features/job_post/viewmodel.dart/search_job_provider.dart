import 'package:flutter/material.dart';
import 'package:recruiter_app/features/job_post/model/job_post_model.dart';

class SearchJobProvider extends ChangeNotifier {
  List<JobPostModel> _allJobs = [];
  List<JobPostModel> _filteredJobs = [];
  
  List<JobPostModel> get filteredJobs => _filteredJobs;
  List<JobPostModel> get allJobs => _allJobs;  // Added getter for _allJobs

  void setJobList(List<JobPostModel> jobs) {
    _allJobs = jobs;
    _filteredJobs = jobs;
    notifyListeners();
  }

  void searchJobs(String query) {
    if (query.isEmpty) {
      _filteredJobs = _allJobs;  // Fixed variable references
    } else {
      _filteredJobs = _allJobs.where((job) {
        final nameMatch = job.title.toString().toLowerCase().contains(query.toLowerCase());
        final roleMatch = job.functionalArea.toString().toLowerCase().contains(query.toLowerCase());
        return nameMatch || roleMatch;
      }).toList();
    }
    notifyListeners();
  }
}